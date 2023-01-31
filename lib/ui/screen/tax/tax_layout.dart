import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/period_selector.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/tax_column_chart.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/tax_statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/tax/tax_credits_and_adjustment_tab.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/tax/tax_income_details_tab.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/tax/tax_personal_info_tab.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaxLayout extends StatefulWidget {
  const TaxLayout();

  @override
  State<TaxLayout> createState() => _TaxLayoutState();
}

class _TaxLayoutState extends State<TaxLayout> {
  // to be updated later
  var years = [2022];
  bool shouldHideDisclaimer = false;
  var isEditable = true;
  @override
  void initState() {
    isEditable = BlocProvider.of<HomeScreenCubit>(context)
            .currentForeignSession
            ?.access
            .isReadOnly !=
        true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shouldHideDisclaimer = MediaQuery.of(context).size.width < 1650;
    return HomeScreen(
      currentTab: Tabs.Tax,
      title: AppLocalizations.of(context)!.calculateYourTaxes,
      headerWidget: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Label(
            text: AppLocalizations.of(context)!.calculateYourTaxes,
            type: LabelType.Header2,
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            width: 140,
            child: PeriodSelector(
              UniqueKey(),
              isSmall: true,
              defaultPosition: 0,
              labelTexts: List.generate(
                years.length,
                (index) => years[index].toString(),
              ),
              onPressed: (selectedPosition) {},
            ),
          ),
        ],
      ),
      bodyWidget: BlocConsumer<TaxCubit, TaxState>(
        listener: (context, state) {
          if (state is TaxError) {
            showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(context, message: state.message);
              },
            );
          }
        },
        builder: (context, state) {
          var taxCubit = BlocProvider.of<TaxCubit>(context);
          if (state is TaxLoading) {
            return CustomLoadingIndicator();
          } else if (state is TaxLoaded) {
            return Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 1192),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TaxColumnChart(
                                            data: state.estimatedTaxesModel
                                                ?.taxBarChartData?.chartData,
                                            maximum: state.estimatedTaxesModel
                                                ?.taxBarChartData?.maximum,
                                            updateDataCallback:
                                                (bool isFICAIncluded) async {
                                              await taxCubit
                                                  .updateEstimatedTaxes(
                                                      isFICAIncluded:
                                                          isFICAIncluded);
                                            },
                                          ),
                                          VerticalDivider(),
                                          TaxStatisticsWidget(
                                            model: state.estimatedTaxesModel,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  var maxWidth = constraints.maxWidth;
                                  if (maxWidth < 850) {
                                    return Wrap(
                                      children: [
                                        Label(
                                          text: AppLocalizations.of(context)!
                                              .estimatedTaxCalculation,
                                          type: LabelType.Header2,
                                        ),
                                        // Spacer(),
                                        TaxPageTabSelector(taxCubit),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        Label(
                                          text: AppLocalizations.of(context)!
                                              .estimatedTaxCalculation,
                                          type: LabelType.Header2,
                                        ),
                                        Spacer(),
                                        TaxPageTabSelector(taxCubit),
                                      ],
                                    );
                                  }
                                }),
                              ),
                              Padding(
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
                                  child: state.currentEstimationTab == 0 ||
                                      state.currentEstimationTab == 1
                                      ? PersonalInfoTab(
                                    personalInfoModel:
                                    state.personalInfoModel!,
                                  )
                                      : state.currentEstimationTab == 2
                                          ? SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 1180,
                                                ),
                                                child: TaxIncomeDetailsTab(
                                                  incomeDetailsModel:
                                                      state.incomeDetailsModel!,
                                                ),
                                              ),
                                            )
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 1160,
                                                ),
                                                child:
                                                    TaxCreditsAndAdjustmentTab(
                                                  creditsAndAdjustmentModel: state
                                                      .creditsAndAdjustmentModel!,
                                                  personalInfoModel:
                                                      state.personalInfoModel!,
                                                ),
                                              ),
                                            ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!shouldHideDisclaimer)
                        Flexible(
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16.0,
                                bottom: 16.0,
                                right: 16.0,
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 400),
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
                                child: TaxDisclaimer(taxCubit),
                              ),
                            ),
                          ),
                        )
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

  @override
  void dispose() {
    super.dispose();
  }
}

class TaxDisclaimer extends StatelessWidget {
  final TaxCubit taxCubit;

  const TaxDisclaimer(this.taxCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
              text: AppLocalizations.of(context)!.vlorishEstimatedTaxCalculator,
              type: LabelType.LargeButton),
          SizedBox(height: 16),
          Label(
            text: AppLocalizations.of(context)!.taxDisclaimerPartOne,
            type: LabelType.General,
          ),
          SizedBox(height: 24),
          Label(
            text: AppLocalizations.of(context)!.accuracy,
            type: LabelType.GeneralBold,
          ),
          SizedBox(height: 16),
          Label(
            text: AppLocalizations.of(context)!.taxDisclaimerPartTwo,
            type: LabelType.General,
          ),
          SizedBox(height: 24),
          Label(
            text: AppLocalizations.of(context)!.simplicity,
            type: LabelType.GeneralBold,
          ),
          SizedBox(height: 16),
          Label(
            text: AppLocalizations.of(context)!.taxDisclaimerPartThree,
            type: LabelType.General,
          ),
        ],
      ),
    );
  }
}

class TaxPageTabSelector extends StatelessWidget {
  final TaxCubit taxCubit;

  const TaxPageTabSelector(this.taxCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var estimationStage = taxCubit.estimationStage ?? 0;
    var selectedTab = (taxCubit.state is TaxLoaded)
        ? (taxCubit.state as TaxLoaded).currentEstimationTab
        : 0;
    return Row(
      children: [
        TabSelectorButton(
          labelText: AppLocalizations.of(context)!.personalInfo,
          key: Key('personalInfo' +
              estimationStage.toString() +
              selectedTab.toString()),
          padding: EdgeInsets.only(right: 16),
          onPressed: () { taxCubit.changeEstimationTab(1); },
          isActive: estimationStage > 0,
          isSelected: selectedTab == 1,
        ),
        TabSelectorButton(
          key: Key('incomeDetails' +
              estimationStage.toString() +
              selectedTab.toString()),
          labelText: AppLocalizations.of(context)!.incomeDetails,
          onPressed: () {
            taxCubit.changeEstimationTab(2);
          },
          isActive: estimationStage > 1,
          isSelected: selectedTab == 2,
        ),
        TabSelectorButton(
          key: Key('adjustments' +
              estimationStage.toString() +
              selectedTab.toString()),
          labelText: AppLocalizations.of(context)!.creditsAdjustment,
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            taxCubit.changeEstimationTab(3);
          },
          isActive: estimationStage > 2,
          isSelected: selectedTab == 3,
        ),
      ],
    );
  }
}
