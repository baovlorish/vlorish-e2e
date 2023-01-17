import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/custom_switch.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/list_of_transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionTableHeader extends StatelessWidget with FlexFactors {
  final bool isUnbudgeted;

  const TransactionTableHeader({
    Key? key,
    required this.isUnbudgeted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bankAccountsAndStatisticsBloc =
        BlocProvider.of<BankAccountsAndStatisticsBloc>(context);
    return Row(
      children: [
        SizedBox(
          width: 30,
        ),
        Expanded(
          flex: listOfFlexFactors[0],
          child: Label(
            text: AppLocalizations.of(context)!.date,
            type: LabelType.TableHeader,
            color: CustomColorScheme.tableHeaderText,
          ),
        ),
        Expanded(
            flex: listOfFlexFactors[1],
            child: Label(
              text: AppLocalizations.of(context)!.name,
              type: LabelType.TableHeader,
              color: CustomColorScheme.tableHeaderText,
            )),
        Expanded(
            flex: listOfFlexFactors[2],
            child: Label(
              text: AppLocalizations.of(context)!.amount,
              type: LabelType.TableHeader,
              color: CustomColorScheme.tableHeaderText,
            )),
        Expanded(
            flex: listOfFlexFactors[3],
            child: Label(
              text: AppLocalizations.of(context)!.account,
              type: LabelType.TableHeader,
              color: CustomColorScheme.tableHeaderText,
            )),
        Expanded(
          flex: listOfFlexFactors[4],
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Label(
                softWrap: false,
                text: AppLocalizations.of(context)!.category,
                type: LabelType.TableHeader,
                color: CustomColorScheme.tableHeaderText,
              ),
              CustomSwitch(
                key: Key(isUnbudgeted.toString()),
                variable: isUnbudgeted,
                text: AppLocalizations.of(context)!.unbudgeted,
                callback: (value) {
                  bankAccountsAndStatisticsBloc.add(
                    ToggleUnbudgetedEvent(value),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
