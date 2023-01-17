import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RetirementColumnChart extends StatefulWidget {
  final RetirementPageModel data;
  final List<String> xMapper;

  const RetirementColumnChart(
      {Key? key, required this.data, required this.xMapper})
      : super(key: key);

  @override
  State<RetirementColumnChart> createState() => _RetirementColumnChart();
}

class _RetirementColumnChart extends State<RetirementColumnChart> {
  late var investmentsCubit = BlocProvider.of<InvestmentsCubit>(context);

  late var xMapper = widget.xMapper;

  @override
  Widget build(BuildContext context) {
    var selected =
        ((investmentsCubit.state) as InvestmentsLoaded).retirementGrowth;

    var data = <InvestmentsChartData>[];
    for (var index = 1; index < 14; index++) {
      {
        if (selected.any((element) => element == index)) {
          data.add(InvestmentsChartData(widget.data.chartValues[index] ?? 0));
        }
      }
    }

    var mapper = <String>[];
    for (var index in selected) {
      {
        mapper.add(
          widget.data.typeMap[index] ?? '',
        );
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Label(
                type: LabelType.Header3,
                text: 'Retirement growth',
                fontSize: 18,
              ),
            ),
            ModalAnchor(
              tag: 'igr',
              child: CustomMaterialInkWell(
                onTap: () {
                  showOptions(selected, investmentsCubit);
                },
                type: InkWellType.Purple,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Icon(
                    Icons.more_vert,
                    color: CustomColorScheme.text,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 520,
          height: 320,
          child: Stack(
            children: [
              if (widget.data.models.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 48.0),
                    child: Label(
                      text: AppLocalizations.of(context)!.noData,
                      type: LabelType.HintLargeBold,
                      color: CustomColorScheme.inputBorder,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelIntersectAction: AxisLabelIntersectAction.trim,
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compactSimpleCurrency(),
                ),
                series: <ChartSeries<InvestmentsChartData, String>>[
                  ColumnSeries<InvestmentsChartData, String>(
                    dataSource: data,
                    xValueMapper: (InvestmentsChartData data, index) =>
                        mapper[index],
                    yValueMapper: (InvestmentsChartData data, _) => data.value,
                    color: CustomColorScheme.errorPopupButton,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showOptions(List<int> selected, InvestmentsCubit cubit) {
    showModal(
      ModalEntry.anchored(
        context,
        anchorAlignment: Alignment.topRight,
        modalAlignment: Alignment.topLeft,
        barrierDismissible: true,
        anchorTag: 'igr',
        tag: 'igrModal',
        child: BlocProvider<InvestmentsCubit>.value(
          value: cubit,
          child: BlocBuilder<InvestmentsCubit, InvestmentsState>(
              builder: (context, state) {
            return Container(
              color: Colors.white,
              width: 170,
              key: UniqueKey(),
              child: RGrowthSelector(selected, cubit),
            );
          }),
        ),
      ),
    );
  }
}

class RGrowthSelector extends StatefulWidget {
  final List<int> selected;
  final InvestmentsCubit cubit;

  const RGrowthSelector(this.selected, this.cubit, {Key? key})
      : super(key: key);

  @override
  _RGrowthSelectorState createState() => _RGrowthSelectorState();
}

class _RGrowthSelectorState extends State<RGrowthSelector> {
  late var selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    var items = {};
    (widget.cubit.state as InvestmentsLoaded)
        .retirements!
        .typeMap
        .forEach((key, value) {
      items[key] = false;
    });
    for (var item in selected) {
      items[item] = true;
    }
    return Material(
      key: UniqueKey(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var item in items.entries.toList())
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Checkbox(
                    splashRadius: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    value: item.value,
                    onChanged: (newValue) {
                      widget.cubit
                          .changeRetirementGrowth(item.key, newValue ?? false);
                      setState(() {});
                    },
                  ),
                  Label(
                      text: (widget.cubit.state as InvestmentsLoaded)
                              .retirements!
                              .typeMap[item.key] ??
                          '',
                      type: LabelType.General),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class InvestmentsChartData {
  InvestmentsChartData(
    this.value,
  );

  factory InvestmentsChartData.empty() => InvestmentsChartData(0);

  final double value;
}
