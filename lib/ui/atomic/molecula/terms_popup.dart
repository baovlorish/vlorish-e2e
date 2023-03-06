import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'button_item.dart';
import 'label_button_item.dart';

class TermsPopup extends StatefulWidget {
  final Function onMainButtonPressed;

  const TermsPopup({Key? key, required this.onMainButtonPressed})
      : super(key: key);

  @override
  _TermsPopupState createState() => _TermsPopupState();
}

class _TermsPopupState extends State<TermsPopup> {
  var enableMainButton = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          height: 550,
          width: 600,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CustomMaterialInkWell(
                    type: InkWellType.Purple,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: CustomColorScheme.close,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Label(
                    text: AppLocalizations.of(context)!.termsHeadline,
                    type: LabelType.Header3),
                SizedBox(height: 28),
                Expanded(
                  child: SingleChildScrollView(
                    child: Label(
                      text:
                          '${AppLocalizations.of(context)!.termsOfUseDescription}\n',
                      type: LabelType.General,
                    ),
                  ),
                ),
                SizedBox(height: 28),
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      value: enableMainButton,
                      onChanged: (bool? value) {
                        enableMainButton = value ?? false;
                        setState(() {});
                      },
                    ),
                    Label(
                        text: AppLocalizations.of(context)!.acceptTermsAndConditionsCheckboxLable,
                        type: LabelType.General),
                  ],
                ),
                SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      child: ButtonItem(
                        context,
                        text: AppLocalizations.of(context)!.confirm,
                        buttonType: ButtonType.LargeText,
                        enabled: enableMainButton,
                        onPressed: () {
                          if (enableMainButton) {
                            Navigator.pop(context);
                            widget.onMainButtonPressed();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
