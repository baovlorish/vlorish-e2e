import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final FocusNode? focusNode;
  final Color? borderColor;
  final double? borderWidth;

  const TransparentButton(
      {Key? key, this.onPressed, required this.child, this.focusNode, this.borderColor, this.borderWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        focusNode: focusNode,
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? VersionTwoColorScheme.White, width: borderWidth ?? 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: child);
  }
}
