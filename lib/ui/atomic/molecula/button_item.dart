import 'package:burgundy_budgeting_app/ui/atomic/atom/forbidden_mouse_cursor.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

enum ButtonType { SmallText, LargeText, White }

class ButtonItem extends TextButton {
  final String text;
  final BuildContext context;
  @override
  final VoidCallback onPressed;
  final ButtonType buttonType;
  @override
  final bool enabled;
  final bool isSmallButton;
  @override
  final FocusNode? focusNode;

  ButtonItem(
    this.context, {
    required this.text,
    this.buttonType = ButtonType.SmallText,
    this.enabled = true,
    this.isSmallButton = false,
    required this.onPressed,
    this.focusNode,
  }) : super(
          focusNode: focusNode,
          onPressed: enabled ? onPressed : null,
          style: enabled
              ? ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  overlayColor: buttonType == ButtonType.White
                      ? MaterialStateProperty.all<Color>(
                          CustomColorScheme.purpleInkWell,
                        )
                      : MaterialStateProperty.all<Color>(
                          CustomColorScheme.whiteInkWell,
                        ),
                  foregroundColor: buttonType == ButtonType.White
                      ? MaterialStateProperty.all<Color>(
                          CustomColorScheme.purpleInkWell,
                        )
                      : MaterialStateProperty.all<Color>(
                          CustomColorScheme.whiteInkWell,
                        ),
                  backgroundColor: enabled
                      ? buttonType == ButtonType.White
                          ? MaterialStateProperty.all<Color>(Colors.white)
                          : MaterialStateProperty.all<Color>(
                              CustomColorScheme.button)
                      : MaterialStateProperty.all<Color>(
                          CustomColorScheme.dividerColor),
                )
              : ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  mouseCursor: const ForbiddenMouseCursor(),
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      CustomColorScheme.dividerColor),
                ),
          child: Container(
            padding: buttonType == ButtonType.SmallText || isSmallButton
                ? EdgeInsets.all(10)
                : EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: enabled
                  ? Border.all(color: CustomColorScheme.button)
                  : isSmallButton
                      ? Border.all(color: CustomColorScheme.whiteInkWell)
                      : null,
            ),
            child: Center(
              child: Label(
                text: text,
                type: buttonType == ButtonType.SmallText || isSmallButton
                    ? LabelType.Button
                    : LabelType.LargeButton,
                color: buttonType == ButtonType.White
                    ? CustomColorScheme.button
                    : CustomColorScheme.blockBackground,
              ),
            ),
          ),
        );
}
