import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LostConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Label(
          text: AppLocalizations.of(context)!.noConnectionPleaseTryAgainLater,
          type: LabelType.Header,
          color: Theme.of(context).colorScheme.primary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
