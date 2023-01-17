import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorAlertDialog extends AlertDialog {
  ErrorAlertDialog(
    BuildContext context, {
    String? title,
    String? message,
    String? buttonText,
    void Function()? onButtonPress,
    bool showCloseButton = true,
  }) : super(
          content: _ErrorAlertDialogContent(
            context,
            title,
            message,
            buttonText,
            onButtonPress,
            showCloseButton,
          ),
        );
}

class _ErrorAlertDialogContent extends StatefulWidget {
  final String? title;
  final String? message;
  final String? buttonText;
  final void Function()? onButtonPress;
  final bool showCloseButton;

  _ErrorAlertDialogContent(
    BuildContext context,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPress,
    this.showCloseButton,
  );

  @override
  State<_ErrorAlertDialogContent> createState() =>
      _ErrorAlertDialogContentState();
}

class _ErrorAlertDialogContentState extends State<_ErrorAlertDialogContent> {
  final focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.showCloseButton
              ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: CustomColorScheme.close,
                    ),
                  ),
                )
              : SizedBox(height: 30),
          Image.asset(
            'assets/images/icons/error.png',
            height: 80,
            width: 80,
          ),
          Label(
            text: widget.title ?? (AppLocalizations.of(context)!.error),
            type: LabelType.Header2,
          ),
          Label(
            text: widget.message ??
                AppLocalizations.of(context)!.somethingWentWrong,
            type: LabelType.General,
          ),
          Center(
            child: CustomMaterialInkWell(
              type: InkWellType.White,
              borderRadius: BorderRadius.circular(5),
              materialColor: CustomColorScheme.errorPopupButton,
              focusNode: focusNode,
              onTap: () {
                Navigator.pop(context);
                if (widget.onButtonPress != null) widget.onButtonPress!();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                child: Label(
                  text: widget.buttonText ??
                      AppLocalizations.of(context)!.tryAgain,
                  color: Colors.white,
                  type: LabelType.LargeButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
