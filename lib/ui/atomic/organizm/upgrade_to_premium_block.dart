import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/feature_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/subscription_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpgradeToPremiumBlock extends StatelessWidget {
  final SubscriptionModel? model;

  bool get isSubscriptionExist => model != null && model!.isExist;

  const UpgradeToPremiumBlock(this.model);

  @override
  Widget build(BuildContext context) {
    if (model != null) {
      if (model!.isAdvisor) {
        return _downgradeBlock(context);
      } else if (model!.isBusiness) {
        return _advisorBlock(context, isSubscriptionExist);
      } else {
        return _businessBlock(context, isSubscriptionExist);
      }
    } else {
      return _businessBlock(context, isSubscriptionExist);
    }
  }

  Widget _manageSubscriptionButton(
      BuildContext context, bool subscriptionExists) {
    var _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonItem(
            context,
            text: AppLocalizations.of(context)!.manageSubscription,
            onPressed: () async => subscriptionExists
                ? model!.isPremiumOrHigher
                    ? await _downgradeDialog(context, _homeScreenCubit)
                    : _homeScreenCubit
                        .goToCustomerPortal(ProfileOverviewPage.routeName)
                : _homeScreenCubit.navigateToSubscriptionPage(context),
          ),
        ],
      ),
    );
  }

  Widget _downgradeBlock(BuildContext context) {
    return Column(
      children: [
        CustomDivider(),
        Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Label(
                    //fixme: localization
                    text: 'Downgrade to Business or Personal',
                    type: LabelType.General,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                _manageSubscriptionButton(context, isSubscriptionExist),
              ],
            )),
      ],
    );
  }

  Widget _businessBlock(BuildContext context, bool isExist) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: CustomColorScheme.tableBorder,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Container(
              color: Color.fromRGBO(243, 234, 239, 1),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(
                          child: SizedBox(
                            height: 100,
                            child: Image.asset(
                              'assets/images/brand.png',
                              fit: BoxFit.fitHeight,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Label(
                          text: isExist
                              ? AppLocalizations.of(context)!.upgradeToPremium
                              : AppLocalizations.of(context)!.subscribe,
                          type: LabelType.HeaderBold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (isExist)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //fixme: localization
                        FeatureWidget(featureName: 'All the personal features'),
                        FeatureWidget(featureName: 'Realtime Tax Estimates'),
                        FeatureWidget(featureName: 'Separate Business Budget'),
                        FeatureWidget(featureName: 'Multi-business Support'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          _manageSubscriptionButton(context, isSubscriptionExist),
        ],
      ),
    );
  }

  Widget _advisorBlock(BuildContext context, bool isExist) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: CustomColorScheme.tableBorder,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Container(
              color: Color.fromRGBO(243, 234, 239, 1),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(
                          child: SizedBox(
                            height: 100,
                            child: Image.asset(
                              'assets/images/brand.png',
                              fit: BoxFit.fitHeight,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Label(
                          text: isExist
                              ? 'Upgrade to Advisor' //fixme: localization
                              : AppLocalizations.of(context)!.subscribe,
                          type: LabelType.HeaderBold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (isExist)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //fixme: localization
                        FeatureWidget(featureName: 'All the business features'),
                        FeatureWidget(
                            featureName: 'Seamless Client Collaboration'),
                        FeatureWidget(featureName: 'Client Goal Setting'),
                        FeatureWidget(featureName: 'Client Reviews & Audits'),
                        FeatureWidget(
                            featureName: 'Includes Up to 150 Clients'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Label(
              text: 'Downgrade to Standard', //fixme: localization
              type: LabelType.General,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          _manageSubscriptionButton(context, isSubscriptionExist),
        ],
      ),
    );
  }

  Future _downgradeDialog(
      BuildContext context, HomeScreenCubit homeScreenCubit) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => TwoButtonsDialog(
        context,
        title: 'About downgrade', //fixme: localization
        message:
            ' Just a kind reminder, during downgrade Adviser to Business, You will lose access to your clients; during downgrade Business to Personal, You will lose access to your business budget and related accounts', //fixme: localization
        mainButtonText: 'Continue',
        dismissButtonText: 'Cancel',
        onMainButtonPressed: () =>
            homeScreenCubit.goToCustomerPortal(ProfileOverviewPage.routeName),
      ),
    );
  }
}
