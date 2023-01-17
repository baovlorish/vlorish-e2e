import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/dashboard_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_scrollable_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/annual_monthly_switcher.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/debts_table_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/period_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_state.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:burgundy_budgeting_app/ui/screen/debts/debts_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/debts/debts_state.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DebtsLayout extends StatefulWidget {
  const DebtsLayout();

  @override
  State<DebtsLayout> createState() => _DebtsState();
}

class _DebtsState extends State<DebtsLayout> {
  var isPersonal = true;
  var isAnnual = true;
  var selectedDate = DateTime.now();
  var showEmptyState = false;
  var statisticScrollOffset = 0.0;
  int? selectedCellIndex;

  late final HomeScreenCubit homeScreenCubit;
  late final DebtsCubit debtsCubit;

  @override
  void initState() {
    homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    debtsCubit = BlocProvider.of<DebtsCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      currentTab: Tabs.Debt,
      title: AppLocalizations.of(context)!.debtPayoff,
      headerWidget: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          return BlocBuilder<DebtsCubit, DebtsState>(
            builder: (context, state) {
              if (state is DebtsLoaded) {
                isAnnual = state.isAnnual;
                return _HeaderRow(
                  period: homeScreenCubit.shortPeriod,
                  isAnnual: isAnnual,
                  selectedDate: selectedDate,
                  onChanged: (
                    DateTime newSelectedDate, {
                    bool changeAnnual = false,
                  }) {
                    if (changeAnnual) {
                      isAnnual = !isAnnual;
                    }
                    selectedDate = newSelectedDate;
                    selectedCellIndex = null;
                    debtsCubit.fetchDebts(
                      isAnnual ? DateTime(selectedDate.year) : selectedDate,
                      isAnnual ? 12 : 1,
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
      bodyWidget: BlocConsumer<DebtsCubit, DebtsState>(
        listener: (context, state) {
          if (state is DebtsError) {
            showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(context, message: state.error);
              },
            );
          }
        },
        builder: (context, state) {
          if (state is DebtsLoading) {
            return CustomLoadingIndicator();
          } else if (state is DebtsLoaded) {
            showEmptyState = isPersonal
                ? state.debtsPageModel.personalCategories.isEmpty
                : state.debtsPageModel.businessCategories.isEmpty;
            isAnnual = state.isAnnual;

            return Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _DebtsStatisticsWidget(
                            state.statisticModel, statisticScrollOffset,
                            (value) {
                          statisticScrollOffset = value;
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                        child: TwoOptionSwitcher(
                          isFirstItemSelected: isPersonal,
                          options: [
                            AppLocalizations.of(context)!.personal,
                            AppLocalizations.of(context)!.business
                          ],
                          onPressed: () {
                            setState(() {
                              isPersonal = !isPersonal;
                              selectedCellIndex = null;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: showEmptyState
                            ? const EdgeInsets.fromLTRB(400, 16, 16, 16)
                            : const EdgeInsets.all(16.0),
                        child: DebtsTableWidget(
                          context,
                          key: Key(isPersonal.toString() + isAnnual.toString()),
                          model: state.debtsPageModel,
                          isAnnual: isAnnual,
                          isPersonal: isPersonal,
                          onCategorySelectionToggled: (category, isSelected) {
                            if (isSelected) {
                              debtsCubit.showCategoryInStatistics(category);
                            } else {
                              debtsCubit.hideCategoryFromStatistics(category);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final bool isAnnual;
  final void Function(
    DateTime selectedDate, {
    bool changeAnnual,
  }) onChanged;
  final Period period;
  final DateTime selectedDate;

  _HeaderRow({
    Key? key,
    required this.isAnnual,
    required this.onChanged,
    required this.period,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var shouldScroll = constraints.maxWidth < 580;
        return MaybeScrollableWidget(
          shouldScrollWhen: shouldScroll,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: shouldScroll ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Label(
                text: AppLocalizations.of(context)!.debtPayoff,
                type: LabelType.Header2,
              ),
              SizedBox(
                width: 30,
              ),
              if (!shouldScroll) Spacer(),
              Container(
                alignment: Alignment.centerLeft,
                width: 400,
                child: Row(
                  children: [
                    TwoOptionSwitcher(
                      isFirstItemSelected: isAnnual,
                      options: [
                        AppLocalizations.of(context)!.annual,
                        AppLocalizations.of(context)!.monthly,
                      ],
                      onPressed: () => onChanged(
                        selectedDate,
                        changeAnnual: true,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    if (isAnnual)
                      PeriodSelector(
                        ObjectKey(period.years),
                        isSmall: true,
                        defaultPosition: period.years.indexWhere(
                          (element) => element == selectedDate.year,
                        ),
                        labelTexts: List.generate(
                          period.years.length,
                          (index) => period.years[index].toString(),
                        ),
                        onPressed: (selectedPosition) {
                          onChanged(DateTime(period.years[selectedPosition]));
                        },
                      ),
                    if (!isAnnual)
                      PeriodSelector(
                        ObjectKey(period.months),
                        isSmall: false,
                        defaultPosition: period.months.indexWhere(
                          (element) =>
                              element ==
                              DateTime(
                                selectedDate.year,
                                selectedDate.month,
                              ),
                        ),
                        labelTexts: List.generate(
                          period.months.length,
                          (index) =>
                              '${period.monthString(period.months[index].month)} ${period.months[index].year}',
                        ),
                        onPressed: (selectedPosition) {
                          onChanged(period.months[selectedPosition]);
                        },
                      ),
                  ],
                ),
              ),
              if (!shouldScroll) Spacer(),
            ],
          ),
        );
      },
    );
  }
}

class _DebtsStatisticsWidget extends StatefulWidget {
  final DebtStatisticModel statisticsModel;
  final double initialOffset;
  final Function(double) onScrollOffsetChanged;

  _DebtsStatisticsWidget(
      this.statisticsModel, this.initialOffset, this.onScrollOffsetChanged);

  @override
  __DebtsStatisticsWidgetState createState() => __DebtsStatisticsWidgetState();
}

class __DebtsStatisticsWidgetState extends State<_DebtsStatisticsWidget> {
  var withPercent = false;
  var offset;
  late final DebtsCubit debtsCubit;

  @override
  void initState() {
    super.initState();
    offset = widget.initialOffset;
    debtsCubit = BlocProvider.of<DebtsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            key: UniqueKey(),
            children: [
              DashboardItem(
                  isSmall: true,
                  text:
                      AppLocalizations.of(context)!.totalPayments.toUpperCase(),
                  sumString: widget.statisticsModel.totalPayments
                      .formattedWithDecorativeElementsString(),
                  iconUrl: 'assets/images/icons/ic_wallet.png',
                  textSize: 20),
              DashboardItem(
                  isSmall: true,
                  text:
                      AppLocalizations.of(context)!.interestPaid.toUpperCase(),
                  sumString: widget.statisticsModel.interestPaid
                      .formattedWithDecorativeElementsString(),
                  iconUrl: 'assets/images/icons/ic_interest.png',
                  textSize: 20),
              DashboardItem(
                  isSmall: true,
                  text: AppLocalizations.of(context)!.debtPaid.toUpperCase(),
                  sumString: widget.statisticsModel.debtPaid
                      .formattedWithDecorativeElementsString(),
                  iconUrl: 'assets/images/icons/ic_liability.png',
                  textSize: 20),
            ],
          ),
          CustomVerticalDivider(),
          StatefulBuilder(
            builder: (context, setState) {
              return Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (_, constraints) {
                        var shouldScroll = constraints.maxWidth < 445;
                        return MaybeScrollableWidget(
                          shouldScrollWhen: shouldScroll,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Label(
                                text:
                                    AppLocalizations.of(context)!.debtsOverview,
                                type: LabelType.Header3,
                              ),
                              SizedBox(
                                width: shouldScroll ? 16 : 160,
                              ),
                              if ((debtsCubit.state as DebtsLoaded)
                                  .statisticModel
                                  .statisticModels
                                  .isNotEmpty)
                                TwoOptionSwitcher(
                                  spacing: 4,
                                  isFirstItemSelected: !withPercent,
                                  options: [
                                    '\$',
                                    '\%',
                                  ],
                                  onPressed: () {
                                    withPercent = !withPercent;
                                    setState(() {});
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    StatisticsWidget(
                        key: UniqueKey(),
                        isHorizontal: true,
                        emptyStateDescription: AppLocalizations.of(context)!
                            .thisSectionWillDisplayYourDebtsStatistics,
                        models: widget.statisticsModel.statisticModels,
                        emptyStateHeader: AppLocalizations.of(context)!.noData,
                        withPercent: withPercent,
                        showSumWithPercent: false,
                        alwaysShowScrollbar: false,
                        initialScrollOffset: offset,
                        onScrollOffsetChanged: (value) {
                          offset = value;
                          widget.onScrollOffsetChanged(value);
                        }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
