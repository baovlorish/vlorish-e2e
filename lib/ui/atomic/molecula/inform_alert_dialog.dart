import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformAlertDialog extends AlertDialog {
  InformAlertDialog(
    BuildContext context, {
    required String title,
    String? text,
    String? buttonText,
    IconData? icon,
    void Function()? onButtonPress,
  }) : super(
          contentPadding: EdgeInsets.all(20),
          content: _InformAlertDialogContent(
            context,
            title,
            text,
            buttonText,
            onButtonPress,
            icon,
          ),
        );
}

class _InformAlertDialogContent extends StatefulWidget {
  final String title;
  final String? text;
  final String? buttonText;
  final void Function()? onButtonPress;
  final IconData? icon;

  _InformAlertDialogContent(
    BuildContext context,
    this.title,
    this.text,
    this.buttonText,
    this.onButtonPress,
    this.icon,
  );

  @override
  State<_InformAlertDialogContent> createState() =>
      _InformAlertDialogContentState();
}

class _InformAlertDialogContentState extends State<_InformAlertDialogContent> {
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
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          if (widget.icon != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Icon(
                widget.icon,
                size: 80,
                color: CustomColorScheme.taxInfoTooltip,
              ),
            ),
          SizedBox(
            height: 12,
          ),
          Label(
            text: widget.title,
            type: LabelType.Header2,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Label(
              text: widget.text ?? '',
              type: LabelType.General,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: SizedBox(
              width: 250,
              child: ButtonItem(
                context,
                focusNode: focusNode,
                text: widget.buttonText ??
                    AppLocalizations.of(context)!.ok.toUpperCase(),
                buttonType: ButtonType.LargeText,
                onPressed: () {
                  if (widget.onButtonPress == null) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    widget.onButtonPress!();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
