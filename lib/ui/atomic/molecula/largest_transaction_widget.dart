import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/model/largest_transaction_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/cupertino.dart';

class LargestTransactionWidget extends StatelessWidget {
  final LargestTransactionModel transaction;
  final int number;
  final bool isCollapsed;

  const LargestTransactionWidget({
    required this.transaction,
    required this.number,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isCollapsed
            ? [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Label(
                            overflow: TextOverflow.ellipsis,
                            text: transaction.merchantName
                                .replaceAll(' ', '\u00a0'),
                            type: LabelType.Hint,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Label(
                      text:
                          '\$${transaction.amount.truncate().numericFormattedString()}',
                      type: LabelType.LabelBoldPink,
                    ),
                    SizedBox(width: 24),
                  ],
                ),
              ]
            : [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Label(
                          text: transaction.merchantName
                              .replaceAll(' ', '\u00a0'),
                          type: LabelType.Hint,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Label(
                  text:
                      '\$${transaction.amount.truncate().numericFormattedString()}',
                  type: LabelType.LabelBoldPink,
                )
              ],
      ),
    );
  }
}
