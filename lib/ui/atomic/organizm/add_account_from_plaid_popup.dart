import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/networth_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/add_account_from_plaid_popup_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/add_account_popup/add_account_popup_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/add_account_popup/add_account_popup_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAccountFromPlaidPopup extends StatelessWidget {
  final bool showCancelOption;
  final bool showItemsValidation;
  final bool browserBackButtonDismissible;
  final bool isStandardSubscription;
  final VoidCallback? onCancel;
  final List<String> businessNameList;

  final List<BankAccount> bankAccounts;
  final AccountsTransactionsRepository plaidRepository;
  final NetWorthRepository netWorthRepository;

  final VoidCallback onSuccessCallback;

  const AddAccountFromPlaidPopup({
    required this.bankAccounts,
    required this.businessNameList,
    required this.plaidRepository,
    required this.netWorthRepository,
    required this.onSuccessCallback,
    this.showCancelOption = false,
    this.showItemsValidation = true,
    this.browserBackButtonDismissible = true,
    this.isStandardSubscription = false,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => browserBackButtonDismissible,
        child: BlocProvider<AddAccountPopupCubit>(
          create: (_) => AddAccountPopupCubit(plaidRepository, netWorthRepository),
          child: _InnerContent(
            showCancelOption: showCancelOption,
            onCancel: onCancel,
            bankAccounts: bankAccounts,
            businessNameList: businessNameList,
            showValidation: showItemsValidation,
            onSuccessCallback: onSuccessCallback,
            showUsingType: !isStandardSubscription,
          ),
        ),
      );
}

class _InnerContent extends StatefulWidget {
  final List<BankAccount> bankAccounts;
  final bool showValidation;
  final bool showUsingType;
  final bool showCancelOption;
  final VoidCallback? onCancel;
  final List<String> businessNameList;
  final Function() onSuccessCallback;

  const _InnerContent({
    required this.showCancelOption,
    required this.showValidation,
    required this.showUsingType,
    required this.bankAccounts,
    required this.onSuccessCallback,
    required this.businessNameList,
    this.onCancel,
  });

  @override
  __InnerContentState createState() => __InnerContentState();
}

class __InnerContentState extends State<_InnerContent> {
  final constraints = BoxConstraints(maxWidth: 600);

  final itemsListViewConstraints = BoxConstraints(maxHeight: 400);

  static const spacerPadding = EdgeInsets.only(bottom: 30.0);

  @override
  void initState() {
    super.initState();

    final len = widget.bankAccounts.length;
    items = [
      for (var i = 0; i < len; i++)
        Padding(
          padding: widget.bankAccounts[i].id != widget.bankAccounts.last.id ? spacerPadding : EdgeInsets.zero,
          child: AddAccountFromPlaidPopupItem(
            number: i + 1,
            bankAccount: widget.bankAccounts[i],
            key: Key(widget.bankAccounts[i].id),
            showValidIndicator: widget.showValidation,
            businessNameList: widget.businessNameList,
            onValid: (account) => addAccountPopupCubit.validateAccount(account, widget.bankAccounts),
            error: errors?.firstWhereOrNull((element) => element.id == widget.bankAccounts[i].id),
            onNotValid: (account) => addAccountPopupCubit.unvalidateAccount(account, widget.bankAccounts),
            showUsageType: widget.showUsingType,
          ),
        ),
    ];
  }

  late final List<Widget> items;
  List<AddPlaidAccountError>? errors;
  late final addAccountPopupCubit = BlocProvider.of<AddAccountPopupCubit>(context);

  @override
  Widget build(BuildContext context) => BlocConsumer<AddAccountPopupCubit, AddAccountPopupState>(
        listener: (context, state) {
          errors = state is! AddAccountPopupAccountErrorState ? [] : state.errors;
          if (state is AddAccountPopupGeneralErrorState) {
            showDialog(
              context: context,
              builder: (_context) => ErrorAlertDialog(_context, message: state.errorMessage),
            );
          }
        },
        builder: (context, state) => ConstrainedBox(
          constraints: constraints,
          child: TwoButtonDialogNew(
            title: AppLocalizations.of(context)!.linkAccounts,
            description: AppLocalizations.of(context)!.setUpYourNewBrokerageAccountRetirementAccountOrPersonalAsset,
            leftButtonParams: ButtonParams(
              AppLocalizations.of(context)!.addAccount,
              isEnabled: state is AddAccountPopupValidateState ? state.isValid : false,
              onPressed: () async {
                errors = await addAccountPopupCubit.sendPlaidAccountsDataToBacked(
                  isExistingAccounts: widget.bankAccounts.first.usageType != 0,
                  onSuccessCallback: widget.onSuccessCallback,
                );
                if (errors?.isNotEmpty ?? false) addAccountPopupCubit.unvalidateAccountsWithErrors(errors!);
              },
            ),
            rightButtonParams: ButtonParams(
              AppLocalizations.of(context)!.cancel,
              onPressed: widget.onCancel?.call,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ConstrainedBox(
                constraints: itemsListViewConstraints,
                child: SingleChildScrollView(
                  child: Column(
                    children: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
