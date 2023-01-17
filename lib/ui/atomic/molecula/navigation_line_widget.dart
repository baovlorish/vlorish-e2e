import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationLine extends StatelessWidget {
  const NavigationLine({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.callback,
  }) : super(key: key);

  final String? firstName;
  final String? lastName;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(color: CustomColorScheme.navigatorLine),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.info, color: Colors.blue),
          ),
          Flexible(
            child: RichText(
              text: TextSpan(
                style: CustomTextStyle.LabelTextStyle(context),
                text: AppLocalizations.of(context)!.currentlyYouAreOn,
                children: <TextSpan>[
                  TextSpan(
                      text: ' ${firstName ?? ''} ${lastName ?? ''}',
                      style: CustomTextStyle.LabelBoldTextStyle(context)),
                  TextSpan(
                    text: AppLocalizations.of(context)!.budgetYouCan,
                    style: CustomTextStyle.LabelTextStyle(context),
                  ),
                  TextSpan(
                      text: AppLocalizations.of(context)!.returnToOwnBudget,
                      style: CustomTextStyle.LinkTextStyle(context)
                          .copyWith(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          callback();
                        }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
