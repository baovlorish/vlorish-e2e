import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class CustomTooltip extends StatelessWidget {
  final String? message;
  final Widget child;
  final Color? color;
  final bool preferBelow;

  CustomTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.color,
    this.preferBelow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => message != null && message!.isNotEmpty
      ? Tooltip(
    message: message!,
    textStyle: CustomTextStyle.TooltipTextStyle(context),
    preferBelow: preferBelow,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: color ?? CustomColorScheme.mainDarkBackground,
    ),
    child: child,
  )
      : child;
}
