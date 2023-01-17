import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClearAllFiltersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LabelButtonItem(
      label: Label(
        text: AppLocalizations.of(context)!.clearAllFilters,
        type: LabelType.LabelBoldPink,
      ),
      onPressed: () {
        BlocProvider.of<BankAccountsAndStatisticsBloc>(context).add(
          ClearAllFiltersEvent(),
        );
      },
    );
  }
}
