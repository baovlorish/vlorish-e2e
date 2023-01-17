import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class ExpandableMenuItem extends StatefulWidget {
  final List<Widget> children;
  final bool initiallyExpanded;
  final String titleText;
  final String assetUrl;
  final Function(bool) onExpansionChanged;
  final double order;

  const ExpandableMenuItem({
    required this.initiallyExpanded,
    required this.titleText,
    required this.children,
    required this.assetUrl,
    required this.onExpansionChanged,
    required this.order,
  });

  @override
  State<ExpandableMenuItem> createState() =>
      _ExpandableMenuItemState(initiallyExpanded);
}

class _ExpandableMenuItemState extends State<ExpandableMenuItem> {
  bool isExpanded;

  _ExpandableMenuItemState(this.isExpanded);

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(widget.order),
      child: CustomMaterialInkWell(
        type: InkWellType.White,
        child: Theme(
          data: Theme.of(context).copyWith(
            focusColor: CustomColorScheme.whiteInkWell,
            hoverColor: CustomColorScheme.whiteInkWell,
          ),
          child: ExpansionTile(
            initiallyExpanded: widget.initiallyExpanded,
            title: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                ImageIcon(
                  AssetImage(widget.assetUrl),
                  color: CustomColorScheme.textColorMenu,
                  size: 24,
                ),
                SizedBox(
                  width: 16,
                ),
                Label(
                    text: widget.titleText,
                    color: CustomColorScheme.textColorMenu,
                    type: LabelType.GeneralBold),
              ],
            ),
            trailing: ImageIcon(
              AssetImage('assets/images/icons/plus.png'),
              color: isExpanded
                  ? Colors.transparent
                  : CustomColorScheme.textColorMenu,
              size: 24,
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                isExpanded = expanded;
                widget.onExpansionChanged(isExpanded);
              });
            },
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
