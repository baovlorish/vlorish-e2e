import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_indicator_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class HintWidget extends StatelessWidget {
  final String hint;
  const HintWidget({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return  CustomTooltip(
      message: hint,
      child: CustomIndicatorWidget(
        size: 24,
        color: Colors.transparent,
        child: Icon(
          Icons.info,
          size: 24,
          color: CustomColorScheme.clipElementInactive,
        ),
      ),
    );
  }
}
