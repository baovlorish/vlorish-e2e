import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/linear_legend.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsWidget extends StatefulWidget {
  final bool isHorizontal;
  final String emptyStateHeader;
  final String emptyStateDescription;
  final bool withPercent;
  final double? presetSum;
  final bool showSumWithPercent;
  final bool alwaysShowScrollbar;
  final bool allowZeroPercent;
  final double initialScrollOffset;
  final Function(double value)? onScrollOffsetChanged;
  final void Function(String value)? onTap;
  final String? pieChartInnerText;
  final List<StatisticModel> models;
  final double chartSize;
  final double maxLegendLength;
  final bool splitColumns;

  StatisticsWidget({
    Key? key,
    required this.models,
    required this.isHorizontal,
    required this.emptyStateHeader,
    required this.emptyStateDescription,
    required this.withPercent,
    this.presetSum,
    this.showSumWithPercent = true,
    this.allowZeroPercent = true,
    this.alwaysShowScrollbar = true,
    this.initialScrollOffset = 0.0,
    this.onScrollOffsetChanged,
    this.onTap,
    this.pieChartInnerText,
    this.chartSize = 300,
    this.maxLegendLength = 500,
    this.splitColumns = true,
  }) : super(key: key);

  @override
  _StatisticsWidgetState createState() =>
      _StatisticsWidgetState(initialScrollOffset);
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  final List<LinearLegend> legends = [];
  final List<Widget> adaptiveColumns = [];
  final List<_ChartData> chartData = [];
  late final ScrollController _statisticsScrollController;
  double sum = 0;

  _StatisticsWidgetState(double initialScrollOffset) {
    _statisticsScrollController =
        ScrollController(initialScrollOffset: initialScrollOffset);
  }

  bool get isOnlyOneModel =>
      widget.models.length == 1 && widget.models.first.amount == 0.0;

  @override
  void didChangeDependencies() {
    if (isOnlyOneModel) {
      chartData.add(_ChartData(
        '',
        1,
        CustomColorScheme.tableBorder,
      ));

      legends.add(LinearLegend(
        model: widget.models.first,
        withPercent: widget.withPercent,
        showSumWithPercent: widget.showSumWithPercent,
        onTap: widget.onTap,
        maxWidth: widget.maxLegendLength,
        allowZeroPercent: widget.allowZeroPercent,
      ));

      adaptiveColumns.add(Column(
        children: legends.sublist(
            widget.models.length - widget.models.length % 4,
            widget.models.length),
      ));
    } else if (widget.models.isNotEmpty) {
      widget.models.forEach((element) {
        sum += element.amount;

        legends.add(LinearLegend(
          model: element,
          withPercent: widget.withPercent,
          showSumWithPercent: widget.showSumWithPercent,
          onTap: widget.onTap,
          maxWidth: widget.maxLegendLength,
          allowZeroPercent: widget.allowZeroPercent,
        ));

        chartData.add(_ChartData(
          element.name,
          element.amount.toDouble(),
          element.color,
        ));
      });

      if (chartData.any((element) => element.y * 100.0 / sum >= 99.9)) {
        var tooLargeElement =
            chartData.firstWhere((element) => element.y * 100.0 / sum >= 99.9);
        chartData.clear();
        chartData.add(tooLargeElement);
      }
      for (var i = 0;
          i < widget.models.length - widget.models.length % 4;
          i += 4) {
        adaptiveColumns.add(Column(
          children: legends.sublist(i, i + 4),
        ));
      }

      adaptiveColumns.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: legends.sublist(
            widget.models.length - widget.models.length % 4,
            widget.models.length),
      ));
      if (sum == 0) {
        chartData.clear();
        chartData.add(_ChartData(
          '',
          1,
          CustomColorScheme.tableBorder,
        ));
      }
    } else {
      chartData.add(_ChartData(
        '',
        1,
        CustomColorScheme.tableBorder,
      ));

      adaptiveColumns.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: widget.emptyStateHeader,
              type: LabelType.HintLargeBold,
              color: CustomColorScheme.inputBorder,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Label(
              text: widget.emptyStateDescription,
              type: LabelType.GreyLabel,
              color: CustomColorScheme.inputBorder,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ));
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _statisticsScrollController.addListener(() {
      if (widget.onScrollOffsetChanged != null) {
        widget.onScrollOffsetChanged!(_statisticsScrollController.offset);
      }
    });
    return Scrollbar(
      controller: _statisticsScrollController,
      thumbVisibility: widget.alwaysShowScrollbar,
      interactive: true,
      child: Container(
        height: (widget.isHorizontal && widget.splitColumns)? widget.chartSize : null,
        child: widget.isHorizontal
            ? widget.splitColumns
                ? SingleChildScrollView(
                    controller: _statisticsScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [radialChart(), ...adaptiveColumns],
                    ),
                  )
                : SingleChildScrollView(
                    controller: _statisticsScrollController,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        radialChart(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [...legends],
                        )
                      ],
                    ),
                  )
            : SingleChildScrollView(
                controller: _statisticsScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    radialChart(),
                    if (widget.models.isNotEmpty)
                      ...legends
                    else
                      ...adaptiveColumns
                  ],
                ),
              ),
      ),
    );
  }

  Widget radialChart() => Container(
        width: widget.chartSize,
        height: widget.chartSize,
        padding: widget.isHorizontal ? EdgeInsets.only(bottom: 8) : null,
        child: SfCircularChart(
          margin: EdgeInsets.zero,
          onSelectionChanged: (args) {
            if (widget.onTap != null) {
              widget.onTap!(
                widget.models[args.pointIndex].name,
              );
            }
          },
          annotations: [
            CircularChartAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    fontSize: textSize,
                    text:
                        '\$${(widget.presetSum?.toInt() ?? sum).toInt().numericFormattedString()}',
                    type: LabelType.Header,
                  ),
                  Label(
                    text: widget.pieChartInnerText ??
                        AppLocalizations.of(context)!.total,
                    type: LabelType.GreyLabel,
                  ),
                ],
              ),
            ),
          ],
          series: <CircularSeries>[
            DoughnutSeries<_ChartData, String>(
              animationDuration: 0,
              selectionBehavior: SelectionBehavior(enable: true),
              explode: false,
              explodeAll: false,
              explodeOffset: '0%',
              innerRadius: '90%',
              explodeGesture: ActivationMode.none,
              radius: '95%',
              startAngle: 270,
              endAngle: 270,
              dataSource: chartData,
              pointColorMapper: (_ChartData data, _) => data.color,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
            )
          ],
        ),
      );

  double get textSize {
    var textSize = 28.0;
    var maxLength = sum.toString().length;
    if (maxLength > 6) {
      textSize = 24.0;
    }
    if (maxLength > 9) {
      textSize = 20.0;
    }
    if (maxLength > 11) {
      textSize = 16.0;
    }

    return textSize;
  }
}

class _ChartData {
  final String x;
  final double y;
  final Color color;

  _ChartData(this.x, this.y, this.color);
}
