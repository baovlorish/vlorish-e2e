import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoTransactionHereWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label(
              type: LabelType.HintLargeBold,
              text: AppLocalizations.of(context)!.noTransactionHereYet,
              color: CustomColorScheme.inputBorder,
            ),
            SizedBox(
              height: 20,
            ),
            Label(
              type: LabelType.General,
              text: AppLocalizations.of(context)!
                  .thisSectionWillDisplayYourTransaction,
              color: CustomColorScheme.inputBorder,
            ),
          ],
        ),
      ),
    );
  }
}
