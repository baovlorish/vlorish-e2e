import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class LinearLegend extends StatelessWidget {
  final StatisticModel model;
  final bool withPercent;
  final double maxWidth;
  final bool showSumWithPercent;
  final void Function(String value)? onTap;
  final bool allowZeroPercent;

  const LinearLegend({
    Key? key,
    required this.model,
    required this.withPercent,
    required this.showSumWithPercent,
    this.allowZeroPercent = true,
    this.maxWidth = 500,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var canShowPercent = model.progress != 0 || allowZeroPercent;
    return CustomMaterialInkWell(
      type: InkWellType.Purple,

      borderRadius: BorderRadius.circular(5),
      onTap: () {
        if (onTap != null) {
          onTap!(model.name);
        }
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: maxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Label(
                            text: model.name.replaceAll(' ', '\u00a0'),
                            type: LabelType.Hint,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                        if (model.hint != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTooltip(
                              message: model.hint!,
                              child: Icon(
                                Icons.info_rounded,
                                color: CustomColorScheme.taxInfoTooltip,
                              ),
                            ),
                          ),
                        if (withPercent && showSumWithPercent)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Label(
                              text:
                                  '\$${model.amount.toInt().numericFormattedString()}',
                              type: LabelType.GeneralBold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  (withPercent && canShowPercent)
                      ? Label(
                          text: '${model.progress}%',
                          type: showSumWithPercent
                              ? LabelType.General
                              : LabelType.GeneralBold,
                        )
                      : canShowPercent ? Label(
                          text:
                              '\$${model.amount.toInt().numericFormattedString()}',
                          type: LabelType.GeneralBold,
                        ) : SizedBox(),
                ],
              ),
            ),
            SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColorScheme.legendUnfilled,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: model.progress,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: model.color,
                          ),
                        ),
                      ),
                      Flexible(flex: 100 - model.progress, child: Container()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
