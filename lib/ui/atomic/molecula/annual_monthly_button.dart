import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class TabSelectorButton extends StatelessWidget {
  final String labelText;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isActive;
  final EdgeInsets padding;

  const TabSelectorButton({
    Key? key,
    required this.labelText,
    required this.onPressed,
    required this.isSelected,
    this.isActive = true,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  bool isInvestTab(String labelText) {
    //TODO: need fix later
    return labelText == 'Stocks' ||
        labelText == '401a' ||
        labelText == 'Index Funds' ||
        labelText == 'Cryptocurrency' ||
        labelText == 'Inv. Properties' ||
        labelText == 'Startups' ||
        labelText == 'Other' ||
        labelText == '401k' ||
        labelText == 'Roth 401k' ||
        labelText == 'IRA' ||
        labelText == 'Roth IRA' ||
        labelText == 'SEP IRA' ||
        labelText == '403b' ||
        labelText == '457b' ||
        labelText == 'Roth 457b' ||
        labelText == 'TSP' ||
        labelText == 'RRSP' ||
        labelText == 'TFSA' ||
        labelText == 'Other';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CustomMaterialInkWell(
        borderRadius: BorderRadius.circular(4.0),
        type: InkWellType.Purple,
        onTap: isInvestTab(labelText)
            ? onPressed
            : (isSelected || !isActive)
                ? null
                : onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                  text: labelText,
                  type: LabelType.GeneralBold,
                  color: isSelected
                      ? CustomColorScheme.twoOptionsActive
                      : isActive
                          ? CustomColorScheme.clipElementInactive
                          : CustomColorScheme.textHint,
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 2.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: isSelected
                        ? CustomColorScheme.twoOptionsActive
                        : Colors.transparent,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
