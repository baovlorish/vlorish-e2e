import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_radio_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/city_field_with_suggestion.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAccountFromPlaidPopupItem extends StatefulWidget {
  final BankAccount bankAccount;
  final void Function(BankAccount account) onValid;
  final void Function(BankAccount account) onNotValid;
  final bool showValidIndicator;
  final bool showDivider;
  final bool showUsageType;
  final AddPlaidAccountError? error;
  final List<String> businessNameList;

  AddAccountFromPlaidPopupItem({
    Key? key,
    required this.bankAccount,
    required this.onValid,
    required this.onNotValid,
    required this.showValidIndicator,
    this.showDivider = true,
    this.error,
    this.showUsageType = false,
    required this.businessNameList,
  }) : super(key: key);

  @override
  _AddAccountFromPlaidPopupItemState createState() =>
      _AddAccountFromPlaidPopupItemState();
}

class _AddAccountFromPlaidPopupItemState
    extends State<AddAccountFromPlaidPopupItem> {
  late String _createAccountNameValue = widget.bankAccount.externalName ?? '';
  int _usageType = 0;
  int _dataAcquisitionStart = 0;
  int _chosenAccountType = 0;
  String? businessName;
  late final List<String> _personalAccountTypes;
  late final List<String> _businessAccountTypes;
  late AddPlaidAccountError? _error;

  final _focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isMortgageLoanAccountType = false;

  @override
  void didChangeDependencies() {
    if (mounted) {
      super.didChangeDependencies();
      _personalAccountTypes = [
        AppLocalizations.of(context)!.bankAccount,
        AppLocalizations.of(context)!.creditCard,
        AppLocalizations.of(context)!.studentLoan,
        AppLocalizations.of(context)!.investment,
        AppLocalizations.of(context)!.mortgageLoan,
        AppLocalizations.of(context)!.retirementAccount,
      ];
      _businessAccountTypes = [
        AppLocalizations.of(context)!.bankAccount,
        AppLocalizations.of(context)!.creditCard,
        AppLocalizations.of(context)!.businessAssets,
      ];
    }
  }

  bool get isValid {
    final formIsValid =
        formKey.currentState != null && formKey.currentState!.validate();
    final usageTypeSelected = _usageType != 0;
    final isPersonalSelected = _usageType == 1;
    if (_error != null) {
      return false;
    } else if (isPersonalSelected && _createAccountNameValue.isNotEmpty) {
      return true;
    } else if (formIsValid &&
        _createAccountNameValue.isNotEmpty &&
        usageTypeSelected &&
        (businessName != null || isPersonalSelected)) {
      return true;
    }
    return false;
  }

  void copyWithActualProperties({required bool callIsValid}) {
    if (callIsValid) {
      widget.onValid(
        widget.bankAccount.copyWith(
            usageType: _usageType,
            type: _chosenAccountType,
            dataAcquisitionStart: _dataAcquisitionStart,
            name: _createAccountNameValue,
            businessName: businessName),
      );
    } else {
      widget.onNotValid(widget.bankAccount.copyWith(
        usageType: _usageType,
        type: _chosenAccountType,
        dataAcquisitionStart: _dataAcquisitionStart,
        name: _createAccountNameValue,
        businessName: businessName,
      ));
    }
  }

  @override
  void initState() {
    _error = widget.error;

    if (widget.bankAccount.externalName != null) {
      _createAccountNameValue = widget.bankAccount.externalName!;
      copyWithActualProperties(callIsValid: isValid);
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    _error = widget.error;
    if (!widget.showUsageType) {
      _usageType = 1;
      _chosenAccountType = 0;
      businessName = null;
      copyWithActualProperties(callIsValid: isValid);
    }

    isMortgageLoanAccountType = _personalAccountTypes[_chosenAccountType] ==
        AppLocalizations.of(context)!.mortgageLoan;
    var dropdownErrorText = widget.error?.incorrectType == true
        ? AppLocalizations.of(context)!.addAccountTypeNotAppropriateErrorMessage
        : null;

    if (widget.bankAccount.usageType != 0) {
      _usageType = widget.bankAccount.usageType;
    }
    if (widget.bankAccount.type != 0) {
      if (widget.bankAccount.type == 9) {
        //retirement
        _chosenAccountType = 5;
      } else if (widget.bankAccount.type == 8) {
        //investment
        _chosenAccountType = 3;
      }
    }

    var isInvestment = widget.bankAccount.type != 0;
    return Form(
      key: formKey,
      child: Container(
        color: (isValid && (_error == null) && widget.showValidIndicator)
            ? Colors.greenAccent.withOpacity(0.05)
            : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Label(
                          text: AppLocalizations.of(context)!.accountNum,
                          type: LabelType.General),
                      SizedBox(width: 30),
                      Label(
                          text:
                              '**** **** **** ${widget.bankAccount.lastFourDigits}',
                          type: LabelType.GeneralBold),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Label(
                          text: AppLocalizations.of(context)!.bankName,
                          type: LabelType.General),
                      SizedBox(width: 30),
                      Label(
                          text: widget.bankAccount.bankName,
                          type: LabelType.GeneralBold),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Label(
                          text: AppLocalizations.of(context)!.balance,
                          type: LabelType.General),
                      SizedBox(width: 30),
                      if (widget.bankAccount.currency == 'USD')
                        Label(
                          text: '\$',
                          type: LabelType.GeneralBold,
                        ),
                      Label(
                        text: widget.bankAccount.balance.toString(),
                        type: LabelType.GeneralBold,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  if (widget.showUsageType)
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isInvestment)
                              Label(
                                  text: AppLocalizations.of(context)!
                                      .chooseAccountType,
                                  type: LabelType.General),
                            SizedBox(
                              height: 10,
                            ),
                            if (!isInvestment)
                              Row(
                                children: [
                                  CustomRadioButton(
                                    title:
                                        AppLocalizations.of(context)!.personal,
                                    value: 1,
                                    groupValue: _usageType,
                                    onTap: () => setState(() {
                                      _usageType = 1;
                                      _chosenAccountType = 0;
                                      businessName = null;
                                      _error = null;
                                      copyWithActualProperties(
                                          callIsValid: isValid);
                                    }),
                                  ),
                                  SizedBox(width: 24),
                                  CustomRadioButton(
                                    title:
                                        AppLocalizations.of(context)!.business,
                                    value: 2,
                                    groupValue: _usageType,
                                    onTap: () {
                                      setState(() {
                                        _usageType = 2;
                                        _chosenAccountType = 0;
                                        copyWithActualProperties(
                                            callIsValid: isValid);
                                      });
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((timeStamp) {
                                        formKey.currentState?.validate();
                                      });
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(width: 8),
                        if (_usageType != 2) Spacer(),
                        if (_usageType == 2)
                          Expanded(
                            child: TextFieldWithSuggestion<String>(
                                search: (value) => widget.businessNameList
                                    .where((element) => element.contains(value))
                                    .toList(),
                                hideOnEmpty: true,
                                maxSymbols: 15,
                                onSelectedModel: (value) {
                                  businessName = value;
                                  copyWithActualProperties(
                                      callIsValid: isValid);
                                },
                                errorMessageEmpty: 'Field is required',
                                shouldEraseOnFocus: false,
                                onSaved: (value) {
                                  businessName = value;
                                  copyWithActualProperties(
                                      callIsValid: isValid);
                                },
                                hintText: 'Enter business name',
                                label: 'Business name'),
                          ),
                      ],
                    ),
                  (_usageType == 1)
                      ? DropdownItem<int>(
                          key: Key('personal'),
                          enabled: _usageType != 0 && !isInvestment,
                          labelText:
                              AppLocalizations.of(context)!.chooseCategory,
                          items: _personalAccountTypes,
                          hintText: '',
                          initialValue: isInvestment
                              ? _personalAccountTypes.indexOf(
                                  _personalAccountTypes[_chosenAccountType])
                              : 0,
                          errorText: dropdownErrorText,
                          validateFunction:
                              FormValidators.accountCategoryValidateFunction,
                          callback: (value) {
                            _chosenAccountType = value;
                            copyWithActualProperties(callIsValid: isValid);
                            setState(() {});
                          },
                        )
                      : DropdownItem<int>(
                          key: Key('business'),
                          enabled: _usageType != 0,
                          labelText:
                              AppLocalizations.of(context)!.chooseCategory,
                          items: _businessAccountTypes,
                          hintText: '',
                          initialValue: 0,
                          errorText: dropdownErrorText,
                          validateFunction:
                              FormValidators.accountCategoryValidateFunction,
                          callback: (value) {
                            copyWithActualProperties(callIsValid: isValid);
                            setState(() {});
                          },
                        ),
                  SizedBox(height: 30),
                  if (!isInvestment)
                    DropdownItem<int>(
                      enabled: _usageType != 0 && !isMortgageLoanAccountType,
                      labelText: AppLocalizations.of(context)!
                          .chooseDataAcquisitionPeriod,
                      items: [
                        AppLocalizations.of(context)!.dataOptionOne,
                        AppLocalizations.of(context)!.dataOptionTwo,
                        AppLocalizations.of(context)!.none,
                      ],
                      initialValue:
                          isMortgageLoanAccountType || isInvestment ? 2 : 0,
                      //AquisitionPeriod none if MortgageLoan or investment
                      hintText: '',
                      validateFunction:
                          FormValidators.accountDataPeriodValidateFunction,
                      callback: (value) {
                        _dataAcquisitionStart = value;
                        copyWithActualProperties(callIsValid: isValid);
                      },
                    ),
                  if (!isInvestment) SizedBox(height: 30),
                  InputItem(
                    labelText: AppLocalizations.of(context)!.createAccountName,
                    errorText: _error?.nonUniqueName == true
                        ? AppLocalizations.of(context)!
                            .accountsShouldHaveUniqueNames
                        : null,
                    value: _createAccountNameValue,
                    autovalidateMode: AutovalidateMode.always,
                    validateFunction:
                        FormValidators.accountNameValidateFunction,
                    hintText: AppLocalizations.of(context)!.accountName,
                    key: Key(widget.bankAccount.id),
                    textInputFormatters: [LengthLimitingTextInputFormatter(20)],
                    focusNode: _focusNode,
                    onChanged: (value) {
                      _createAccountNameValue = value;
                      _error = null;
                      copyWithActualProperties(callIsValid: value.isNotEmpty);
                    },
                  ),
                  if (_error?.otherMessages != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        _error!.otherMessages!,
                        style: CustomTextStyle.ErrorTextStyle(context),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.showDivider)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomDivider(),
              ),
          ],
        ),
      ),
    );
  }
}
