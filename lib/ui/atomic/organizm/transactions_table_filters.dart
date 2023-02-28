import 'package:burgundy_budgeting_app/ui/atomic/atom/clear_all_filters_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/clip_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_flexible_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/clip_selector_element.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/date_picker.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_state.dart';
import 'package:burgundy_budgeting_app/ui/model/filter_parameters_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/transactions/transactions_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionsTableFilters extends StatefulWidget {
  @override
  _TransactionsTableFiltersState createState() =>
      _TransactionsTableFiltersState();
}

class _TransactionsTableFiltersState extends State<TransactionsTableFilters> {
  var collapseFilters = false;
  late FilterParametersModel filterParametersModel;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? availablePeriodStartDate;
  DateTime? availablePeriodEndDate;
  int sortByDropdownValue = 0;
  late bool showFilters;
  late final BankAccountsAndStatisticsBloc _bankAccountsAndStatisticsBloc;

  Map<String, int> dateRangeFilter = {};

  @override
  void initState() {
    super.initState();
    _bankAccountsAndStatisticsBloc =
        BlocProvider.of<BankAccountsAndStatisticsBloc>(
      context,
    );
    filterParametersModel = (_bankAccountsAndStatisticsBloc.state
            as BankAccountsAndStatisticsLoaded)
        .filterParametersModel;
  }

  var now = DateTime.now();

  ///First user's transaction date
  DateTime? periodStartDate;

  ///Last user's transaction date
  DateTime? periodEndDate;

