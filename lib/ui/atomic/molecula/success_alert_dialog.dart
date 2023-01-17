import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessAlertDialog extends AlertDialog {
  SuccessAlertDialog(
    BuildContext context, {
    String? title,
    String? message,
    String? buttonText,
    void Function()? onButtonPress,
  }) : super(
          content: _SuccessAlertDialogContent(
            context,
            title,
            message,
            buttonText,
            onButtonPress,
          ),
        );
}

class _SuccessAlertDialogContent extends StatefulWidget {
  final String? title;
  final String? message;
  final String? buttonText;
  final void Function()? onButtonPress;

  _SuccessAlertDialogContent(
    BuildContext context,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonPress,
  );

  @override
  State<_SuccessAlertDialogContent> createState() =>
      _SuccessAlertDialogContentState();
}

class _SuccessAlertDialogContentState
    extends State<_SuccessAlertDialogContent> {
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
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: CustomColorScheme.close,
              ),
            ),
          ),
          Image.asset(
            'assets/images/icons/success.png',
            height: 80,
            width: 106,
          ),
          Label(
            text: widget.title ?? (AppLocalizations.of(context)!.success),
            type: LabelType.HeaderBold,
          ),
          if (widget.message != null)
            Label(
              text: widget.message!,
              type: LabelType.General,
            ),
          Center(
            child: InkWell(
              focusNode: focusNode,
              onTap: widget.onButtonPress ?? () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                decoration: BoxDecoration(
                  color: CustomColorScheme.successPopupButton,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Label(
                  text: widget.buttonText ??
                      AppLocalizations.of(context)!.continueWord,
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
