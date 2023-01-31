import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/dashboard_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/annual_monthly_switcher.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/net_worth_table_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/period_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/spline_chart_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/net_worth/net_worth_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/net_worth/net_worth_state.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NetWorthLayout extends StatefulWidget {
  @override
  State<NetWorthLayout> createState() => _NetWorthLayoutState();
}

class _NetWorthLayoutState extends State<NetWorthLayout> {
  var selectedDate = DateTime(DateTime.now().year);
  var isPersonal = true;
  var showEmptyState = false;
  late final HomeScreenCubit _homeScreenCubit;
  late final NetWorthCubit _netWorthCubit;

  @override
  void initState() {
    _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    _netWorthCubit = BlocProvider.of<NetWorthCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      currentTab: Tabs.NetWorth,
      title: AppLocalizations.of(context)!.netWorth,
      headerWidget: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (_, __) {
          return BlocBuilder<NetWorthCubit, NetWorthState>(
            builder: (_, state) {
              if (state is NetWorthLoaded) {
                showEmptyState = isPersonal
                    ? state.netWorthModel.personalDebts.isEmpty &&
                        state.netWorthModel.personalAssets.isEmpty
                    : state.netWorthModel.businessDebts.isEmpty &&
                        state.netWorthModel.businessAssets.isEmpty;
                var period = _homeScreenCubit.shortPeriod;
                return Wrap(
                  children: [
                    Label(
                      text: AppLocalizations.of(context)!.netWorth,
                      type: LabelType.Header2,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 140,
                      child: PeriodSelector(
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
                          selectedDate =
                              DateTime(period.years[selectedPosition]);
                          _netWorthCubit.fetchNetWorth(
                            selectedDate.year,
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
      bodyWidget: BlocConsumer<NetWorthCubit, NetWorthState>(
        listener: (context, state) {
          if (state is NetWorthError) {
            showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(context, message: state.error);
              },
            );
          }
        },
        builder: (context, state) {
          if (state is NetWorthLoading) {
            return CustomLoadingIndicator();
          } else if (state is NetWorthLoaded) {
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  key: ObjectKey(state.netWorthStatisticModel),
                                  children: [
                                    DashboardItem(
                                        isSmall: true,
                                        text: AppLocalizations.of(context)!
                                            .totalAssets
                                            .toUpperCase(),
                                        sumString: state
                                            .netWorthStatisticModel.totalAssets
                                            .formattedWithDecorativeElementsString(),
                                        iconUrl:
                                            'assets/images/icons/ic_assets.png',
                                        textSize: 20),
                                    DashboardItem(
                                        isSmall: true,
                                        text: AppLocalizations.of(context)!
                                            .totalDebts
                                            .toUpperCase(),
                                        sumString: state
                                            .netWorthStatisticModel.totalDebts
                                            .formattedWithDecorativeElementsString(),
                                        iconUrl:
                                            'assets/images/icons/ic_debts.png',
                                        textSize: 20),
                                    DashboardItem(
                                        isSmall: true,
                                        text: AppLocalizations.of(context)!
                                            .yourNetWorth
                                            .toUpperCase(),
                                        sumString: state
                                            .netWorthStatisticModel.netWorth
                                            .formattedWithDecorativeElementsString(),
                                        iconUrl:
                                            'assets/images/icons/ic_net.png',
                                        textSize: 20),
                                  ],
                                ),
                                _NetWorthChart(
                                  state.netWorthModel.splineChartModel(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                        child: _homeScreenCubit.user.subscription!.isStandard
                            ? TabSelectorButton(
                                labelText:
                                    AppLocalizations.of(context)!.personal,
                                onPressed: null,
                                isSelected: true,
                              )
                            : TwoOptionSwitcher(
                                isFirstItemSelected: isPersonal,
                                options: [
                                  AppLocalizations.of(context)!.personal,
                                  AppLocalizations.of(context)!.business
                                ],
                                onPressed: () {
                                  setState(() {
                                    isPersonal = !isPersonal;
                                  });
                                },
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: NetWorthTableWidget(
                          context,
                          key: Key(isPersonal.toString()),
                          model: state.netWorthModel,
                          isPersonal: isPersonal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class _NetWorthChart extends StatelessWidget {
  final SplineChartModel model;

  _NetWorthChart(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                right: 80,
              ),
              child: Label(
                text: AppLocalizations.of(context)!.activities,
                type: LabelType.Header3,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _NetWorthChartLegend(
                  text: AppLocalizations.of(context)!.assets,
                  color: CustomColorScheme.successPopupButton,
                ),
                _NetWorthChartLegend(
                  text: AppLocalizations.of(context)!.debts,
                  color: CustomColorScheme.inputErrorBorder,
                ),
                _NetWorthChartLegend(
                  text: AppLocalizations.of(context)!.netWorth,
                  color: CustomColorScheme.button,
                ),
              ],
            )
          ],
        ),
        Container(
          width: 800,
          child: SplineChartWidget(
            model: model,
          ),
        )
      ],
    );
  }
}

class _NetWorthChartLegend extends StatelessWidget {
  final String text;
  final Color color;

  _NetWorthChartLegend({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 24,
              height: 24,
              color: color,
            ),
          ),
          SizedBox(width: 8),
          Label(
            text: text,
            type: LabelType.GreyLabel,
          )
        ],
      ),
    );
  }
}
