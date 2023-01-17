import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChartWidget extends StatelessWidget {
  final SplineChartModel model;

  final TooltipBehavior _tooltipBehavior = TooltipBehavior(
    decimalPlaces: 1,
    enable: true,
    canShowMarker: true,
    activationMode: ActivationMode.singleTap,
  );

  SplineChartWidget({required this.model});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(labelPlacement: LabelPlacement.onTicks),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries>[
          for (var chart in model.splines)
            SplineSeries<SplineChartData, String>(
              name: chart.name,
              color: chart.color,
              enableTooltip: true, // ono
              dataSource: chart.data,
              splineType: SplineType.monotonic,
              markerSettings: MarkerSettings(
                height: 6,
                width: 6,
                color: chart.color,
                shape: DataMarkerType.circle,
                isVisible: true,
              ),
              xValueMapper: (SplineChartData sales, _) => sales.month,
              yValueMapper: (SplineChartData sales, _) => sales.netWorth,
            ),
        ],
        primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelFormat: '{value}',
            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)));
  }
}

class SplineChartData {
  final String month;
  final int? netWorth;

  SplineChartData(this.month, this.netWorth);
}

class SplineUiModel {
  final String name;
  final List<SplineChartData> data;
  final Color color;

  SplineUiModel({
    required this.name,
    required this.data,
    required this.color,
  });
}

class SplineChartModel {
  final Period period;
  final List<SplineUiModel> splines;
  final List<String> monthNames = [];

  SplineChartModel({
    required this.splines,
    required this.period,
  }) {
    period.months.forEach((date) {
      monthNames.add(period.monthString(date.month));
    });
  }
}
