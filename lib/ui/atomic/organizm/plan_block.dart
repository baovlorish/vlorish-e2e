import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/upgrade_to_premium_block.dart';
import 'package:burgundy_budgeting_app/ui/model/subscription_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'billing_card_block.dart';

class PlanBlock extends StatelessWidget {
  final SubscriptionModel? subscription;
  PlanBlock(this.subscription);


  @override
  Widget build(BuildContext context) {
    if (subscription != null && subscription!.isExist) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.subscription,
                    style: CustomTextStyle.HeaderTextStyle(context)
                        .copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 28),
                  RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.yourAccountIsOn + ' ',
                      style: CustomTextStyle.LabelTextStyle(context),
                      children: [
                        TextSpan(
                          text: subscription!.planName,
                          style:
                              CustomTextStyle.LabelBoldPinkTextStyle(context),
                        ),
                        TextSpan(
                          text: ' ' + AppLocalizations.of(context)!.for1,
                          style: CustomTextStyle.LabelTextStyle(context),
                        ),
                        TextSpan(
                          text: ' \$' +
                              subscription!.pricePerMonth.toStringAsFixed(2) +
                              ' ',
                          style:
                              CustomTextStyle.LabelBoldPinkTextStyle(context),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.perMonth + ' ',
                          style: CustomTextStyle.LabelTextStyle(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomDivider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BillingCardBlock(subscription!),
                SizedBox(height: 50),
                UpgradeToPremiumBlock(subscription),
              ],
            ),
          ],
        ),
      );
    } else {
      return UpgradeToPremiumBlock(subscription);
    }
  }
}
