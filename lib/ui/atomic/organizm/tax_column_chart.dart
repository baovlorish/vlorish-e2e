import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TaxColumnChart extends StatefulWidget {
  final List<TaxChartData>? data;
  final double? maximum;
  final Future<void> Function(bool) updateDataCallback;

  const TaxColumnChart(
      {Key? key,
      required this.data,
      this.maximum,
      required this.updateDataCallback})
      : super(key: key);

  @override
  State<TaxColumnChart> createState() => _TaxColumnChartState();
}

class _TaxColumnChartState extends State<TaxColumnChart> {
  var ficaSwitchValue = false;

  late var xMapper = [
    AppLocalizations.of(context)!.quarterOne,
    AppLocalizations.of(context)!.quarterTwo,
    AppLocalizations.of(context)!.quarterThree,
    AppLocalizations.of(context)!.quarterFour,
  ];

  @override
  Widget build(BuildContext context) {
    late var data = widget.data ?? List.filled(4, TaxChartData.empty());
    late var maximum = widget.maximum;

    if (widget.maximum != null) {
      if (maximum == 0) {
        maximum = null;
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
                text: AppLocalizations.of(context)!.yourEstimatedTaxes,
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 40,
            ),
            CustomSwitch(
                variable: ficaSwitchValue,
                text: AppLocalizations.of(context)!.fica,
                textToTheRight: true,
                callback: (value) async {
                  ficaSwitchValue = value;
                  await widget.updateDataCallback(ficaSwitchValue);
                  // setState(() {});
                }),
          ],
        ),
        SizedBox(
          width: 480,
          height: 320,
          child: Stack(
            children: [
              if (widget.data == null)
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
                tooltipBehavior: TooltipBehavior(
                  decimalPlaces: 2,
                  enable: true,
                  canShowMarker: true,
                  activationMode: ActivationMode.singleTap,
                ),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compactSimpleCurrency(),
                  maximum: maximum ?? 1000000,
                  decimalPlaces: 0,
                ),
                series: <ChartSeries<TaxChartData, String>>[
                  ColumnSeries<TaxChartData, String>(
                    dataSource: data,
                    name: 'Federal Tax',
                    xValueMapper: (TaxChartData data, index) => xMapper[index],
                    yValueMapper: (TaxChartData data, _) => data.federal,
                    color: CustomColorScheme.errorPopupButton,
                  ),
                  ColumnSeries<TaxChartData, String>(
                    dataSource: data,
                    name: 'State Tax',
                    enableTooltip: true,
                    xValueMapper: (TaxChartData data, index) => xMapper[index],
                    yValueMapper: (TaxChartData data, _) => data.state,
                    color: CustomColorScheme.mainDarkBackground,
                  ),
                  if (ficaSwitchValue)
                    ColumnSeries<TaxChartData, String>(
                      dataSource: data,
                      name: 'FICA',
                      xValueMapper: (TaxChartData data, index) =>
                          xMapper[index],
                      yValueMapper: (TaxChartData data, _) => data.fica,
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
}

class TaxChartData {
  TaxChartData(
    this.federal,
    this.state,
    this.fica,
  );

  factory TaxChartData.empty() => TaxChartData(0, 0, 0);

  final double federal;
  final double state;
  final double fica;

  @override
  String toString() {
    return 'TaxChartData{federal: $federal, state: $state, fica: $fica}';
  }
}
