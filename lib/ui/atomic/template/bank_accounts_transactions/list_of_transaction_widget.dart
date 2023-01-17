import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_listview_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/no_cards_here_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/no_transactions_here_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/card_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/transaction_table_page_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/transaction_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/transactions_table_filters.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/transactions_table_header.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_state.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListOfTransactionsWidget extends StatefulWidget {
  final bool individualScrollToTransactions;
  final bool scrollable;

  ListOfTransactionsWidget({
    required this.individualScrollToTransactions,
    required this.scrollable,
  });

  @override
  State<ListOfTransactionsWidget> createState() =>
      _ListOfTransactionsWidgetState();
}

class _ListOfTransactionsWidgetState extends State<ListOfTransactionsWidget> {
  final _cardRowScrollController = ScrollController();

  final _transactionWidgets = <TransactionWidget>[];
  Map<String, Map<String, dynamic>> pendingTransactionsMap = {};
  BankAccountsAndStatisticsLoaded? loadedState;
  late final homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
  late final bankAccountsAndStatisticsBloc =
      BlocProvider.of<BankAccountsAndStatisticsBloc>(context);
  bool isApplyPressed = false;

  @override
  void dispose() {
    _cardRowScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BankAccountsAndStatisticsBloc,
        BankAccountsAndStatisticsState>(
      listener: (BuildContext context, state) {
        if (state is BankAccountsAndStatisticsError) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
                onButtonPress: () {
                  if (state.callback != null) {
                    state.callback!();
                  }
                },
              );
            },
          );
        } else if (state is BankAccountsAndStatisticsLoaded) {
          loadedState = bankAccountsAndStatisticsBloc.state
              as BankAccountsAndStatisticsLoaded;
        }
      },
      builder: (context, state) {
        if (state is BankAccountsAndStatisticsLoaded) {
          var newState = bankAccountsAndStatisticsBloc.state
              as BankAccountsAndStatisticsLoaded;
          if (newState != loadedState && !isApplyPressed) {
            loadedState = newState;
            pendingTransactionsMap.clear();
          }
          _transactionWidgets.clear();
          isApplyPressed = false;

          state.transactionList.transactions.forEach((element) {
            _transactionWidgets.add(
              TransactionWidget(
                element,
                budgetOwnerId: state.transactionList.budgetOwnerId,
                currentUser: homeScreenCubit.user,
                isCoach: homeScreenCubit.currentForeignSession != null,
                originalOfSplit: state.transactionList.splittedTransactions
                    .firstWhereOrNull((splitted) =>
                        splitted.splitChildren != null &&
                        splitted.splitChildren!
                            .any((splitChild) => element.id == splitChild.id)),
                key: ObjectKey(element),
                onCategoryChanged: (categoryId, shouldBeRemembered) {
                  isApplyPressed = true;
                  if (pendingTransactionsMap[element.id] != null) {
                    pendingTransactionsMap.remove(element.id);
                  }
                  if (bankAccountsAndStatisticsBloc.bulkTransactions
                      .where((e) => e.id == element.id)
                      .isNotEmpty) {
                    for (var bulkElement
                        in bankAccountsAndStatisticsBloc.bulkTransactions) {
                      if (pendingTransactionsMap[bulkElement.id] != null) {
                        pendingTransactionsMap.remove(bulkElement.id);
                      }
                    }
                  }
                  bankAccountsAndStatisticsBloc.add(
                    TransactionCategoryChanged(
                      transactionId: element.id,
                      categoryId: categoryId,
                      shouldBeRemembered: shouldBeRemembered,
                      previousCategoryId: element.categoryId,
                    ),
                  );
                },
                categoriesModel: (bankAccountsAndStatisticsBloc.state
                        as BankAccountsAndStatisticsLoaded)
                    .categoriesModel,
                onSplit: (SplitTransactionEvent event) {
                  bankAccountsAndStatisticsBloc.add(event);
                },
                onUnite: (String id) {
                  bankAccountsAndStatisticsBloc
                      .add(UniteTransactionsEvent(splitTransactionId: id));
                },
                isBulkCheckboxSelected: bankAccountsAndStatisticsBloc
                    .bulkTransactions
                    .any((e) => e.id == element.id),
                onBulkChanged: () {
                  setState(() {});
                },
                onSubcategoryChosen: ({
                  required String id,
                  required String parentCategoryId,
                  required String newSubcategoryId,
                  required bool isPreviousCategory,
                  required bool isCheckboxSelected,
                }) {
                  if (isPreviousCategory) {
                    pendingTransactionsMap.remove(id);
                  } else {
                    pendingTransactionsMap[id] = {
                      'newSubcategory': newSubcategoryId,
                      'parentCategoryId': parentCategoryId,
                      'isCheckboxSelected': isCheckboxSelected
                    };
                  }
                },
                newParentCategoryId: pendingTransactionsMap[element.id]
                    ?['parentCategoryId'],
                newSubcategoryId: pendingTransactionsMap[element.id]
                    ?['newSubcategory'],
                isDoNotRememberCheckboxSelected:
                    pendingTransactionsMap[element.id]?['isCheckboxSelected'] ??
                        false,
              ),
            );
          });
        }
        return MaybeListViewWidget(
          scrollable: widget.scrollable,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 8,
              ),
              child: SizedBox(
                height: 200,
                child: Scrollbar(
                  controller: _cardRowScrollController,
                  thumbVisibility: true,
                  interactive: true,
                  child: (state is BankAccountsAndStatisticsLoaded)
                      ? state.accounts.isEmpty
                          ? NoCardsHereWidget()
                          : ListView(
                              controller: _cardRowScrollController,
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(width: 16),
                                for (var account in state.accounts)
                                  CardWidget(
                                    account: account,
                                    showMuteButton: false,
                                    isSelected: account.id ==
                                        state.transactionFiltersModel
                                            .selectedBankAccountId,
                                    onCardTap: (id) {
                                      bankAccountsAndStatisticsBloc
                                          .add(BankAccountSelectedEvent(id));
                                    },
                                  ),
                                SizedBox(width: 16),
                              ],
                            )
                      : CustomLoadingIndicator(
                          isExpanded: false,
                        ),
                ),
              ),
            ),
            if (state is BankAccountsAndStatisticsLoaded &&
                state.accounts.isNotEmpty)
              TransactionsTableFilters(),
            CustomDivider(),
            if (state is BankAccountsAndStatisticsLoaded &&
                state.transactionList.transactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: TransactionTableHeader(
                  isUnbudgeted: state.transactionFiltersModel.unbudgeted,
                ),
              ),
            if (state is BankAccountsAndStatisticsLoaded &&
                state.transactionList.transactions.isNotEmpty)
              CustomDivider(),
            if (state is BankAccountsAndStatisticsLoaded &&
                state.transactionList.transactions.isEmpty)
              NoTransactionHereWidget(),
            if (state is BankAccountsAndStatisticsLoaded &&
                state.transactionList.transactions.isNotEmpty)
              for (var item in _transactionWidgets) item,
            if (state is! BankAccountsAndStatisticsLoaded)
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: CustomLoadingIndicator(
                  isExpanded: false,
                ),
              ),
            BlocBuilder<BankAccountsAndStatisticsBloc,
                BankAccountsAndStatisticsState>(
              builder: (context, state) {
                return (state is BankAccountsAndStatisticsLoaded &&
                        state.transactionList.totalPages > 1)
                    ? TransactionTablePageSelector(
                        state.transactionList.totalPages,
                        state.transactionList.pageNumber,
                      )
                    : SizedBox();
              },
            )
          ],
        );
      },
    );
  }
}

mixin FlexFactors {
  List<int> get listOfFlexFactors => [
        11,
        20,
        14,
        18,
        28,
      ];

  int get combined =>
      listOfFlexFactors[1] +
      listOfFlexFactors[2] +
      listOfFlexFactors[3] +
      listOfFlexFactors[0];
}
