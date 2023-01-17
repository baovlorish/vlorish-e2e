import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;

  const CustomDivider({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: color ?? CustomColorScheme.dividerColor,
    );
  }
}
