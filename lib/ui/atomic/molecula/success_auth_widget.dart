import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessAuthWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String message;
  final String? buttonText;

  const SuccessAuthWidget(
      {Key? key,
      required this.onPressed,
      required this.message,
      this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ColumnItem(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icons/success.png',
            height: 80,
            width: 106,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Label(
              text: AppLocalizations.of(context)!.success,
              type: LabelType.HeaderBold,
            ),
          ),
          Label(
            text: message,
            type: LabelType.General,
          ),
          SizedBox(
            height: 40,
          ),
          ButtonItem(
            context,
            buttonType: ButtonType.LargeText,
            text: buttonText ?? AppLocalizations.of(context)!.next,
            onPressed: onPressed,
          ),
        ],
      );
}
