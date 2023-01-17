import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoCardsHereWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/credit_card.png',
            height: 100,
          ),
          SizedBox(
            height: 30,
          ),
          Label(
            type: LabelType.HintLargeBold,
            text: AppLocalizations.of(context)!.noCardsHereYet,
            color: CustomColorScheme.inputBorder,
          ),
          SizedBox(
            height: 20,
          ),
          Label(
            type: LabelType.General,
            text: AppLocalizations.of(context)!
                .thisSectionWillDisplayYourBankAccounts,
            color: CustomColorScheme.inputBorder,
          ),
        ],
      ),
    );
  }
}
