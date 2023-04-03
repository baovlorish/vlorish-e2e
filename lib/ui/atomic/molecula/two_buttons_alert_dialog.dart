import 'package:burgundy_budgeting_app/ui/atomic/atom/colored_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/transparent_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'button_item.dart';
import 'label_button_item.dart';

// todo: (andreyK): remove
class TwoButtonsDialog extends AlertDialog {
  TwoButtonsDialog(
    BuildContext context, {
    String? title,
    required String mainButtonText,
    required void Function() onMainButtonPressed,
    bool enableNavigationPopMainButton = true,
    bool enableMainButton = true,
    double height = 300,
    double width = 600,
    String? message,
    Widget? bodyWidget,
    String? dismissButtonText,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceAround,
    void Function()? onDismissButtonPressed,
    bool showCloseButton = true,
  }) : super(
          contentPadding: EdgeInsets.all(20),
          content: Container(
            width: width,
            height: showCloseButton ? height + 44 : height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (showCloseButton)
                  Align(
                    alignment: Alignment.topRight,
                    child: CustomMaterialInkWell(
                      type: InkWellType.Purple,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: CustomColorScheme.close,
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: mainAxisAlignment,
                    children: [
                      if (title != null)
                        Label(
                          text: title,
                          type: LabelType.Header2,
                          textAlign: TextAlign.center,
                        ),
                      if (message != null)
                        Label(
                          text: message,
                          type: LabelType.General,
                        ),
                      if (bodyWidget != null) bodyWidget,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Center(
                              child: LabelButtonItem(
                                label: Label(
                                  text: dismissButtonText ?? AppLocalizations.of(context)!.no,
                                  type: LabelType.LargeButton,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (onDismissButtonPressed != null) {
                                    onDismissButtonPressed();
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ButtonItem(
                              context,
                              text: mainButtonText,
                              buttonType: ButtonType.LargeText,
                              enabled: enableMainButton,
                              onPressed: () {
                                if (enableMainButton) {
                                  if (enableNavigationPopMainButton) {
                                    Navigator.pop(context);
                                  }
                                  onMainButtonPressed();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}

class ButtonParams {
  final String text;
  final isEnabled;
  final VoidCallback? onPressed;

  const ButtonParams(
    this.text, {
    this.onPressed,
    this.isEnabled = true,
  });
}

class TwoButtonDialogNew extends StatelessWidget {
  final String title;
  final String description;
  final ButtonParams leftButtonParams;
  final ButtonParams rightButtonParams;
  final Widget? child;

  static const spaceSize = 30.0;

  const TwoButtonDialogNew({
    super.key,
    required this.title,
    required this.description,
    required this.leftButtonParams,
    required this.rightButtonParams,
    this.child,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        insetPadding: EdgeInsets.all(spaceSize),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Label(text: title, type: LabelType.HeaderNew),
                      SizedBox(height: 10),
                      Label(text: description, type: LabelType.HintNew),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Icon(Icons.close_sharp),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            if (child != null) Padding(padding: EdgeInsets.only(top: spaceSize), child: child),
            SizedBox(height: spaceSize),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColoredButton(
                  enabled: leftButtonParams.isEnabled,
                  onPressed: () {
                    Navigator.pop(context);
                    leftButtonParams.onPressed?.call();
                  },
                  buttonStyle: ColoredButtonStyle.Green,
                  child: Text(leftButtonParams.text),
                ),
                SizedBox(width: 20),
                ColoredButton(
                  enabled: rightButtonParams.isEnabled,
                  onPressed: () {
                    Navigator.pop(context);
                    rightButtonParams.onPressed?.call();
                  },
                  buttonStyle: ColoredButtonStyle.Green,
                  isTransparent: true,
                  child: Text(rightButtonParams.text),
                ),
              ],
            ),
          ],
        ),
      );
}

class ActionConfirmDialog extends StatelessWidget {
  const ActionConfirmDialog({
    Key? key,
    required this.title,
    required this.description,
    this.image,
    required this.leftButtonText,
    required this.leftButtonCallback,
    required this.rightButtonText,
    this.rightButtonCallback,
    required this.backgroundColor,
    required this.borderColor,
    required this.leftButtonStyle,
  });

  final String title;
  final String description;
  final ImageIcon? image;

  final Color backgroundColor;
  final Color borderColor;
  final ColoredButtonStyle leftButtonStyle;

  final String rightButtonText;
  final void Function()? rightButtonCallback;

  final String leftButtonText;
  final void Function() leftButtonCallback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      icon: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            iconSize: 20,
            padding: EdgeInsets.zero,
            splashRadius: 20,
            icon: Icon(Icons.close_sharp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Align(child: image),
      ]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: borderColor, width: 2),
      ),
      title: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480),
        child: Column(
          children: [
            Label(
              text: title,
              type: LabelType.NewHeader3,
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Label(
              text: description,
              type: LabelType.HintNew,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: EdgeInsets.only(bottom: 30, top: 20, right: 46, left: 46),
      actionsOverflowButtonSpacing: 16,
      actions: [
        ColoredButton(
          onPressed: () {
            Navigator.pop(context);
            leftButtonCallback();
          },
          buttonStyle: leftButtonStyle,
          child: Label(
            text: leftButtonText,
            type: LabelType.NewLargeTextStyle,
            color: VersionTwoColorScheme.White,
          ),
        ),
        TransparentButton(
          onPressed: () {
            Navigator.pop(context);
            rightButtonCallback?.call();
          },
          borderColor: VersionTwoColorScheme.Black,
          borderWidth: 0.5,
          child: Label(
            text: rightButtonText,
            type: LabelType.NewLargeTextStyle,
          ),
        ),
      ],
    );
  }
}
