import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_radio_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/text_field_with_suggestion.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef _AddAccountFunction = Future<String?> Function({
  required String name,
  required int usageType,
  required int accountType,
  String? businessName,
});

class AddManualAccountPopup extends StatefulWidget {
  final bool isStandardSubscription;
  final List<String> businessNameList;
  final _AddAccountFunction addAccountFunction;

  const AddManualAccountPopup(
    BuildContext context, {
    required this.businessNameList,
    required this.isStandardSubscription,
    required this.addAccountFunction,
  });

  @override
  State<StatefulWidget> createState() => _AddManualAccountItemState();
}

class _AddManualAccountItemState extends State<AddManualAccountPopup> {
  late final List<String> _personalAccountTypes;
  late final List<String> _businessAccountTypes;
  // todo: (andreyK) use this for investment account as description
  // Set up your new brokerage account, retirement account or personal asset

  static const noUsageTypeSelected = 0;
  static const personalUsageType = 1;
  static const businessUsageType = 2;

  static const fieldWidth = 315.0;
  static const paddingSize = 30.0;
  static const popupWidth = fieldWidth + paddingSize + fieldWidth + 1; // for some reason it overflows for 1px

  var _createAccountNameValue = '';
  var _usageType = noUsageTypeSelected;
  int? _chosenAccountType;
  String? businessName;
  String? errorText;

  bool get isValid =>
      _createAccountNameValue.isNotEmpty &&
      _usageType != noUsageTypeSelected &&
      _chosenAccountType != null &&
      (businessName != null || _usageType == personalUsageType);

  bool get isPersonalType => _usageType == personalUsageType;

  bool get isBusinessType => _usageType == businessUsageType;

  @override
  void initState() {
    // added for https://itomych.atlassian.net/browse/BAR-2988
    if (widget.isStandardSubscription) _usageType = personalUsageType;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _personalAccountTypes = [
      AppLocalizations.of(context)!.creditCard,
      AppLocalizations.of(context)!.studentLoan,
      AppLocalizations.of(context)!.autoLoan,
      AppLocalizations.of(context)!.personalLoan,
      AppLocalizations.of(context)!.mortgageLoan,
      AppLocalizations.of(context)!.investment,
      AppLocalizations.of(context)!.retirementAccount,
      AppLocalizations.of(context)!.primaryHome,
      AppLocalizations.of(context)!.vehicle,
      AppLocalizations.of(context)!.backTaxes,
      AppLocalizations.of(context)!.medicalBills,
      AppLocalizations.of(context)!.otherAsset,
      AppLocalizations.of(context)!.alimony,
      AppLocalizations.of(context)!.otherDebt,
    ];
    _businessAccountTypes = [
      AppLocalizations.of(context)!.creditCard,
      AppLocalizations.of(context)!.businessLoan,
      AppLocalizations.of(context)!.autoLoan,
      AppLocalizations.of(context)!.businessAssets,
    ];
  }


  void onAddAccountButtonPressed() async {
    if (!isValid) return;
    errorText = await widget.addAccountFunction(
      usageType: _usageType,
      accountType: _chosenAccountType!,
      name: _createAccountNameValue,
      businessName: businessName,
    );

    if (!mounted) return;
    setState(() {
      if (errorText == null) Navigator.pop(context);
    });
  }

  final constrains = BoxConstraints(maxWidth: fieldWidth);

  Widget typeAndAccountNameColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: AppLocalizations.of(context)!.chooseAccountType.isRequired, type: LabelType.GeneralNew),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomRadioButtonNew(
                    title: AppLocalizations.of(context)!.personal,
                    value: personalUsageType,
                    groupValue: _usageType,
                    onTap: () => setState(() {
                      _chosenAccountType = null;
                      _usageType = personalUsageType;
                    }),
                  ),
                  SizedBox(width: 15),
                  CustomRadioButtonNew(
                    title: AppLocalizations.of(context)!.business,
                    value: businessUsageType,
                    groupValue: _usageType,
                    onTap: () => setState(() {
                      _chosenAccountType = null;
                      _usageType = businessUsageType;
                    }),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: paddingSize),
          ConstrainedBox(
            constraints: constrains,
            child: InputItem(
              labelText: AppLocalizations.of(context)!.createAccountName.isRequired,
              validateFunction: FormValidators.accountNameValidateFunction,
              hintText: AppLocalizations.of(context)!.addAccountName,
              textInputFormatters: [LengthLimitingTextInputFormatter(20)],
              errorText: errorText,
              onChanged: (value) => setState(() => _createAccountNameValue = value),
            ),
          ),
        ],
      );

  Widget categoryAndBusinessNameColumn() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: constrains,
            child: DropdownItem<int>(
              key: Key(isPersonalType ? 'personal' : 'business'),
              enabled: _usageType != noUsageTypeSelected,
              labelText: AppLocalizations.of(context)!.chooseCategory.isRequired,
              items: isPersonalType ? _personalAccountTypes : _businessAccountTypes,
              hintText: AppLocalizations.of(context)!.select,
              validateFunction: FormValidators.accountCategoryValidateFunction,
              callback: (value) => setState(() => _chosenAccountType = value),
            ),
          ),
          SizedBox(height: paddingSize),
          if (isBusinessType)
            ConstrainedBox(
              constraints: constrains,
              child: SingleChildScrollView(
                child: TextFieldWithSuggestion<String>(
                  search: (value) => widget.businessNameList.where((element) => element.contains(value)).toList(),
                  hideOnEmpty: true,
                  maxSymbols: 15,
                  shouldEraseOnFocus: false,
                  onSelectedModel: (value) => setState(() => businessName = value),
                  onSaved: (value) => setState(() => businessName = value),
                  hintText: AppLocalizations.of(context)!.addBusinessName,
                  label: AppLocalizations.of(context)!.businessName.isRequired,
                ),
              ),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) => TwoButtonDialogNew(
        title: AppLocalizations.of(context)!.addAccount,
        description: AppLocalizations.of(context)!.setUpYourNewBankAccountCreditCardOrLoanAccount,
        rightButtonParams: ButtonParams(AppLocalizations.of(context)!.cancel),
        leftButtonParams: ButtonParams(
          AppLocalizations.of(context)!.createAccount,
          isEnabled: isValid,
          onPressed: onAddAccountButtonPressed,
        ),
        child: SizedBox(
          width: popupWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              typeAndAccountNameColumn(),
              SizedBox(width: paddingSize),
              categoryAndBusinessNameColumn(),
            ],
          ),
        ),
      );
}
