import 'package:burgundy_budgeting_app/ui/model/largest_transaction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'largest_transaction_widget.dart';

class LargestTransactions extends StatelessWidget {
  final List<LargestTransactionModel> transactions;
  final bool moveOnTop;

  LargestTransactions({required this.transactions, required this.moveOnTop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: moveOnTop ? Axis.horizontal : Axis.vertical,
          children: moveOnTop
              ? _mapToRow(transactions, numberOfItemsInRow: 10)
              : [
                  for (int i = 0; i < transactions.length; i++)
                    LargestTransactionWidget(
                      transaction: transactions[i],
                      number: i + 1,
                      isCollapsed: moveOnTop,
                    )
                ]),
    );
  }

  List<Widget> _mapToRow(
    List<LargestTransactionModel> transactions, {
    required int numberOfItemsInRow,
  }) {
    var widgets = <LargestTransactionWidget>[];
    var adaptiveRows = <Widget>[];

    for (var i = 0; i < transactions.length; i++) {
      widgets.add(LargestTransactionWidget(
        transaction: transactions[i],
        number: i + 1,
        isCollapsed: moveOnTop,
      ));
    }

    for (var i = 0;
        i < transactions.length - transactions.length % numberOfItemsInRow;
        i += numberOfItemsInRow) {
      adaptiveRows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets.sublist(i, i + numberOfItemsInRow),
        ),
      );
    }

    adaptiveRows.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets.sublist(
          transactions.length - transactions.length % numberOfItemsInRow,
          transactions.length,
        ),
      ),
    );

    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: adaptiveRows,
      )
    ];
  }
}
