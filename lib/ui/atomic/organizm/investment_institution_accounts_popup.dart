import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_radio_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/text_button_with_icon.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/model/investment_institution_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseInvestmentInstitutionAccountPopup extends StatefulWidget {
  final List<InvestmentInstitutionAccount> accounts;
  final void Function(String id, bool isLoginRequired) onSubmit;
  final void Function() onAddAnother;

  const ChooseInvestmentInstitutionAccountPopup({
    Key? key,
    required this.accounts,
    required this.onSubmit,
    required this.onAddAnother,
  }) : super(key: key);

  @override
  State<ChooseInvestmentInstitutionAccountPopup> createState() =>
      _ChooseInvestmentInstitutionAccountPopupState();
}

class _ChooseInvestmentInstitutionAccountPopupState
    extends State<ChooseInvestmentInstitutionAccountPopup> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return TwoButtonsDialog(
      context,
      height: 400,
      width: 400,
      bodyWidget: Expanded(
        child: SingleChildScrollView(
          child: Column(children: [
            for (var item in widget.accounts)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: CustomColorScheme.tableBorder, width: 2.0),
                  ),
                ),
                child: Row(
                  children: [
                    CustomRadioButton(
                      title: item.institutionName,
                      titleTextOverflow: TextOverflow.ellipsis,
                      groupValue: selectedIndex,
                      value: widget.accounts.indexOf(item),
                      onTap: () {
                        setState(() {
                          selectedIndex = widget.accounts.indexOf(item);
                        });
                      },
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 130,
                  child: TextButtonWithIcon(
                    iconData: Icons.add_circle_rounded,
                    text: AppLocalizations.of(context)!.addAnother,
                    buttonColor: CustomColorScheme.menuBackgroundActive,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onAddAnother();
                    },
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      mainButtonText: AppLocalizations.of(context)!.submit,
      dismissButtonText: AppLocalizations.of(context)!.cancel,
      onMainButtonPressed: () {
        widget.onSubmit(widget.accounts[selectedIndex].id,
            widget.accounts[selectedIndex].isLoginRequired);
      },
    );
  }
}
