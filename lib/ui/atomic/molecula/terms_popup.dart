import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'button_item.dart';
import 'label_button_item.dart';

class TermsPopup extends StatefulWidget {
  final Function onMainButtonPressed;

  const TermsPopup({Key? key, required this.onMainButtonPressed}) : super(key: key);

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
                Label(text: 'Terms & Conditions', type: LabelType.Header3),
                SizedBox(height: 28),
                Expanded(
                  child: SingleChildScrollView(
                    child: Label(
                      text:
                          'These Terms of Use constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and Vlorish ("Company", “we”, “us”, or “our”), concerning your access to and use of the vlorish.com website as well as any other media form, media channel, mobile website or mobile application related, linked, or otherwise connected there to (collectively, the “Site”). You agree that by accessing the Site, you have read, understood, and agree to be bound by all of these Terms of Use, including the User Agreement posted on the Site, which are incorporated into these Terms of Use. IF YOU DO NOT AGREE WITH ALL OF THESE TERMS OF USE, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SITE AND YOU MUST DISCONTINUE USE IMMEDIATELY. \nSupplemental terms and conditions or documents that may be posted on the Site from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms of Use at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of these Terms of Use, and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review these Terms of Use to stay informed of updates. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Terms of Use by your continued use of the Site after the date such revised Terms of Use are posted. \nThe information provided on the Site is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Site from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable. \nThe Site is intended for users who are at least 18 years old. Persons under the age of 18 are not permitted to use or register for the Site.\n',
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
                        text: 'I read and agree to the Terms and Conditions',
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
