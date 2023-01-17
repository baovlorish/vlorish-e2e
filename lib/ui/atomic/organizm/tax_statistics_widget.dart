import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/statistics_widget.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/model/tax_estimated_taxes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TaxStatisticsWidget extends StatefulWidget {
  final EstimatedTaxesModel? model;

  const TaxStatisticsWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _TaxStatisticsWidgetState createState() => _TaxStatisticsWidgetState();
}

class _TaxStatisticsWidgetState extends State<TaxStatisticsWidget> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoneyInfoCard(
                color: CustomColorScheme.clipElementInactive,
                title: AppLocalizations.of(context)!.totalIncome,
                amount: widget.model?.totalIncome ?? 0,
              ),
              MoneyInfoCard(
                color: CustomColorScheme.tableBorder,
                title: AppLocalizations.of(context)!.taxableIncome,
                tooltip: AppLocalizations.of(context)!.taxableIncomeTooltip,
                amount: widget.model?.taxableIncome ?? 0,
                textColor: CustomColorScheme.text,
              ),
            ],
          ),
          StatisticsWidget(
            key: ObjectKey(widget.model?.taxPieChartData ?? 'emptyPieChart'),
            presetSum: widget.model?.taxPieChartData?.totalTaxLiability ?? 0,
            allowZeroPercent:
                widget.model?.taxPieChartData?.totalTaxLiability != null &&
                    widget.model?.taxPieChartData?.totalTaxLiability != 0,
            models: [
              StatisticModel(
                  amount:
                      widget.model?.taxPieChartData?.taxWithholdings?.value ??
                          0,
                  name: AppLocalizations.of(context)!.taxWithholdings,
                  totalAmount:
                      widget.model?.taxPieChartData?.totalTaxLiability ?? 0,
                  progress: widget.model?.taxPieChartData?.taxWithholdings
                          ?.percentageOfTotal
                          ?.toInt() ??
                      0,
                  color: CustomColorScheme.mainDarkBackground),
              StatisticModel(
                  amount: widget
                          .model?.taxPieChartData?.estimatedTaxesPaid?.value ??
                      0,
                  name: AppLocalizations.of(context)!.estimatedTaxesPaid,
                  totalAmount:
                      widget.model?.taxPieChartData?.totalTaxLiability ?? 0,
                  progress: widget.model?.taxPieChartData?.estimatedTaxesPaid
                          ?.percentageOfTotal
                          ?.toInt() ??
                      0,
                  color: CustomColorScheme.goalColor3),
              StatisticModel(
                  amount:
                      widget.model?.taxPieChartData?.remainingBalance?.value ??
                          0,
                  name: widget.model?.taxPieChartData
                              ?.isRemainingBalanceNegative ==
                          false
                      ? AppLocalizations.of(context)!.remainingBalance
                      : 'Tax Refund',
                  totalAmount:
                      widget.model?.taxPieChartData?.totalTaxLiability ?? 0,
                  progress: widget.model?.taxPieChartData?.remainingBalance
                          ?.percentageOfTotal
                          ?.toInt() ??
                      0,
                  color: CustomColorScheme.goalColor5),
            ],
            isHorizontal: true,
            emptyStateHeader: AppLocalizations.of(context)!.noData,
            emptyStateDescription:
                widget.model?.taxPieChartData?.isTotalTaxLiabilityNegative ==
                        false
                    ? AppLocalizations.of(context)!.totalTaxLiability
                    : 'Negative Tax Liability',
            pieChartInnerText:
                widget.model?.taxPieChartData?.isTotalTaxLiabilityNegative ==
                        false
                    ? AppLocalizations.of(context)!.totalTaxLiability
                    : 'Negative Tax Liability',
            chartSize: 240,
            withPercent: true,
            maxLegendLength: 400,
          )
        ],
      ),
    );
  }
}

class MoneyInfoCard extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String title;
  final String? tooltip;
  final double amount;
  final String? imageUrl;
  final double? growth;
  final EdgeInsets padding;

  const MoneyInfoCard({
    Key? key,
    required this.color,
    required this.title,
    this.tooltip,
    this.padding = const EdgeInsets.all(16.0),
    required this.amount,
    this.textColor = Colors.white,
    this.imageUrl,
    this.growth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = NumberFormat.compactSimpleCurrency().format(amount);
    var tooltipText = NumberFormat.simpleCurrency().format(amount);
    return Padding(
      padding: padding,
      child: Container(
        height: 120,
        width: 300,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: title,
                  type: LabelType.General,
                  color: textColor,
                ),
                if (tooltip != null)
                  CustomTooltip(
                    message: tooltip,
                    child: Icon(
                      Icons.info_rounded,
                      color: CustomColorScheme.taxInfoTooltip,
                    ),
                  ),
                if (imageUrl != null)
                  SizedBox(
                    height: 24,
                    child: Image.asset(
                      imageUrl!,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTooltip(
                  message: tooltipText,
                  color: CustomColorScheme.taxInfoTooltip,
                  child: Label(
                    text: text,
                    type: LabelType.Header,
                    color: textColor,
                  ),
                ),
                if (growth != null)
                  GrowthWithPercentageWidget(
                    growth: growth,
                    currencyFormat: true,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GrowthWithPercentageWidget extends StatelessWidget {
  const GrowthWithPercentageWidget({
    Key? key,
    required this.growth,
    this.currencyFormat = false,
  }) : super(key: key);
  final double? growth;

  ///When number bigger than 1000 turns to currencyFormat(), like 1k
  final bool currencyFormat;

  @override
  Widget build(BuildContext context) {
    var growthColor = growth != null && growth! > 0
        ? CustomColorScheme.successPopupButton
        : CustomColorScheme.errorPopupButton;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 12,
            child: Image.asset(
              growth! > 0
                  ? 'assets/images/icons/growth_up.png'
                  : 'assets/images/icons/growth_down.png',
              fit: BoxFit.scaleDown,
              color: growthColor,
            ),
          ),
        ),
        if (growth != null &&
            currencyFormat &&
            !growth!.isInfinite &&
            (growth! >= 1000 || growth! <= -1000))
          CustomTooltip(
            message:
                '${growth! > 0 ? '+' : ''}${NumberFormat.simpleCurrency().format(growth).replaceRange(0, 1, '')}%',
            child: Label(
              text:
                  '${growth! > 0 ? '+' : ''}${NumberFormat.compactCurrency().format(growth).replaceRange(0, 3, '')}%',
              type: LabelType.General,
              color: growthColor,
            ),
          )
        else
          Label(
            text: '${growth! > 0 ? '+' : ''}${growth!.toStringAsFixed(2)}%',
            type: LabelType.General,
            color: growthColor,
          ),
      ],
    );
  }
}
