import 'dart:collection';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/budget_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/category_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/model/transactions_filter_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/business_account_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';
import 'package:burgundy_budgeting_app/ui/model/filter_parameters_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_events.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/budget_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/transactions/transactions_page.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> with HydratedMixin {
  final Logger logger = getLogger('Budget Bloc');

  final bool isPersonal;
  final BudgetRepository budgetRepository;
  final CategoryRepository categoryRepository;
  final AccountsTransactionsRepository transactionsRepository;

  Map<String, bool> expandedCategoriesPersonal = {};
  Map<String, bool> expandedCategoriesBusiness = {};

  late CategoryManagementPageModel categoryManagementModel;

  late DateTime transactionsEndDate;

  late FilterParametersModel filterParametersModel;

  late DateTime transactionsStartDate;

  List<BusinessAccountModel>? businessList;

  var undoAnnualNodeQueue =
      Queue<BudgetAnnualNode>(); //need for annual updating
  var undoMonthlyTableType = Queue<TableType>(); //need for monthly updating
  var undoSubcategoryQueue = Queue<BudgetSubcategory>();

  BudgetAnnualNode? redoAnnualNode; //need for annual updating
  var annualRedoBuffer = Queue<BudgetAnnualNode>();
  var annualSubcategoryRedoBuffer = Queue<BudgetSubcategory>();
  TableType? redoMonthlyTableType; //need for monthly updating

  var redoMonthlyTableTypeBuffer = Queue<TableType>();
  BudgetSubcategory? redoSubcategory; // annual updating when redo

  var monthlySubcategoryRedoBuffer =
      Queue<BudgetSubcategory>(); // need for monthly updating when redo

  BudgetAnnualNode? undoAnnualNode;
  TableType? undoMonthlyTableTypeTemp;
  BudgetSubcategory? undoSubcategory;

  BudgetBloc(this.budgetRepository, this.categoryRepository,
      this.transactionsRepository,
      {required this.isPersonal})
      : super(BudgetInitialState()) {
    logger.i('Budget ${isPersonal ? 'personal' : 'business'} page');
    hydrate();
    load();
  }

  Future<void> load() async {
    String? initialBusinessId;
    if (!isPersonal) {
      await fetchBusinessesList();
      if (businessList?.length == 2) {
        initialBusinessId = businessList?.last.id;
      }
    }
    add(
      BudgetAnnualFetchEvent(
        year: DateTime.now().year,
        type: TableType.Actual,
        withOtherModels: true,
        showLoading: true,
        initial: true,
        businessId: initialBusinessId,
      ),
    );
  }

  Map<String, bool> get expandedCategories =>
      isPersonal ? expandedCategoriesPersonal : expandedCategoriesBusiness;

  @override
  Stream<BudgetState> mapEventToState(BudgetEvent event) async* {
    if (event is BudgetAnnualFetchEvent) {
      yield* fetchAnnual(event);
    } else if (event is BudgetMonthlyFetchEvent) {
      yield* fetchMonthly(event);
    } else if (event is UpdateAnnualBudgetEvent) {
      yield* updateAnnualModel(event);
    } else if (event is UpdateMonthlyBudgetEvent) {
      yield* updateMonthlyModel(event);
    } else if (event is BudgetErrorEvent) {
      var prevState = state;
      yield BudgetErrorState(event.message);
      yield prevState;
    } else if (event is CopyMonthEvent) {
      yield* copyMonth(event);
    } else if (event is HideCategoryEvent) {
      yield* hideCategory(event);
    } else if (event is ToggleCategoriesEvent) {
      yield* toggleCategories(event);
    } else if (event is ChangeBusinessNameEvent) {
      yield* changeBusinessName(event);
    } else if (event is UndoNodeEvent) {
      yield* undoNode(event);
    } else if (event is RedoNodeEvent) {
      yield* redoNode(event);
    }
  }

  Stream<BudgetState> fetchAnnual(
    BudgetAnnualFetchEvent event,
  ) async* {
    var prevState = state;
    try {
      yield BudgetLoadingState(event.showLoading);
      if (event.withOtherModels) {
        await fetchCategoriesAndFilterParameters();
      }
      var model = await budgetRepository.getAnnualBudget(
          year: event.year,
          isPersonal: isPersonal,
          type: event.type,
          businessId: !isPersonal ? event.businessId : null);
      logger.i('Loaded ${event.year} annual budget ${event.type}');
      if (model != null) {
        yield BudgetAnnualLoadedState(
          model: model,
        );
      } else {
        yield BudgetMigratingState();
      }
    } catch (e) {
      yield BudgetErrorState(e.toString());
      yield prevState;
      rethrow;
    }
  }

  Stream<BudgetState> fetchMonthly(BudgetMonthlyFetchEvent event) async* {
    var prevState = state;
    try {
      yield BudgetLoadingState(event.showLoading);
      if (event.withOtherModels) {
        categoryManagementModel =
            await categoryRepository.fetchCategoryManagement();
        filterParametersModel =
            await transactionsRepository.getFilterParameters();
        transactionsStartDate =
            filterParametersModel.periodStart ?? DateTime.now();
        transactionsEndDate = filterParametersModel.periodEnd ?? DateTime.now();
      }
      var model = await budgetRepository.getMonthlyBudget(
          monthYear: event.monthYear.toIso8601String(),
          isPersonal: isPersonal,
          businessId: !isPersonal ? event.businessId : null);
      logger.i('Loaded ${event.monthYear} monthly budget');
      if (model != null) {
        yield BudgetMonthlyLoadedState(
          model: model,
        );
      } else {
        yield BudgetMigratingState();
      }
    } catch (e) {
      yield BudgetErrorState(e.toString());
      yield prevState;
      rethrow;
    }
  }

  Stream<BudgetState> updateAnnualModel(UpdateAnnualBudgetEvent event) async* {
    if (event.oldNode != null &&
        event.oldNodeCategory != null &&
        !event.locally) {
      addAnnualNodeToUndo(event.node, event.oldNode!, event.oldNodeCategory!);
    }

    if (state is BudgetAnnualLoadedState) {
      var loadedState = state as BudgetAnnualLoadedState;
      try {
        if (!event.locally) {
          await budgetRepository.setNewAnnualNodeValue(
              node: event.node,
              type: event.node.tableType,
              isGoal: isPersonal &&
                  event.node.categoryType == CategoryGroupType.ExpenseSeparated,
              categoryId: event.node.categoryId,
              businessId: event.newModel.businessId);
        }
        logger
            .i('User changed ${event.node.amount} in ${event.node.monthYear}}');
        yield BudgetAnnualLoadedState(model: event.newModel);
      } catch (e) {
        yield (BudgetErrorState(e.toString()));
        yield (loadedState);
        rethrow;
      }
    }
  }

  Stream<BudgetState> updateMonthlyModel(
      UpdateMonthlyBudgetEvent event) async* {
    if (event.oldSubcategory != null && !event.locally) {
      addMonthlyNodeToUndo(
          event.subcategory, event.oldSubcategory!, event.tableType);
    }

    if (state is BudgetMonthlyLoadedState) {
      var loadedState = state as BudgetMonthlyLoadedState;
      try {
        if (!event.locally) {
          await budgetRepository.setNewMonthlyNodeValue(
            subcategory: event.subcategory,
            type: event.tableType,
            isGoal: isPersonal &&
                event.subcategory.categoryType ==
                    CategoryGroupType.ExpenseSeparated,
            monthYear: event.newModel.monthYear,
            businessId: event.newModel.businessId,
          );
        }
        logger.i('User changed value in month ${event.newModel.monthYear}}');
        yield BudgetMonthlyLoadedState(model: event.newModel);
      } catch (e) {
        yield (BudgetErrorState(e.toString()));
        yield (loadedState);
        rethrow;
      }
    }
  }

  Stream<BudgetState> toggleCategories(ToggleCategoriesEvent event) async* {
    var prevState = state;
    if (isPersonal) {
      expandedCategoriesPersonal = event.expandedCategories;
    } else {
      expandedCategoriesBusiness = event.expandedCategories;
    }

    logger.i('User toggled categories');
    yield SaveCategoriesState(
        isPersonal ? expandedCategoriesPersonal : expandedCategoriesBusiness);
    yield prevState;
  }

  Stream<BudgetState> hideCategory(HideCategoryEvent event) async* {
    if (state is BudgetAnnualLoadedState) {
      var loadedState = state as BudgetAnnualLoadedState;
      try {
        var isSuccessful = await categoryRepository.hideCategory(
            categoryIdToHide: event.id,
            categoryIdToMapTransactions: event.newCategoryId);
        if (isSuccessful) {
          await fetchCategoriesAndFilterParameters();
          logger.i(
              'hide category ${event.id}${event.newCategoryId != null ? ', move transactions to ${event.newCategoryId}' : ''}');
          yield BudgetAnnualLoadedState(
            model: loadedState.model.hideCategory(
              categoryIdToHide: event.id,
              categoryIdToMapTransactions: event.newCategoryId,
              subcategoryToExclude: event.subcategoryToExclude,
            ),
          );

          ///remove nodes with hidden category
          //remove from undo
          var i = 0;
          while (i < undoSubcategoryQueue.length) {
            if (undoSubcategoryQueue.elementAt(i).id == event.id) {
              undoSubcategoryQueue.remove(undoSubcategoryQueue.elementAt(i));
              undoAnnualNodeQueue.remove(undoAnnualNodeQueue.elementAt(i));
            }
            i++;
          }
          //remove from redo
          i = 0;
          while (i < annualSubcategoryRedoBuffer.length) {
            if (annualSubcategoryRedoBuffer.elementAt(i).id == event.id) {
              annualSubcategoryRedoBuffer
                  .remove(annualSubcategoryRedoBuffer.elementAt(i));
              annualRedoBuffer.remove(annualRedoBuffer.elementAt(i));
            }
            i++;
          }
          //remove from undo current node
          if (undoSubcategory?.id == event.id) {
            undoSubcategory = null;
            undoAnnualNode = null;
          }
          //remove from redo current node
          if (redoSubcategory?.id == event.id) {
            redoSubcategory = null;
            redoAnnualNode = null;
          }
        } else {
          yield (BudgetErrorState(categoryRepository.generalErrorMessage));
          yield (loadedState);
        }
      } catch (e) {
        yield (BudgetErrorState(e.toString()));
        yield (loadedState);
        rethrow;
      }
    } else if (state is BudgetMonthlyLoadedState) {
      var loadedState = state as BudgetMonthlyLoadedState;
      try {
        var isSuccessful = await categoryRepository.hideCategory(
            categoryIdToHide: event.id,
            categoryIdToMapTransactions: event.newCategoryId);
        if (isSuccessful) {
          await fetchCategoriesAndFilterParameters();
          logger.i(
              'hide category ${event.id}${event.newCategoryId != null ? ', move transactions to ${event.newCategoryId}' : ''}');
          yield BudgetMonthlyLoadedState(
            model: loadedState.model.hideCategory(
              categoryIdToHide: event.id,
              categoryIdToMapTransactions: event.newCategoryId,
              subcategoryToExclude: event.subcategoryToExclude,
            ),
          );

          ///remove nodes with hidden category
          //remove from undo
          var i = 0;
          while (i < undoSubcategoryQueue.length) {
            if (undoSubcategoryQueue.elementAt(i).id == event.id) {
              undoSubcategoryQueue.remove(undoSubcategoryQueue.elementAt(i));
              undoMonthlyTableType.remove(undoMonthlyTableType.elementAt(i));
            }
            i++;
          }
          //remove from redo
          i = 0;
          while (i < monthlySubcategoryRedoBuffer.length) {
            if (monthlySubcategoryRedoBuffer.elementAt(i).id == event.id) {
              monthlySubcategoryRedoBuffer
                  .remove(monthlySubcategoryRedoBuffer.elementAt(i));
              redoMonthlyTableTypeBuffer
                  .remove(redoMonthlyTableTypeBuffer.elementAt(i));
            }
            i++;
          }
          //remove from undo current node
          if (undoSubcategory?.id == event.id) {
            undoSubcategory = null;
            undoMonthlyTableTypeTemp = null;
          }
          //remove from redo current node
          if (redoSubcategory?.id == event.id) {
            redoSubcategory = null;
            redoMonthlyTableType = null;
          }
        } else {
          yield (BudgetErrorState(categoryRepository.generalErrorMessage));
          yield (loadedState);
        }
      } catch (e) {
        yield (BudgetErrorState(e.toString()));
        yield (loadedState);
        rethrow;
      }
    }
  }

  ManagementSubcategory? getManagementSubcategoryById(
      {required String id, required String groupId}) {
    return (isPersonal
            ? categoryManagementModel.personal
            : categoryManagementModel.business)
        .inUse
        .firstWhereOrNull((element) => element.id == groupId)
        ?.inUseCategories
        .firstWhereOrNull((element) => element.id == id);
  }

  Future<void> goToTransactionsForSelectedPeriod(
      BuildContext context, DateTime date,
      {bool isUnbudgeted = false,
      String? parentCategoryId,
      String? childCategoryId,
      bool isYear = false}) async {
    FilterCategory? parentCategory;
    FilterCategory? childCategory;
    if (parentCategoryId != null) {
      parentCategory = filterParametersModel.personalCategories
          .firstWhereOrNull((element) => element.id.first == parentCategoryId);
      if (childCategoryId != null && parentCategory?.categories != null) {
        childCategory = parentCategory!.categories!
            .firstWhereOrNull((element) => element.id.first == childCategoryId);
      }
    }
    var periodStart = date;
    var periodEnd = isYear ? DateTime(date.year, 12, 31) : date.endMonth();
    var transactionsFilters = TransactionFiltersModel(
      sortingBy: 1,
      sortingOrder: 2,
      usageType: isPersonal ? 1 : 2,
      unbudgeted: isUnbudgeted,
      category: parentCategory,
      subCategory: childCategory,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );

    NavigatorManager.navigateTo(
      context,
      TransactionsPage.routeName,
      routeSettings: RouteSettings(
        arguments: transactionsFilters,
      ),
    );
  }

  Stream<BudgetState> copyMonth(CopyMonthEvent event) async* {
    if (state is BudgetAnnualLoadedState) {
      var loadedState = state as BudgetAnnualLoadedState;
      yield BudgetAnnualLoadedState(
          model: loadedState.model, showCopyMonthAnimation: true);
      try {
        var isSuccessful = await budgetRepository.copyMonth(
          month: event.month,
          usageType: isPersonal ? 1 : 2,
          businessId: event.businessId,
        );
        if (isSuccessful) {
          logger.i('user copied ${event.month}');
          add(
            BudgetAnnualFetchEvent(
              year: event.month.month == 12
                  ? event.month.year + 1
                  : event.month.year,
              type: loadedState.model.type,
              showLoading: false,
              businessId: loadedState.model.businessId,
            ),
          );
        } else {
          yield (BudgetErrorState(categoryRepository.generalErrorMessage));
          yield (loadedState);
        }
      } catch (e) {
        yield (BudgetErrorState(e.toString()));
        yield (loadedState);
        rethrow;
      }
    }
  }

  Stream<BudgetState> changeBusinessName(ChangeBusinessNameEvent event) async* {
    var loadedState = state is BudgetAnnualLoadedState
        ? (state as BudgetAnnualLoadedState)
        : (state as BudgetMonthlyLoadedState);

    try {
      if (loadedState is BudgetAnnualLoadedState) {
        add(
          BudgetAnnualFetchEvent(
              year: loadedState.model.year,
              type: loadedState.model.type,
              businessId: event.businessId),
        );
      }
      if (loadedState is BudgetMonthlyLoadedState) {
        add(
          BudgetMonthlyFetchEvent(
              monthYear: loadedState.model.monthYear,
              businessId: event.businessId),
        );
      }
    } catch (e) {
      yield (BudgetErrorState(e.toString()));
      yield (loadedState);
      rethrow;
    }
  }

  Stream<BudgetState> undoNode(UndoNodeEvent event) async* {
    var loadedState = state is BudgetAnnualLoadedState
        ? (state as BudgetAnnualLoadedState)
        : (state as BudgetMonthlyLoadedState);
    logger.i('Undo node ${state.runtimeType}');
    try {
      if (loadedState is BudgetAnnualLoadedState &&
          undoAnnualNodeQueue.isNotEmpty) {
        add(UpdateAnnualBudgetEvent(
            newModel: loadedState.model.update(undoAnnualNodeQueue.last,
                undoSubcategoryQueue.last as BudgetAnnualSubcategory),
            node: undoAnnualNodeQueue.last));
        logger.i('returned node value ${undoAnnualNodeQueue.last.amount}');

        // if undo and redo have value  change redo value
        if (redoAnnualNode != null) {
          changeAnnualRedoValue();
        }

        redoAnnualNode = annualRedoBuffer.last;
        redoSubcategory = annualSubcategoryRedoBuffer.last;

        undoAnnualNode = undoAnnualNodeQueue.last;
        undoSubcategory = undoSubcategoryQueue.last;

        undoAnnualNodeQueue.removeLast();
        undoSubcategoryQueue.removeLast();
      }
      if (loadedState is BudgetMonthlyLoadedState) {
        add(
          UpdateMonthlyBudgetEvent(
              tableType: undoMonthlyTableType.last,
              newModel: loadedState.model.update(
                  (undoSubcategoryQueue.last as MonthlyBudgetSubcategory)),
              subcategory:
                  (undoSubcategoryQueue.last as MonthlyBudgetSubcategory)),
        );
        logger.i(
            'undo subcategory ${undoSubcategoryQueue.last.categoryType.name}');
        // if undo and redo have value  change redo value
        if (redoSubcategory != null) {
          changeMonthlyRedoValue();
        }

        redoMonthlyTableType = redoMonthlyTableTypeBuffer.last;
        redoSubcategory = monthlySubcategoryRedoBuffer.last;

        undoMonthlyTableTypeTemp = undoMonthlyTableType.last;
        undoSubcategory = undoSubcategoryQueue.last;

        undoSubcategoryQueue.removeLast();
        undoMonthlyTableType.removeLast();
      }
    } catch (e) {
      yield (BudgetErrorState(e.toString()));
      yield loadedState;
      rethrow;
    }
  }

  Stream<BudgetState> redoNode(RedoNodeEvent event) async* {
    var loadedState = state is BudgetAnnualLoadedState
        ? (state as BudgetAnnualLoadedState)
        : (state as BudgetMonthlyLoadedState);

    if (loadedState is BudgetAnnualLoadedState && redoAnnualNode != null) {
      logger.i('redo annual node ${redoAnnualNode!.amount}');
      add(
        UpdateAnnualBudgetEvent(
          newModel: loadedState.model.update(
              redoAnnualNode!, redoSubcategory as BudgetAnnualSubcategory),
          node: redoAnnualNode!,
        ),
      );
      annualRedoBuffer.removeLast();
      annualSubcategoryRedoBuffer.removeLast();

      addAnnualNodeToUndo(redoAnnualNode!, undoAnnualNode!, undoSubcategory!);
      redoAnnualNode = null;
      redoSubcategory = null;
      undoAnnualNode = null;
      undoSubcategory = null;
    }

    if (loadedState is BudgetMonthlyLoadedState && redoSubcategory != null) {
      logger.i(
          'redo monthly subcategory ${(redoSubcategory as MonthlyBudgetSubcategory).name}');
      add(
        UpdateMonthlyBudgetEvent(
            tableType: redoMonthlyTableType!,
            newModel: loadedState.model
                .update(redoSubcategory as MonthlyBudgetSubcategory),
            subcategory: redoSubcategory as MonthlyBudgetSubcategory),
      );

      addMonthlyNodeToUndo(
          redoSubcategory!, undoSubcategory!, undoMonthlyTableTypeTemp!);

      changeMonthlyRedoValue();
      undoSubcategory = null;
      undoMonthlyTableTypeTemp = null;
    }
  }

  Future<MemoNotesPage> fetchNotesForNode(
      {required TableType selectedType,
      required DateTime monthYear,
      required bool isGoal,
      required String categoryId,
      required String? businessId}) async {
    try {
      return await budgetRepository.fetchNotesForNode(
        selectedType: selectedType,
        monthYear: monthYear,
        isGoal: isGoal,
        categoryId: categoryId,
        businessId: businessId,
      );
    } catch (e) {
      add(BudgetErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<bool> deleteNote(
      {bool isGoal = false, required MemoNoteModel note}) async {
    try {
      if (note.isTransaction) {
        return await transactionsRepository
            .deleteTransactionNote(note.transactionId ?? note.id);
      } else {
        return await budgetRepository.deleteNote(isGoal: isGoal, id: note.id);
      }
    } catch (e) {
      add(BudgetErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<String?> addNote(
      {required TableType selectedType,
      bool isGoal = false,
      required String note,
      required DateTime monthYear,
      required String categoryId,
      required String? businessId}) async {
    try {
      return await budgetRepository.addNote(
        selectedType: selectedType,
        isGoal: isGoal,
        note: note,
        monthYear: monthYear,
        categoryId: categoryId,
        businessId: businessId,
      );
    } catch (e) {
      add(BudgetErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<bool> editNote(
      {bool isGoal = false, required MemoNoteModel note}) async {
    try {
      if (note.isTransaction) {
        return await transactionsRepository.setTransactionNote(
            note.note, note.transactionId ?? note.id);
      } else {
        return await budgetRepository.editNote(
          note: note.note,
          id: note.id,
          isGoal: isGoal,
        );
      }
    } catch (e) {
      add(BudgetErrorEvent(e.toString()));
      rethrow;
    }
  }

  @override
  BudgetState? fromJson(Map<String, dynamic> json) {
    if (state is BudgetInitialState) {
      expandedCategoriesPersonal = json['expandedCategoriesPersonal'];

      expandedCategoriesBusiness = json['expandedCategoriesBusiness'];
    }
  }

  @override
  Map<String, dynamic>? toJson(BudgetState state) {
    {
      if (state is SaveCategoriesState) {
        return {
          'expandedCategoriesPersonal': expandedCategoriesPersonal,
          'expandedCategoriesBusiness': expandedCategoriesBusiness
        };
      }
    }
  }

  Future<String?> addReply({
    required String note,
    required bool isTransaction,
    required String noteId,
    required bool isGoal,
  }) async {
    try {
      if (isTransaction) {
        return await transactionsRepository.addNoteReply(
            note: note, noteId: noteId);
      } else {
        return await budgetRepository.addNoteReply(
            isGoal: isGoal, note: note, noteId: noteId);
      }
    } catch (e) {
      add(BudgetErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<void> editNoteReply(
      {required String replyId,
      required isTransaction,
      required String replyText,
      required bool isGoal}) async {
    try {
      if (isTransaction) {
        await transactionsRepository.editTransactionNoteReply(
            replyText, replyId);
      } else {
        await budgetRepository.editNoteReply(
            isGoal: isGoal, note: replyText, id: replyId);
      }
    } catch (e) {
      add(BudgetErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteNoteReply(
      {required String replyId,
      required bool isTransaction,
      required bool isGoal}) async {
    try {
      if (isTransaction) {
        await transactionsRepository.deleteTransactionNoteReply(replyId);
      } else {
        await budgetRepository.deleteNoteReply(isGoal: isGoal, id: replyId);
      }
    } catch (e) {
      add(BudgetErrorEvent(e.toString()));
      rethrow;
    }
  }

  Future<void> fetchCategoriesAndFilterParameters() async {
    categoryManagementModel =
        await categoryRepository.fetchCategoryManagement();
    filterParametersModel = await transactionsRepository.getFilterParameters();
    transactionsStartDate = filterParametersModel.periodStart ?? DateTime.now();
    transactionsEndDate = filterParametersModel.periodEnd ?? DateTime.now();
  }

  Future<void> fetchBusinessesList() async {
    businessList = await budgetRepository.getBusinessList();
    businessList?.insert(
        0,
        BusinessAccountModel('All', 'All',
            businessList?.any((element) => element.hasTransactions == true)));
  }

  void addAnnualNodeToUndo(BudgetAnnualNode node, BudgetAnnualNode oldNode,
      BudgetSubcategory oldNodeCategory) {
    if (undoAnnualNodeQueue.length == 5) {
      undoAnnualNodeQueue.removeFirst();
      undoSubcategoryQueue.removeFirst();
    }

    if (annualRedoBuffer.length == 5) {
      annualRedoBuffer.removeFirst();
      annualSubcategoryRedoBuffer.removeFirst();
    }

    undoAnnualNodeQueue.addLast(oldNode);
    undoSubcategoryQueue.addLast(oldNodeCategory);
    annualRedoBuffer.addLast(node);
    annualSubcategoryRedoBuffer
        .addLast(oldNodeCategory); //todo remove extra queue
  }

  void addMonthlyNodeToUndo(BudgetSubcategory subcategory,
      BudgetSubcategory oldSubcategory, TableType tableType) {
    if (undoSubcategoryQueue.length == 5) {
      undoSubcategoryQueue.removeFirst();
      undoMonthlyTableType.removeFirst();
    }

    if (monthlySubcategoryRedoBuffer.length == 5) {
      redoMonthlyTableTypeBuffer.removeFirst();
      monthlySubcategoryRedoBuffer.removeFirst();
    }

    undoSubcategoryQueue.addLast(oldSubcategory);
    undoMonthlyTableType.addLast(tableType);
    redoMonthlyTableTypeBuffer.addLast(tableType);
    monthlySubcategoryRedoBuffer.addLast(subcategory); //todo remove extra queue
  }

  void changeAnnualRedoValue() {
    annualRedoBuffer.removeLast();
    annualSubcategoryRedoBuffer.removeLast();
  }

  void changeMonthlyRedoValue() {
    redoSubcategory = null;
    redoMonthlyTableType = null;
    redoMonthlyTableTypeBuffer.removeLast();
    monthlySubcategoryRedoBuffer.removeLast();
  }

  void clearUndoAndRedoQueues() {
    undoAnnualNodeQueue.clear();
    undoMonthlyTableType.clear();
    undoSubcategoryQueue.clear();
    monthlySubcategoryRedoBuffer.clear();
    annualRedoBuffer.clear();
    annualSubcategoryRedoBuffer.clear();

    redoAnnualNode = null;
    redoMonthlyTableType = null;
    redoSubcategory = null;
    undoMonthlyTableTypeTemp = null;
  }
}