  @override
  void didChangeDependencies() {
    //Date Range
    periodStartDate = (_bankAccountsAndStatisticsBloc.state
            as BankAccountsAndStatisticsLoaded)
        .filterParametersModel
        .periodStart;

    periodEndDate = (_bankAccountsAndStatisticsBloc.state
            as BankAccountsAndStatisticsLoaded)
        .filterParametersModel
        .periodEnd;

    if (periodStartDate != null) {
      dateRangeFilter = {
        if (periodEndDate!.isAfter(DateTime(now.year, now.month, 0)))
          AppLocalizations.of(context)!.thisMonth: 0,
        if (periodEndDate!.isAfter(DateTime(now.year, 1, 1)))
          AppLocalizations.of(context)!.thisYear: 1,
        if (periodStartDate!.isBefore(DateTime(now.year, now.month, 0)) &&
            periodEndDate!.isAfter(DateTime(now.year, now.month, 0)))
          AppLocalizations.of(context)!.lastMonth: 2,
        if (periodStartDate!.isBefore(DateTime(now.year, 1, 0)))
          AppLocalizations.of(context)!.lastYear: 3
      };
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    showFilters = HideTransactionFiltersInherited.of(context).showFilters;

    return LayoutBuilder(builder: (_, constrains) {
      collapseFilters = constrains.maxWidth < 800;
      return BlocBuilder<BankAccountsAndStatisticsBloc,
              BankAccountsAndStatisticsState>(
          builder: (BuildContext context, state) {
        state as BankAccountsAndStatisticsLoaded;

        startDate = state.transactionFiltersModel.periodStart;
        endDate = state.transactionFiltersModel.periodEnd;

        availablePeriodStartDate = state.filterParametersModel.periodStart;
        availablePeriodEndDate = state.filterParametersModel.periodEnd;

        if (startDate != null) {
          if (availablePeriodStartDate == null || startDate!.isAfter(availablePeriodStartDate!)) {
            availablePeriodStartDate = startDate;
          }
        }

        if (endDate != null) {
          if (availablePeriodEndDate == null || endDate!.isBefore(availablePeriodEndDate!)) {
            availablePeriodEndDate = endDate;
          }
        }

        if (state.transactionFiltersModel.sortingBy == 1 &&
            state.transactionFiltersModel.sortingOrder == 2) {
          sortByDropdownValue = 0;
        } else if (state.transactionFiltersModel.sortingBy == 1 &&
            state.transactionFiltersModel.sortingOrder == 1) {
          sortByDropdownValue = 1;
        } else if (state.transactionFiltersModel.sortingBy == 2 &&
            state.transactionFiltersModel.sortingOrder == 2) {
          sortByDropdownValue = 2;
        } else if (state.transactionFiltersModel.sortingBy == 2 &&
            state.transactionFiltersModel.sortingOrder == 1) {
          sortByDropdownValue = 3;
        } else if (state.transactionFiltersModel.sortingBy == 3 &&
            state.transactionFiltersModel.sortingOrder == 1) {
          sortByDropdownValue = 4;
        } else if (state.transactionFiltersModel.sortingBy == 3 &&
            state.transactionFiltersModel.sortingOrder == 2) {
          sortByDropdownValue = 5;
        }

        var filtersMap = filterParametersModel
            .currentMap(state.transactionFiltersModel.usageType);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: showFilters
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Row(
              children: [
                CustomMaterialInkWell(
                  border: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  type: InkWellType.Purple,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt_rounded,
                          color: CustomColorScheme.button),
                      Label(
                        text: AppLocalizations.of(context)!.showFilters,
                        type: LabelType.LabelBoldPink,
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                    HideTransactionFiltersInherited.of(context)
                        .onMyFieldChange(showFilters);
                  },
                ),
              ],
            ),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomMaterialInkWell(
                  border: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onTap: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                    HideTransactionFiltersInherited.of(context)
                        .onMyFieldChange(showFilters);
                  },
                  type: InkWellType.Purple,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt_rounded,
                          color: CustomColorScheme.button),
                      Label(
                        text: AppLocalizations.of(context)!.hideFilters,
                        type: LabelType.LabelBoldPink,
                      ),
                    ],
                  ),
                ),
                Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: collapseFilters ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: collapseFilters
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    MaybeFlexibleWidget(
                      flexibleWhen: !collapseFilters,
                      flex: !collapseFilters ? 2 : 1,
                      expand: true,
                      child: ClipSelectorElement(
                        [
                          ClipSelectorData(
                              key: Key('all'),
                              title: AppLocalizations.of(context)!.all,
                              selected:
                                  state.transactionFiltersModel.usageType == 0,
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12)),
                          ClipSelectorData(
                              key: Key('personal'),
                              title: AppLocalizations.of(context)!.personal,
                              selected:
                                  state.transactionFiltersModel.usageType == 1,
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12)),
                          ClipSelectorData(
                              key: Key('business'),
                              title: AppLocalizations.of(context)!.business,
                              selected:
                                  state.transactionFiltersModel.usageType == 2,
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12)),
                        ],
                        (value) {
                          if (value.key == Key('all')) {
                            _bankAccountsAndStatisticsBloc
                                .add(ChangeUsageTypeEvent(0));
                          } else if (value.key == Key('personal')) {
                            _bankAccountsAndStatisticsBloc
                                .add(ChangeUsageTypeEvent(1));
                          } else {
                            _bankAccountsAndStatisticsBloc
                                .add(ChangeUsageTypeEvent(2));
                          }
                        },
                        padding: const EdgeInsets.all(8.0),
                        key: Key(
                            state.transactionFiltersModel.usageType.toString()),
                      ),
                    ),
                    MaybeFlexibleWidget(
                      flex: !collapseFilters ? 3 : 1,
                      flexibleWhen: !collapseFilters,
                      expand: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!collapseFilters) SizedBox(width: 20),
                          if (dateRangeFilter.isNotEmpty)
                            Flexible(
                              child: DropdownItem(
                                key: ObjectKey(
                                    state.transactionFiltersModel.category?.id),
                                isSmall: true,
                                initialValue: state
                                    .transactionFiltersModel.dateTimeFilter,
                                items: dateRangeFilter.keys.toList(),
                                itemKeys: dateRangeFilter.values.toList(),
                                hintText: AppLocalizations.of(context)!.select,
                                callback: (int value) {
                                  _bankAccountsAndStatisticsBloc.add(
                                      DateFilterTransactionEvent(
                                          value, periodEndDate));
                                },
                              ),
                            ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Label(
                              text: AppLocalizations.of(context)!.from,
                              type: LabelType.General,
                            ),
                          ),
                          Flexible(
                            child: DatePicker(
                              context,
                              value: startDate?.toIso8601String() ??
                                  availablePeriodStartDate?.toIso8601String(),
                              dateFormat: CustomDateFormats.defaultDateFormat,
                              onChanged: (String value) {
                                _bankAccountsAndStatisticsBloc
                                    .add(SetStartDate(DateTime.parse(
                                  value,
                                )));
                              },
                              isSmall: true,
                              firstDate: periodStartDate,
                              lastDate: availablePeriodEndDate,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Label(
                              text: AppLocalizations.of(context)!.to,
                              type: LabelType.General,
                            ),
                          ),
                          Flexible(
                            child: DatePicker(
                              context,
                              value: endDate?.toIso8601String() ??
                                  availablePeriodEndDate?.toIso8601String(),
                              dateFormat: CustomDateFormats.defaultDateFormat,
                              onChanged: (String value) {
                                if (availablePeriodStartDate != null &&
                                    availablePeriodEndDate != null) {
                                  _bankAccountsAndStatisticsBloc.add(
                                      SetStartDate(availablePeriodStartDate!));
                                }
                                _bankAccountsAndStatisticsBloc.add(
                                  SetEndDate(DateTime.parse(value)),
                                );
                              },
                              isSmall: true,
                              firstDate: availablePeriodStartDate,
                              lastDate: periodEndDate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Flex(
                  direction: collapseFilters ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: collapseFilters
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaybeFlexibleWidget(
                      flexibleWhen: !collapseFilters,
                      flex: !collapseFilters ? 2 : 1,
                      expand: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Label(
                                  text: AppLocalizations.of(context)!.sortBy,
                                  type: LabelType.General,
                                ),
                              ),
                              Flexible(
                                child: DropdownItem(
                                  initialValue: sortByDropdownValue,
                                  isSmall: true,
                                  hintText: AppLocalizations.of(context)!.all,
                                  callback: (int value) {
                                    _bankAccountsAndStatisticsBloc.add(
                                      SortByEvent(value),
                                    );
                                  },
                                  items: [
                                    AppLocalizations.of(context)!.newest,
                                    AppLocalizations.of(context)!.oldest,
                                    AppLocalizations.of(context)!.biggest,
                                    AppLocalizations.of(context)!.smallest,
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (!collapseFilters)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: ClearAllFiltersButton(),
                            )
                        ],
                      ),
                    ),
                    SizedBox(width: 20, height: 20),
                    MaybeFlexibleWidget(
                      flexibleWhen: !collapseFilters,
                      flex: !collapseFilters ? 3 : 1,
                      expand: true,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, top: 8.0),
                            child: Label(
                              text:
                                  AppLocalizations.of(context)!.selectCategory,
                              type: LabelType.General,
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: DropdownItem<FilterCategory>(
                                    key: ObjectKey((_bankAccountsAndStatisticsBloc
                                                .state
                                            as BankAccountsAndStatisticsLoaded)
                                        .transactionFiltersModel
                                        .usageType),
                                    isSmall: true,
                                    initialValue:
                                        state.transactionFiltersModel.category,
                                    items: [
                                      for (var item in filtersMap.keys.toList())
                                        item.name
                                    ],
                                    itemKeys: filtersMap.keys.toList(),
                                    hintText:
                                        AppLocalizations.of(context)!.select,
                                    callback: (FilterCategory value) {
                                      _bankAccountsAndStatisticsBloc.add(
                                          SelectParentCategoryFilterEvent(
                                              value));
                                    },
                                  ),
                                ),
                                SizedBox(height: 4),
                                SizedBox(
                                  height: 40,
                                  child: DropdownItem<FilterCategory>(
                                    key: ObjectKey(state
                                        .transactionFiltersModel.category?.id),
                                    isSmall: true,
                                    initialValue: state
                                        .transactionFiltersModel.subCategory,
                                    items: [
                                      for (var item in filtersMap[state
                                              .transactionFiltersModel
                                              .category] ??
                                          [])
                                        item.name
                                    ],
                                    itemKeys: filtersMap[
                                        state.transactionFiltersModel.category],
                                    hintText:
                                        AppLocalizations.of(context)!.select,
                                    callback: (FilterCategory value) {
                                      _bankAccountsAndStatisticsBloc.add(
                                          SelectChildCategoryFilterEvent(
                                              value));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (collapseFilters)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ClearAllFiltersButton(),
                  ),
              ],
            ),
          ),
        );
      });
    });
  }
}
