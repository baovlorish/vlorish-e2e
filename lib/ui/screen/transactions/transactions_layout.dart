import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_flexible_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_state.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/list_of_transaction_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/transactions_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_page.dart';
import 'package:burgundy_budgeting_app/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'hide_transaction_filters_inherited.dart';

class TransactionsLayout extends StatefulWidget {
  @override
  State<TransactionsLayout> createState() => _TransactionsLayoutState();
}

class _TransactionsLayoutState extends State<TransactionsLayout> {
  final _controller = ScrollController(keepScrollOffset: true);

  bool? moveStatsToTheTop;
  bool threeLineHeader = false;
  bool smallHeader = false;
  bool individualScrollToTransactions = false;

  final TextEditingController searchBarController = TextEditingController();
  final searchBarFocusNode = FocusNode();

  Widget _wrapInScrollbar({
    required bool wrapInScroll,
    required ScrollController controller,
    required Widget child,
  }) {
    return wrapInScroll
        ? Scrollbar(
            thumbVisibility: true,
            interactive: true,
            controller: _controller,
            child: child,
          )
        : child;
  }

  late final BankAccountsAndStatisticsBloc bankAccountsAndStatisticsBloc;
  late final HomeScreenCubit _homeScreenCubit;

  @override
  void initState() {
    bankAccountsAndStatisticsBloc =
        BlocProvider.of<BankAccountsAndStatisticsBloc>(context);
    _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    searchBarFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (moveStatsToTheTop != null &&
        moveStatsToTheTop != MediaQuery.of(context).size.width < 1300 &&
        bankAccountsAndStatisticsBloc.state
            is BankAccountsAndStatisticsLoaded) {
      bankAccountsAndStatisticsBloc.add(
        TransactionPageRebuildsEvent(),
      );
    }
    moveStatsToTheTop = MediaQuery.of(context).size.width < 1300;
    threeLineHeader = MediaQuery.of(context).size.width < 1100;
    smallHeader = MediaQuery.of(context).size.width < 850;
    individualScrollToTransactions = MediaQuery.of(context).size.height > 1100;
    return HomeScreen(
      title: AppLocalizations.of(context)!.accountsAndTransactions,
      currentTab: Tabs.AppbarTransactions,
      headerWidget: Flex(
        direction: threeLineHeader ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: threeLineHeader
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: threeLineHeader
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Label(
            text: AppLocalizations.of(context)!.accountsAndTransactions,
            type: LabelType.Header2,
          ),
          MaybeFlexibleWidget(
            expand: true,
            flexibleWhen: !threeLineHeader,
            child: Flex(
              direction: threeLineHeader ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: threeLineHeader
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              crossAxisAlignment: threeLineHeader
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                MaybeFlexibleWidget(
                  flexibleWhen: !threeLineHeader,
                  child: _Searchbar(
                    enablePadding: !threeLineHeader,
                    controller: searchBarController,
                    searchBarFocusNode: searchBarFocusNode,
                    onChanged: (value) {
                      bankAccountsAndStatisticsBloc.add(
                        SearchTransactionEvent(value),
                      );
                    },
                  ),
                ),
                if (_homeScreenCubit.currentForeignSession == null)
                  SizedBox(
                    width: 180,
                    child: ButtonItem(
                      context,
                      text: AppLocalizations.of(context)!.manageAccounts,
                      onPressed: () => NavigatorManager.navigateTo(
                        context,
                        ManageAccountsPage.routeName,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
      bodyWidget: HideTransactionFiltersInherited(
        child: Expanded(
          child: _wrapInScrollbar(
            wrapInScroll: moveStatsToTheTop!,
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: CustomColorScheme.tableBorder,
                    ),
                  ],
                ),
                child: moveStatsToTheTop!
                    ? ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false,
                        ),
                        child: ListView(
                          controller: _controller,
                          children: [
                            TransactionsStatisticsWidget(
                              moveStatsToTheTop: moveStatsToTheTop!,
                              setValueToSearchBar: (value) {
                                searchBarController.text = value;
                              },
                            ),
                            CustomDivider(),
                            ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
                                scrollbars: true,
                              ),
                              child: ListOfTransactionsWidget(
                                scrollable: false,
                                individualScrollToTransactions: false,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ListOfTransactionsWidget(
                              scrollable: true,
                              individualScrollToTransactions:
                                  individualScrollToTransactions,
                            ),
                          ),
                          CustomVerticalDivider(),
                          Flexible(
                            flex: 1,
                            child: TransactionsStatisticsWidget(
                              moveStatsToTheTop: moveStatsToTheTop!,
                              setValueToSearchBar: (value) {
                                searchBarController.text = value;
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Searchbar extends StatelessWidget {
  final bool enablePadding;
  final void Function(String) onChanged;
  final _searchFieldDebouncer = Debouncer(Duration(milliseconds: 400));
  final TextEditingController controller;
  final FocusNode searchBarFocusNode;

  _Searchbar({
    Key? key,
    required this.enablePadding,
    required this.onChanged,
    required this.controller,
    required this.searchBarFocusNode,
  }) : super(key: key) {
    RawKeyboard.instance.addListener(
      (RawKeyEvent event) {
        if ((event.isControlPressed || event.isMetaPressed) &&
            event.physicalKey == PhysicalKeyboardKey.keyF &&
            !event.repeat &&
            event is RawKeyDownEvent) {
          searchBarFocusNode.requestFocus();
        } else if (event.physicalKey == PhysicalKeyboardKey.escape &&
            !event.repeat &&
            event is RawKeyDownEvent) {
          searchBarFocusNode.unfocus();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankAccountsAndStatisticsBloc,
        BankAccountsAndStatisticsState>(
      builder: (_, state) {
        if (state is BankAccountsAndStatisticsLoaded &&
            state.transactionFiltersModel.textSearch != null) {
          controller.selection = TextSelection.fromPosition(TextPosition(
            offset: controller.text.length,
          ));
        } else {
          controller.text = '';
        }
        return Container(
          constraints: BoxConstraints(minWidth: 40, maxWidth: 560),
          padding: EdgeInsets.symmetric(
              horizontal: enablePadding ? 16.0 : 0, vertical: 4.0),
          child: GestureDetector(
            onDoubleTap: () {
              controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.text.length);
            },
            child: TextFormField(
              textInputAction: TextInputAction.search,
              focusNode: searchBarFocusNode,
              controller: controller,
              onChanged: (value) {
                _searchFieldDebouncer.run(() => onChanged(value));
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!
                    .typeMerchantNameOrTransactionAmount,
                hintStyle: CustomTextStyle.HintTextStyle(context),
                contentPadding: EdgeInsets.all(20),
                fillColor: CustomColorScheme.inputFill,
                filled: true,
                suffixIcon: Icon(
                  Icons.search,
                  color: CustomColorScheme.button,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: CustomColorScheme.inputBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: CustomColorScheme.button,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
