import 'package:burgundy_budgeting_app/domain/model/request/transactions_page_request.dart';
import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/category_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_state.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/model/transactions_filter_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transactions_statistics_model.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class BankAccountsAndStatisticsBloc extends Bloc<BankAccountsAndStatisticsEvent,
    BankAccountsAndStatisticsState> {
  final Logger logger = getLogger('Accounts and Statistics Bloc');
  final AccountsTransactionsRepository accountsTransactionsRepository;
  final CategoryRepository categoryRepository;
  TransactionFiltersModel? initialFilters;

  TransactionType? bulkType;

  final bulkTransactions = <TransactionModel>[];

  BankAccountsAndStatisticsBloc(
      this.accountsTransactionsRepository, this.categoryRepository,
      {this.initialFilters})
      : super(BankAccountsAndStatisticsInitial()) {
    logger.i('Transactions Page');
    add(BankAccountInitialLoadingEvent());
  }

  @override
  Stream<BankAccountsAndStatisticsState> mapEventToState(
      BankAccountsAndStatisticsEvent event) async* {
    if (event is BankAccountInitialLoadingEvent) {
      yield* loadInitialData(event);
    }

    if (state is BankAccountsAndStatisticsLoaded) {
      var currentFilters =
          (state as BankAccountsAndStatisticsLoaded).transactionFiltersModel;
      if (event is ToggleUnbudgetedEvent) {
        yield* changeFilters(
          currentFilters.copyWith(unbudgeted: event.unbudgeted),
        );
      } else if (event is BankAccountSelectedEvent) {
        yield* selectCard(event, currentFilters);
      } else if (event is SearchTransactionEvent) {
        yield* changeFilters(
          currentFilters.copyWith(textSearch: event.searchText),
        );
      } else if (event is ChangeUsageTypeEvent) {
        yield* changeFilters(
          currentFilters.copyWith(
            usageType: event.usageType,
            shouldEraseCategories: true,
            shouldEraseUsageType: event.usageType == 0,
          ),
        );
      } else if (event is SortByEvent) {
        clearBulk();
        yield* changeFilters(
          currentFilters.copyWith(
            sortingBy: event.sortBy,
            sortingOrder: event.sortOrder,
          ),
        );
      } else if (event is SetStartDate) {
        yield* changeFilters(
          currentFilters.copyWith(periodStart: event.startDate),
        );
      } else if (event is SetEndDate) {
        yield* changeFilters(
          currentFilters.copyWith(periodEnd: event.endDate),
        );
      } else if (event is SelectParentCategoryFilterEvent) {
        yield* changeFilters(
          currentFilters.copyWith(
              category: event.parentCategory, shouldEraseSubcategory: true),
        );
      } else if (event is SelectChildCategoryFilterEvent) {
        yield* changeFilters(
          currentFilters.copyWith(subCategory: event.childCategory),
        );
      } else if (event is ClearAllFiltersEvent) {
        clearBulk();
        yield* changeFilters(
          TransactionFiltersModel.initial(),
        );
      } else if (event is TransactionPageChanged) {
        yield* changePage(event.newPageNumber);
      } else if (event is TransactionNoteErrorEvent) {
        var prevState = state;
        yield BankAccountsAndStatisticsError(event.error);
        yield prevState;
      } else if (event is TransactionCategoryChanged) {
        yield* setTransactionCategory(event.categoryId, event.transactionId,
            event.shouldBeRemembered, event.previousCategoryId);
      } else if (event is SplitTransactionEvent) {
        clearBulk();
        yield* splitTransaction(event);
      } else if (event is UniteTransactionsEvent) {
        clearBulk();
        yield* uniteTransactions(event.splitTransactionId);
      } else if (event is TransactionPageRebuildsEvent) {
        clearBulk();
        yield* updateTransactionsList();
      } else if (event is DateFilterTransactionEvent) {
        yield* setDateRangeFilter(event);
      }
    }
  }

  Stream<BankAccountsAndStatisticsState> loadInitialData(
      BankAccountInitialLoadingEvent event) async* {
    try {
      var accounts = await accountsTransactionsRepository.getBankAccounts();
      var filtersModel =
          await accountsTransactionsRepository.getFilterParameters();
      logger.i('Loaded ${accounts.length} bank accounts');
      var statisticsModel = await fetchStatistics(
        transactionFiltersModel:
            initialFilters ?? TransactionFiltersModel.initial(),
      );
      var categoriesModel = await categoryRepository.fetchCategoryManagement();
      var transactionList = await getTransactionList(
        transactionFiltersModel:
            initialFilters ?? TransactionFiltersModel.initial(),
        pageNumber: 1,
      );
      yield BankAccountsAndStatisticsLoaded(
        accounts,
        statisticsModel,
        transactionFiltersModel:
            initialFilters ?? TransactionFiltersModel.initial(),
        categoriesModel: categoriesModel,
        filterParametersModel: filtersModel,
        transactionList: transactionList,
      );
    } catch (e) {
      yield BankAccountsAndStatisticsError(e.toString());
      rethrow;
    }
  }

  Stream<BankAccountsAndStatisticsState> changeFilters(
    TransactionFiltersModel transactionFiltersModel,
  ) async* {
    if (state is BankAccountsAndStatisticsLoaded) {
      var loadedState = state as BankAccountsAndStatisticsLoaded;
      try {
        var statisticsModel = await fetchStatistics(
          transactionFiltersModel: transactionFiltersModel,
        );
        var transactionList = await getTransactionList(
          transactionFiltersModel: transactionFiltersModel,
          pageNumber: 1,
        );
        clearBulk();
        yield loadedState.copyWith(
          statisticsModel: statisticsModel,
          transactionFiltersModel: transactionFiltersModel,
          transactionList: transactionList,
        );
      } catch (e) {
        yield BankAccountsAndStatisticsError(e.toString());
        yield loadedState;
        rethrow;
      }
    }
  }

  Stream<BankAccountsAndStatisticsState> selectCard(
      BankAccountSelectedEvent event,
      TransactionFiltersModel currentFilters) async* {
    var newFilters;
    var loadedState = state as BankAccountsAndStatisticsLoaded;
    try {
      if ((state as BankAccountsAndStatisticsLoaded)
              .transactionFiltersModel
              .selectedBankAccountId ==
          event.bankAccountId) {
        logger.i(
          'User removed selection from account id ${event.bankAccountId}',
        );
        newFilters = (state as BankAccountsAndStatisticsLoaded)
            .transactionFiltersModel
            .copyWith(
              shouldUnselectBankAccount: true,
            );
      } else {
        var newSelectedAccountId = event.bankAccountId;
        logger.i('User selected account id ${event.bankAccountId}');
        newFilters = (state as BankAccountsAndStatisticsLoaded)
            .transactionFiltersModel
            .copyWith(
              selectedBankAccountId: newSelectedAccountId,
            );
      }

      var statisticsModel = await fetchStatistics(
        transactionFiltersModel: newFilters,
      );

      var transactionList = await getTransactionList(
        pageNumber: 1,
        transactionFiltersModel: newFilters,
      );

      yield loadedState.copyWith(
        statisticsModel: statisticsModel,
        transactionFiltersModel: newFilters,
        transactionList: transactionList,
      );
    } catch (e) {
      yield BankAccountsAndStatisticsError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Future<TransactionsStatisticsModel> fetchStatistics({
    required TransactionFiltersModel transactionFiltersModel,
  }) async {
    var statsResponse = await accountsTransactionsRepository.getStatistics(
      transactionFiltersModel: transactionFiltersModel,
    );
    return statsResponse;
  }

  Future<TransactionListModel> getTransactionList({
    required int pageNumber,
    required TransactionFiltersModel transactionFiltersModel,
  }) async {
    var transactionList = await accountsTransactionsRepository
        .getTransactionPage(TransactionsPageRequest(
      pageNumber: pageNumber,
      transactionFiltersModel: transactionFiltersModel,
    ));
    logger.i(
        'Loaded ${transactionList.transactions.length} transactions, page ${transactionList.pageNumber} of ${transactionList.totalPages}');
    return transactionList;
  }

  Stream<BankAccountsAndStatisticsState> setTransactionCategory(
      String categoryId,
      String transactionId,
      bool shouldBeRemembered,
      String? previousCategoryId) async* {
    var loadedState = state as BankAccountsAndStatisticsLoaded;

    try {
      var transactionIds = <String>[];
      if (bulkTransactions
          .where((element) => element.id == transactionId)
          .isNotEmpty) {
        bulkTransactions.forEach((element) {
          transactionIds.add(element.id);
        });
        clearBulk();
      } else {
        transactionIds = [transactionId];
      }
      var isSuccessful =
          await accountsTransactionsRepository.setTransactionCategory(
              categoryId, transactionIds, shouldBeRemembered);
      logger.i(
          'Transaction(s) moved to category $categoryId, should Be Remembered - $shouldBeRemembered');
      if (!isSuccessful) {
        yield BankAccountsAndStatisticsError(
          accountsTransactionsRepository.generalErrorMessage,
        );
        yield loadedState;
      }
      var transactionsList = await getTransactionList(
        pageNumber: loadedState.transactionPageNumber,
        transactionFiltersModel: loadedState.transactionFiltersModel,
      );
      // because it could get additional category for filter
      var filtersModel =
          await accountsTransactionsRepository.getFilterParameters();

      //statistics could be affected by ignore
      var statisticsModel = loadedState.statisticsModel;
      if (categoryId == 'aead5351-3fd8-4a0a-8feb-2f9d4798728e' ||
          previousCategoryId == 'aead5351-3fd8-4a0a-8feb-2f9d4798728e') {
        statisticsModel = await accountsTransactionsRepository.getStatistics(
            transactionFiltersModel: loadedState.transactionFiltersModel);
      }
      clearBulk();
      yield loadedState.copyWith(
        filterParametersModel: filtersModel,
        transactionList: transactionsList,
        statisticsModel: statisticsModel,
      );
    } catch (e) {
      yield BankAccountsAndStatisticsError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<BankAccountsAndStatisticsState> splitTransaction(
      SplitTransactionEvent event) async* {
    var loadedState = state as BankAccountsAndStatisticsLoaded;
    try {
      bulkTransactions
          .removeWhere((element) => element.id == event.transactionIdToSplit);
      var isSuccessful = await accountsTransactionsRepository.splitTransactions(
          transactionIdToSplit: event.transactionIdToSplit,
          childsOfSplit: event.childsOfSplit,
          shouldBeRemembered: event.shouldBeRemembered);
      logger.i('Transaction ${event.transactionIdToSplit} was splitted');
      if (!isSuccessful) {
        yield BankAccountsAndStatisticsError(
          accountsTransactionsRepository.generalErrorMessage,
        );
      }
      var transactionsList = await getTransactionList(
        pageNumber: loadedState.transactionPageNumber,
        transactionFiltersModel: loadedState.transactionFiltersModel,
      );
      // because it could get additional category for filter
      var filtersModel =
          await accountsTransactionsRepository.getFilterParameters();

      yield loadedState.copyWith(
        filterParametersModel: filtersModel,
        transactionList: transactionsList,
      );
    } catch (e) {
      yield BankAccountsAndStatisticsError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<BankAccountsAndStatisticsState> uniteTransactions(String id) async* {
    var loadedState = state as BankAccountsAndStatisticsLoaded;
    try {
      var isSuccessful =
          await accountsTransactionsRepository.uniteTransactions(id);
      logger.i('Transactions were united into $id');
      if (!isSuccessful) {
        yield BankAccountsAndStatisticsError(
          accountsTransactionsRepository.generalErrorMessage,
        );
      }
      var transactionsList = await getTransactionList(
        pageNumber: loadedState.transactionPageNumber,
        transactionFiltersModel: loadedState.transactionFiltersModel,
      );
      // because it could impact categories for filter
      var filtersModel =
          await accountsTransactionsRepository.getFilterParameters();
      yield loadedState.copyWith(
        filterParametersModel: filtersModel,
        transactionList: transactionsList,
      );
    } catch (e) {
      yield BankAccountsAndStatisticsError(e.toString());
      yield loadedState;
      rethrow;
    }
  }

  Stream<BankAccountsAndStatisticsState> changePage(int newPageNumber) async* {
    var loadedState = state as BankAccountsAndStatisticsLoaded;
    var transactionsList = await getTransactionList(
      pageNumber: newPageNumber,
      transactionFiltersModel:
          (state as BankAccountsAndStatisticsLoaded).transactionFiltersModel,
    );

    yield loadedState.copyWith(
      transactionList: transactionsList,
    );
  }

  Future<MemoNoteModel?> setTransactionNote(
      SetTransactionNoteEvent event) async {
    try {
      var isSuccessful =
          await accountsTransactionsRepository.setTransactionNote(
        event.note,
        event.transactionId,
      );
      if (isSuccessful && event.shouldFetch) {
        return await accountsTransactionsRepository
            .fetchNote(event.transactionId);
      }
    } catch (e) {
      add(TransactionNoteErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<bool?> deleteTransactionNote(DeleteTransactionNoteEvent event) async {
    try {
      return await accountsTransactionsRepository.deleteTransactionNote(
        event.transactionId,
      );
    } catch (e) {
      add(TransactionNoteErrorEvent(e.toString()));
      rethrow;
    }
  }

  Stream<BankAccountsAndStatisticsState> updateTransactionsList() async* {
    var loadedState = (state as BankAccountsAndStatisticsLoaded);
    yield BankAccountsAndStatisticsInitial();
    yield loadedState.copyWith(
      transactionList: await getTransactionList(
        pageNumber: loadedState.transactionPageNumber,
        transactionFiltersModel: loadedState.transactionFiltersModel,
      ),
    );
  }

  Future<MemoNotesPage> fetchNotePage(String transactionId) async {
    var note = await accountsTransactionsRepository.fetchNote(transactionId);
    return MemoNotesPage.transaction(note);
  }

  Future<String?> addReply({
    required String note,
    required String noteId,
  }) async {
    try {
      return await accountsTransactionsRepository.addNoteReply(
          note: note, noteId: noteId);
    } catch (e) {
      add(TransactionNoteErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<void> editNoteReply({
    required String replyId,
    required String replyText,
  }) async {
    try {
      await accountsTransactionsRepository.editTransactionNoteReply(
          replyText, replyId);
    } catch (e) {
      add(TransactionNoteErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteNoteReply({
    required String replyId,
  }) async {
    try {
      await accountsTransactionsRepository.deleteTransactionNoteReply(replyId);
    } catch (e) {
      add(TransactionNoteErrorEvent(e.toString()));
      rethrow;
    }
  }

  void addTransactionToBulk(TransactionModel transaction) {
    bulkType = transaction.transactionType;
    bulkTransactions.add(transaction);
  }

  void removeTransactionFromBulk(TransactionModel transaction) {
    bulkTransactions.removeWhere((element) => element.id == transaction.id);
    if (bulkTransactions.isEmpty) {
      bulkType = null;
    }
  }

  void clearBulk() {
    bulkType = null;
    bulkTransactions.clear();
  }

  Stream<BankAccountsAndStatisticsState> setDateRangeFilter(
      DateFilterTransactionEvent event) async* {
    var loadedState = (state as BankAccountsAndStatisticsLoaded);
    try {
      var dateTimePeriods = getDateRange(event.dateFilter, event.periodEndDate);
      if (dateTimePeriods != null) {
        yield* changeFilters(
          loadedState.transactionFiltersModel.copyWith(
              periodStart: dateTimePeriods[0],
              periodEnd: dateTimePeriods[1],
              dateTimeFilter: event.dateFilter),
        );
      }
    } catch (e) {
      add(TransactionNoteErrorEvent(e.toString()));
      rethrow;
    }
  }

  List<DateTime>? getDateRange(int dateFilter, DateTime? periodEndDate) {
    var nowDateTime = DateTime.now();
    late var nowDate = DateTime(
        nowDateTime.year,
        nowDateTime.month,
        nowDateTime
            .day); //date need to set WITHOUT time, because date picker fall
    if (dateFilter == 0) {
      //this month
      return <DateTime>[
        DateTime(nowDate.year, nowDate.month, 1),
        periodEndDate!
      ];
    } else if (dateFilter == 1) {
      //this Year
      return <DateTime>[DateTime(nowDate.year, 1, 1), periodEndDate!];
    } else if (dateFilter == 2) {
      //last Month
      return <DateTime>[
        DateTime(nowDate.year, nowDate.month - 1, 1),
        DateTime(nowDate.year, nowDate.month, 0)
      ];
    } else if (dateFilter == 3) {
      //last Year
      return <DateTime>[
        DateTime(nowDate.year - 1, 1, 1),
        DateTime(nowDate.year, 1, 0)
      ];
    }
  }
}
