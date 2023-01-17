import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class CustomVerticalDivider extends StatelessWidget {
  final Color? color;

  const CustomVerticalDivider({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 1,
      thickness: 1,
      color: color ?? CustomColorScheme.dividerColor,
    );
  }
}
