import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UniteTransactionPopup extends StatefulWidget {
  final TransactionModel originalTransaction;
  final Function(String id) onConfirm;

  const UniteTransactionPopup(
      {Key? key, required this.originalTransaction, required this.onConfirm})
      : super(key: key);

  @override
  State<UniteTransactionPopup> createState() => _UniteTransactionPopupState();
}

class _UniteTransactionPopupState extends State<UniteTransactionPopup> {
  @override
  Widget build(BuildContext context) {
    return TwoButtonsDialog(context,
        title: AppLocalizations.of(context)!
            .combineSplitTransactionsToTheOriginalTransaction,
        height: 400,
        width: 800,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        bodyWidget: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDivider(),
            for (var item in widget.originalTransaction.splitChildren!)
              _TransactionItem(
                  item, widget.originalTransaction.bankAccountName),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Label(
                  text: AppLocalizations.of(context)!.original,
                  type: LabelType.LargeButton),
            ),
            CustomDivider(),
            _TransactionItem(
              widget.originalTransaction,
              widget.originalTransaction.bankAccountName,
            ),
          ],
        ),
        mainButtonText: AppLocalizations.of(context)!.confirm,
        dismissButtonText: AppLocalizations.of(context)!.cancel,
        onMainButtonPressed: () {
      widget.onConfirm(widget.originalTransaction.id);
    });
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionModel item;
  final String bankAccountName;

  const _TransactionItem(this.item, this.bankAccountName, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var amountColor = item.amount > 0
        ? CustomColorScheme.successPopupButton
        : CustomColorScheme.negativeTransaction;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Label(
                    text: CustomDateFormats.defaultDateFormat
                        .format(item.creationTimeUtc),
                    type: LabelType.General),
              ),
              Expanded(
                flex: 2,
                child: Label(
                  text: item.merchantName,
                  type: LabelType.Ellipsis,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Label(
                  text: item.amount.toStringAsFixed(2),
                  type: LabelType.GeneralBold,
                  color: amountColor,
                ),
              ),
              Expanded(
                  child: Label(text: bankAccountName, type: LabelType.General)),
              Expanded(
                flex: 2,
                child: Label(
                    text: (item.parentCategoryId != null
                            ? '${item.parentCategoryId?.nameLocalization(context)} / '
                            : '') +
                        (item.categoryId?.nameLocalization(context) ?? ''),
                    type: LabelType.General),
              ),
            ],
          ),
        ),
        CustomDivider(),
      ],
    );
  }
}
