import 'package:burgundy_budgeting_app/ui/atomic/atom/page_selector_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_bloc.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionTablePageSelector extends StatelessWidget {
  final int numberOfPages;
  final int selectedPage;

  TransactionTablePageSelector(this.numberOfPages, this.selectedPage);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= numberOfPages; i++)
                PageSelectorItem(
                  number: i,
                  isSelected: i == selectedPage,
                  callback: (int newSelectedPage) {
                    BlocProvider.of<BankAccountsAndStatisticsBloc>(context).add(
                      TransactionPageChanged(newSelectedPage),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
