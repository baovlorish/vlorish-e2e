import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item_transparent.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/inform_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/goal.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_cubit.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalWidget extends StatelessWidget {
  final Goal goal;
  final bool isActive;
  late final List<_ChartData> chartData;

  GoalWidget({
    required this.goal,
    this.isActive = true,
  }) {
    chartData = [
      _ChartData(goal.progress.toDouble()),
      _ChartData(100.0 - goal.progress),
    ];
  }

  double get textSize {
    var maxLength = goal.target.toString().length;
    var textSize = 26.0;

    if (maxLength > 7) {
      textSize = 20.0;
    }
    if (maxLength > 9) {
      textSize = 18.0;
    }
    if (maxLength > 11) {
      textSize = 12.0;
    }

    return textSize;
  }

  Widget _amountWidget(String title, String number) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: title, type: LabelType.GreyLabel),
          Label(text: '\$$number', type: LabelType.Header2, fontSize: textSize),
        ],
      );

  Widget _cashColumn(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _amountWidget(AppLocalizations.of(context)!.funded,
              goal.totalFunded.numericFormattedString()),
          SizedBox(height: 20),
          _amountWidget(AppLocalizations.of(context)!.targetAmount,
              goal.target.numericFormattedString()),
          SizedBox(height: 20),
          _amountWidget(AppLocalizations.of(context)!.fundingRemaining,
              (goal.target - goal.totalFunded).numericFormattedString()),
        ],
      );

  Widget _radialChartWidget() => Container(
        width: 250,
        height: 250,
        child: SfCircularChart(
          margin: EdgeInsets.zero,
          palette: [
            goal.color,
            Color.fromRGBO(234, 237, 243, 1),
          ],
          annotations: [
            CircularChartAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    text: goal.progress.toString() + '%',
                    type: LabelType.Header3,
                  ),
                  Label(
                    text: CustomDateFormats.defaultDateFormat
                            .format(goal.startDate) +
                        ' -',
                    type: LabelType.GreyLabel,
                  ),
                  Label(
                    text: CustomDateFormats.defaultDateFormat
                        .format(goal.endDate)
                        .toString(),
                    type: LabelType.GreyLabel,
                  ),
                ],
              ),
            ),
          ],
          series: <CircularSeries>[
            DoughnutSeries<_ChartData, String>(
              animationDuration: 0,
              selectionBehavior: SelectionBehavior(enable: false),
              explode: false,
              explodeAll: false,
              explodeOffset: '0%',
              innerRadius: '90%',
              explodeGesture: ActivationMode.none,
              radius: '80%',
              dataSource: chartData,
              startAngle: 270,
              endAngle: 270,
              xValueMapper: (_ChartData data, _) => '',
              yValueMapper: (_ChartData data, _) => data.y,
            )
          ],
        ),
      );

  Widget _topRow(BuildContext context) {
    var homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    var goalsCubit = BlocProvider.of<GoalsCubit>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              ClipOval(
                child: goal.iconUrl != null
                    ? Image.network(
                        goal.iconUrl!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/goal_ph.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Label(
                  text: goal.goalName,
                  type: LabelType.Header2,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            if (homeScreenCubit.currentForeignSession?.access.isReadOnly != true)
              Row(
                children: [
                  ButtonItemTransparent(
                    context,
                    text: isActive
                        ? AppLocalizations.of(context)!.archive
                        : AppLocalizations.of(context)!.unarchive,
                    onPressed: () {
                      isActive
                          ? goalsCubit.archiveGoal(goal.id)
                          : goalsCubit.unarchiveGoal(
                              goal.id,
                              () => showDialog(
                                context: context,
                                builder: (_) {
                                  return InformAlertDialog(
                                    context,
                                    title: AppLocalizations.of(context)!
                                        .youCouldHaveOnly8ActiveGoals,
                                  );
                                },
                              ),
                            );
                    },
                  ),
                  if (isActive) SizedBox(width: 16),
                  if (isActive)
                    CustomMaterialInkWell(
                      border: CircleBorder(),
                      onTap: () {
                        goalsCubit.navigateToEditGoalPage(context, goal: goal);
                      },
                      type: InkWellType.Purple,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ImageIcon(
                          AssetImage('assets/images/icons/edit_ic.png'),
                          color: CustomColorScheme.button,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 65),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColorScheme.blockBackground,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            _topRow(context),
            SizedBox(height: 10),
            Visibility(
              visible: goal.note != null && goal.note!.isNotEmpty,
              child: Container(
                padding: EdgeInsets.all(5),
                color: CustomColorScheme.tableBorder,
                child: goal.note == null
                    ? null
                    : Label(
                        text: 'Note: ' + goal.note!,
                        type: LabelType.General,
                      ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cashColumn(context),
                _radialChartWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final double y;

  _ChartData(this.y);
}
