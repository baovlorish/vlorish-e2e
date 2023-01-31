import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'button_item.dart';
import 'label_button_item.dart';

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
                                  text: dismissButtonText ??
                                      AppLocalizations.of(context)!.no,
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
