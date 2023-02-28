import 'package:burgundy_budgeting_app/ui/atomic/atom/forbidden_mouse_cursor.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

enum TransparentButtonType { SmallText, LargeText }

class ButtonItemTransparent extends StatelessWidget {
  final String text;
  final BuildContext context;
  final VoidCallback onPressed;
  final TransparentButtonType buttonType;
  final bool enabled;
  final ImageIcon? icon;
  final Color? color;

  const ButtonItemTransparent(
    this.context, {
    required this.text,
    this.buttonType = TransparentButtonType.SmallText,
    required this.onPressed,
    this.enabled = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) => TextButton(
        style: enabled
            ? ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                overlayColor: MaterialStateProperty.all<Color>(
                  CustomColorScheme.whiteInkWell,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  CustomColorScheme.whiteInkWell,
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
              )
            : ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                mouseCursor: const ForbiddenMouseCursor(),
                overlayColor: MaterialStateProperty.all<Color>(
                  CustomColorScheme.dividerInkWell,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  CustomColorScheme.dividerInkWell,
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
              ),
        onPressed: enabled ? onPressed : null,
        child: Container(
          padding: buttonType == TransparentButtonType.SmallText
              ? EdgeInsets.all(6)
              : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: color ?? CustomColorScheme.button)),
          child: Center(
            child: Row(
              mainAxisAlignment: icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: icon,
                  ),
                Label(
                  text: text,
                  type: buttonType == TransparentButtonType.SmallText ? LabelType.Button : LabelType.LargeButton,
                  color: color ?? CustomColorScheme.button,
                ),
              ],
            ),
          ),
        ),
      );
}
