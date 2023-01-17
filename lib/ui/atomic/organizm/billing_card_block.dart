import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/model/subscription_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BillingCardBlock extends StatelessWidget {
  final SubscriptionModel subscriptionModel;

  BillingCardBlock(this.subscriptionModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.paymentDetails,
            style:
                CustomTextStyle.HeaderTextStyle(context).copyWith(fontSize: 24),
          ),
          SizedBox(height: 20),
          billingCardRow(
            AppLocalizations.of(context)!.creditCard,
            context,
            rowInfo:
                '**** **** **** ${subscriptionModel.creditCardLastFourDigits}',
          ),
          billingCardRow(
            AppLocalizations.of(context)!.expirationDate,
            context,
            rowInfo: CustomDateFormats.defaultDateFormat.format(DateTime.parse(
                subscriptionModel.creditCardExpirationDate.toString())),
          ),
          Text(
            (subscriptionModel.isCancelledByPeriodEnd
                    ? 'Subscription is active until '
                    : AppLocalizations.of(context)!.nextPaymentOn) +
                ' ' +
                CustomDateFormats.defaultDateFormat.format(
                  DateTime.parse(
                    subscriptionModel.nextPaymentDate.toString(),
                  ),
                ),
            style: CustomTextStyle.GreyLabelStyle(context),
          ),
        ],
      ),
    );
  }

  Widget billingCardRow(String rowTitle, BuildContext context,
      {String? rowInfo}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            rowTitle,
            style: CustomTextStyle.GreyLabelStyle(context),
          ),
          Visibility(
            visible: (rowInfo != null),
            child: Text(
              rowInfo!,
              style: CustomTextStyle.LabelTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}
