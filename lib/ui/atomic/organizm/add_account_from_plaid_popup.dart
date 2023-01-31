import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/networth_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/add_account_from_plaid_popup_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/add_account_popup/add_account_popup_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/add_account_popup/add_account_popup_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAccountFromPlaidPopup extends AlertDialog {
  final bool showCancelOption;
  final bool showItemsValidation;
  final bool browserBackButtonDismissible;
  final bool isStandardSubscription;
  final VoidCallback? onCancel;
  final List<String> businessNameList;

  AddAccountFromPlaidPopup({
    this.showCancelOption = false,
    this.showItemsValidation = true,
    this.browserBackButtonDismissible = true,
    this.isStandardSubscription = false,
    required List<BankAccount> bankAccounts,
    required this.businessNameList,
    required AccountsTransactionsRepository plaidRepository,
    required NetWorthRepository netWorthRepository,
    required Function() onSuccessCallback,
    this.onCancel,
  }) : super(
          content: WillPopScope(
            onWillPop: () async => browserBackButtonDismissible,
            child: BlocProvider<AddAccountPopupCubit>(
              create: (_) =>
                  AddAccountPopupCubit(plaidRepository, netWorthRepository),
              child: Container(
                width: 600,
                height: 800,
                child: BlocConsumer<AddAccountPopupCubit, AddAccountPopupState>(
                    listener: (context, state) {
                  if (state is AddAccountPopupGeneralErrorState) {
                    showDialog(
                      context: context,
                      builder: (_context) {
                        return ErrorAlertDialog(
                          _context,
                          message: state.errorMessage,
                        );
                      },
                    );
                  }
                }, builder: (_context, state) {
                  return _InnerContent(
                    showCancelOption: showCancelOption,
                    onCancel: onCancel,
                    bankAccounts: bankAccounts,
                    businessNameList: businessNameList,
                    showValidation: showItemsValidation,
                    state: state,
                    onSuccessCallback: onSuccessCallback,
                    showUsingType: !isStandardSubscription,
                  );
                }),
              ),
            ),
          ),
        );
}

class _InnerContent extends StatefulWidget {
  final List<BankAccount> bankAccounts;
  final AddAccountPopupState state;
  final bool showValidation;
  final bool showUsingType;
  final bool showCancelOption;
  final VoidCallback? onCancel;
  final List<String> businessNameList;
  final Function() onSuccessCallback;

  _InnerContent({
    required this.showCancelOption,
    required this.showValidation,
    required this.showUsingType,
    required this.bankAccounts,
    required this.state,
    required this.onSuccessCallback,
    this.onCancel,
    required this.businessNameList,
  });

  @override
  __InnerContentState createState() => __InnerContentState();
}

class __InnerContentState extends State<_InnerContent> {
  final _items = <AddAccountFromPlaidPopupItem>[];
  List<AddPlaidAccountError>? errors;
  late final addAccountPopupCubit =
      BlocProvider.of<AddAccountPopupCubit>(context);

  @override
  Widget build(BuildContext context) {
    if (widget.state is AddAccountPopupAccountErrorState) {
      errors = (widget.state as AddAccountPopupAccountErrorState).errors;
    } else {
      errors = [];
    }

    _items.clear();
    for (var i in widget.bankAccounts) {
      _items.add(
        AddAccountFromPlaidPopupItem(
          bankAccount: i,
          key: Key(i.id),
          showValidIndicator: widget.showValidation,
          showDivider: widget.bankAccounts.last != i,
          businessNameList: widget.businessNameList,
          onValid: (BankAccount account) {
            addAccountPopupCubit.validateAccount(account, widget.bankAccounts);
          },
          error: errors?.firstWhereOrNull((element) => element.id == i.id),
          onNotValid: (BankAccount account) {
            addAccountPopupCubit.unvalidateAccount(
                account, widget.bankAccounts);
          },
          showUsageType: widget.showUsingType,
        ),
      );
    }

    return Column(
      key: widget.key,
      children: [
        Center(
          child: Label(
            type: LabelType.Header3,
            text: AppLocalizations.of(context)!.addAccount,
          ),
        ),
        SizedBox(height: 23),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: _items,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 40,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.showCancelOption)
                LabelButtonItem(
                  label: Label(
                    text:
                        AppLocalizations.of(context)!.skipAllAndConfigureLater,
                    type: LabelType.Button,
                    color: CustomColorScheme.text,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.onCancel != null) {
                      widget.onCancel!();
                    }
                  },
                ),
              if (widget.showCancelOption)
                SizedBox(
                  width: 70,
                ),
              Expanded(
                key: UniqueKey(),
                child: ButtonItem(
                  context,
                  text: AppLocalizations.of(context)!.addAccount,
                  buttonType: ButtonType.LargeText,
                  enabled: (widget.state is AddAccountPopupValidateState)
                      ? (widget.state as AddAccountPopupValidateState).isValid
                      : false,
                  onPressed: () async {
                    if ((widget.state is AddAccountPopupValidateState)
                        ? (widget.state as AddAccountPopupValidateState).isValid
                        : false) {
                      errors = await addAccountPopupCubit
                          .sendPlaidAccountsDataToBacked(
                              onSuccessCallback: () {
                                // FixMe: fix issue with "Looking up a deactivated widget's ancestor is unsafe" error when pressing button multiple times
                                Navigator.pop(context);
                                widget.onSuccessCallback();
                              },
                              isExistingAccounts:
                                  widget.bankAccounts.first.usageType != 0);
                      if (errors != null && errors!.isNotEmpty) {
                        addAccountPopupCubit
                            .unvalidateAccountsWithErrors(errors!);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
