import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/bank_accounts_and_statistics/bank_accounts_and_statistics_events.dart';
import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SplitTransactionPopup extends StatefulWidget {
  final TransactionModel transaction;
  final Map<String, List<String>> parentIdMap;
  final Function(SplitTransactionEvent event) onConfirm;

  const SplitTransactionPopup(
      {Key? key,
      required this.transaction,
      required this.parentIdMap,
      required this.onConfirm})
      : super(key: key);

  @override
  State<SplitTransactionPopup> createState() => _SplitTransactionPopupState();
}

class _SplitTransactionPopupState extends State<SplitTransactionPopup> {
  var enableMainButton = false;
  var notMemorize = false;
  String? parentId1;
  String? childId1;
  String? parentId2;
  String? childId2;
  var childKeys1 = <String>[];
  var childKeys2 = <String>[];
  double? amount;
  double? amountRest;
  var amountFocusNode = FocusNode();
  String? amountL;

  bool shouldUpdate = false;

  @override
  void initState() {
    var format = NumberFormat.decimalPattern();
    amountFocusNode.addListener(() {
      shouldUpdate = true;
      if (amount != null) {
        if (!amountFocusNode.hasFocus) {
          amountL = format.format(amount!);
        }
      } else {
        amountL = '';
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    amountRest = _findAmountRest(amount, widget.transaction);
    _evaluateEnabled();
    return TwoButtonsDialog(context,
        title: AppLocalizations.of(context)!.howWouldYouLikeToSplitTheAmount,
        height: 400,
        width: 800,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        bodyWidget: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Label(
                      text: AppLocalizations.of(context)!.enterFirstAmount,
                      type: LabelType.General),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InputItem(
                      value: amountL,
                      focusNode: amountFocusNode,
                      onValueUpdate: onInputItemUpdate,
                      textInputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'\d*\.?')),
                        LengthLimitingTextInputFormatter(15),
                        if (amountFocusNode.hasFocus)
                          DecimalTextInputFormatter(),
                      ],
                      errorText: amount != null && amountRest == null
                          ? AppLocalizations.of(context)!
                              .enteredValueIsMoreThanOriginalTransactionAmount
                          : null,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          amount = double.parse(value.replaceAll(',', ''));
                          amountL = amount.toString();
                        } else {
                          amount = null;
                          amountRest = null;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownItem<String>(
                        items: [
                          for (var item in widget.parentIdMap.keys.toList())
                            item.nameLocalization(context)
                        ],
                        itemKeys: widget.parentIdMap.keys.toList(),
                        hintText: AppLocalizations.of(context)!.select,
                        callback: (value) {
                          if (parentId1 != value) {
                            childId1 = null;
                          }
                          parentId1 = value;
                          childKeys1 = widget.parentIdMap[value]!;
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DropdownItem<String>(
                          key: Key(childKeys1.toString()),
                          items: [
                            for (var item in childKeys1)
                              item.nameLocalization(context)
                          ],
                          itemKeys: childKeys1,
                          hintText: AppLocalizations.of(context)!.select,
                          callback: (value) {
                            childId1 = value;
                            setState(() {});
                          })
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CustomDivider(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Label(
                      text: AppLocalizations.of(context)!.remainingAmount,
                      type: LabelType.General),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Label(
                        text: amountRest != null
                            ? amountRest!.toStringAsFixed(2)
                            : '',
                        type: LabelType.GeneralBold),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownItem<String>(
                        items: [
                          for (var item in widget.parentIdMap.keys.toList())
                            item.nameLocalization(context)
                        ],
                        itemKeys: widget.parentIdMap.keys.toList(),
                        hintText: AppLocalizations.of(context)!.select,
                        callback: (value) {
                          if (parentId2 != value) {
                            childId2 = null;
                          }
                          parentId2 = value;
                          childKeys2 = widget.parentIdMap[value]!;
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DropdownItem<String>(
                          key: Key(childKeys2.toString()),
                          items: [
                            for (var item in childKeys2)
                              item.nameLocalization(context)
                          ],
                          itemKeys: childKeys2,
                          hintText: AppLocalizations.of(context)!.select,
                          callback: (value) {
                            childId2 = value;
                            setState(() {});
                          })
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomMaterialInkWell(
              type: InkWellType.Purple,
              onTap: () {
                notMemorize = !notMemorize;
                setState(() {});
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    splashRadius: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    value: notMemorize,
                    onChanged: (bool? value) {
                      if (value != null) {
                        notMemorize = value;
                      }
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Label(
                        text: AppLocalizations.of(context)!
                            .donTRememberThisTransactionSplitting,
                        type: LabelType.General),
                  ),
                ],
              ),
            ),
          ],
        ),
        mainButtonText: AppLocalizations.of(context)!.confirm,
        enableMainButton: enableMainButton,
        dismissButtonText: AppLocalizations.of(context)!.cancel,
        onMainButtonPressed: () {
      var amountModifier = widget.transaction.amount > 0 ? 1 : -1;
      widget.onConfirm(
        SplitTransactionEvent(
            transactionIdToSplit: widget.transaction.id,
            childsOfSplit: [
              SplitChildRequestModel(
                  amount: amountModifier * amount!, categoryId: childId1!),
              SplitChildRequestModel(
                  amount: amountModifier * amountRest!, categoryId: childId2!),
            ],
            shouldBeRemembered: !notMemorize),
      );
    });
  }

  void _evaluateEnabled() {
    enableMainButton = (amount != null &&
        amountRest != null &&
        childId1 != null &&
        childId2 != null);
  }

  double? _findAmountRest(double? amount, TransactionModel transaction) {
    var transactionAmount =
        transaction.amount > 0 ? transaction.amount : -transaction.amount;
    if (amount == null) {
      return double.parse((transactionAmount).toStringAsFixed(2));
    } else if (amount >= transactionAmount) {
      return null;
    } else {
      return double.parse((transactionAmount - amount).toStringAsFixed(2));
    }
  }

  String? onInputItemUpdate() {
    if (shouldUpdate) {
      shouldUpdate = false;
      return amountL;
    }
  }
}
