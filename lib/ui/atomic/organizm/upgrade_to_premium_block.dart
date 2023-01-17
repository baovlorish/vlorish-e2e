import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/feature_widget.dart';
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
      if (model!.isPremiumOrHigher) {
        return Column(
          children: [
            CustomDivider(),
            Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: 'Downgrade to Standard',
                      type: LabelType.General,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    _manageSubscriptionButton(context, isSubscriptionExist),
                  ],
                )),
          ],
        );
      } else {
        return _premiumBlock(context, isSubscriptionExist);
      }
    } else {
      return _premiumBlock(context, isSubscriptionExist);
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
            onPressed: () => subscriptionExists
                ? _homeScreenCubit
                    .goToCustomerPortal(ProfileOverviewPage.routeName)
                : _homeScreenCubit.navigateToSubscriptionPage(context),
          ),
        ],
      ),
    );
  }

  Widget _premiumBlock(BuildContext context, bool isExist) {
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
                        FeatureWidget(featureName: 'All the standard features'),
                        FeatureWidget(featureName: 'Realtime Tax Estimates'),
                        FeatureWidget(featureName: 'Seamless Client Collaboration'),
                      ],
                    ),
                ],
              ),
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
}
