import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_radio_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/city_field_with_suggestion.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddManualAccountPopup extends AlertDialog {
  final bool isStandardSubscription;

  AddManualAccountPopup(
    BuildContext context, {
    required Future<String?> Function({
      required String name,
      required int usageType,
      required int accountType,
      String? businessName,
    })
        addAccountFunction,
    required List<String> businessNameList,
    required this.isStandardSubscription,
  }) : super(
          content: Container(
            width: 600,
            height: isStandardSubscription ? 400 : 470,
            padding: EdgeInsets.all(16),
            child: _AddManualAccountItem(
              isStandardSubscription: isStandardSubscription,
              addAccountFunction: addAccountFunction,
              businessNameList: businessNameList,
            ),
          ),
        );
}

class _AddManualAccountItem extends StatefulWidget {
  final Future<String?> Function({
    required String name,
    required int usageType,
    required int accountType,
    String? businessName,
  }) addAccountFunction;

  final List<String> businessNameList;
  final bool isStandardSubscription;

  const _AddManualAccountItem({
    Key? key,
    required this.addAccountFunction,
    required this.businessNameList,
    required this.isStandardSubscription,
  }) : super(key: key);

  @override
  __AddManualAccountItemState createState() => __AddManualAccountItemState();
}

class __AddManualAccountItemState extends State<_AddManualAccountItem> {
  late final List<String> _personalAccountTypes;
  late final List<String> _businessAccountTypes;

  String _createAccountNameValue = '';
  int _usageType = 0;
  int _chosenAccountType = 0;
  String? businessName;
  String? errorText;

  bool isValid(String _createAccountNameValue, int _usageType,
          String? businessName) =>
      _createAccountNameValue.isNotEmpty &&
      _usageType != 0 &&
      (businessName != null || _usageType == 1);

  @override
  void initState() {
    // added for https://itomych.atlassian.net/browse/BAR-2988
    if(widget.isStandardSubscription) _usageType = 1;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Label(
            type: LabelType.Header3,
            text: AppLocalizations.of(context)!.addAccount,
          ),
        ),
        SizedBox(height: 24),
        if (!widget.isStandardSubscription) Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: AppLocalizations.of(context)!.chooseAccountType,
                    type: LabelType.General),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CustomRadioButton(
                      title: AppLocalizations.of(context)!.personal,
                      value: 1,
                      groupValue: _usageType,
                      onTap: () => setState(() {
                        _usageType = 1;
                      }),
                    ),
                    SizedBox(width: 24),
                    CustomRadioButton(
                      title: AppLocalizations.of(context)!.business,
                      value: 2,
                      groupValue: _usageType,
                      onTap: () => setState(() {
                        _usageType = 2;
                      }),
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
                      setState(() {});
                    },
                    shouldEraseOnFocus: false,
                    onSaved: (value) {
                      businessName = value;
                      setState(() {});
                    },
                    hintText: 'Enter business name',
                    label: 'Business name'),
              ),
          ],
        ),
        SizedBox(height: 28),
        (_usageType == 1)
            ? DropdownItem<int>(
                key: Key('personal'),
                enabled: _usageType != 0,
                labelText: AppLocalizations.of(context)!.chooseCategory,
                items: _personalAccountTypes,
                hintText: '',
                initialValue: 0,
                validateFunction:
                    FormValidators.accountCategoryValidateFunction,
                callback: (value) {
                  setState(() {
                    _chosenAccountType = value;
                  });
                },
              )
            : DropdownItem<int>(
                key: Key('business'),
                enabled: _usageType != 0,
                labelText: AppLocalizations.of(context)!.chooseCategory,
                items: _businessAccountTypes,
                hintText: '',
                initialValue: 0,
                validateFunction:
                    FormValidators.accountCategoryValidateFunction,
                callback: (value) {
                  setState(() {
                    _chosenAccountType = value;
                  });
                },
              ),
        SizedBox(height: 24),
        InputItem(
          labelText: AppLocalizations.of(context)!.createAccountName,
          validateFunction: FormValidators.accountNameValidateFunction,
          hintText: AppLocalizations.of(context)!.accountName,
          textInputFormatters: [LengthLimitingTextInputFormatter(20)],
          errorText: errorText,
          onChanged: (value) {
            setState(() {
              _createAccountNameValue = value;
            });
          },
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Center(
                child: LabelButtonItem(
                  label: Label(
                    text: AppLocalizations.of(context)!.cancel,
                    type: LabelType.LargeButton,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              key: UniqueKey(),
              child: ButtonItem(
                context,
                text: AppLocalizations.of(context)!.addAccount,
                buttonType: ButtonType.LargeText,
                enabled:
                    isValid(_createAccountNameValue, _usageType, businessName),
                onPressed: () async {
                  if (isValid(
                      _createAccountNameValue, _usageType, businessName)) {
                    errorText = await widget.addAccountFunction(
                      usageType: _usageType,
                      accountType: _chosenAccountType,
                      name: _createAccountNameValue,
                      businessName: businessName,
                    );
                    if (mounted) {
                      setState(() {});
                      if (errorText == null) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
