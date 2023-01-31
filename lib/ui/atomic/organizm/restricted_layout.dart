import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RestrictionType {
  NotSubscribed,
  RestrictedByPlan,
  Expired,
  NotActive,
  Partner
}

class RestrictedLayout extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final RestrictionType restrictionType;

  RestrictedLayout(
      {required this.title,
      required this.onPressed,
      required this.restrictionType});

  final Map<RestrictionType, String> messageMapper = {
    RestrictionType.NotSubscribed: "You haven't subscribed yet",
    RestrictionType.Expired: 'Your subscription has expired',
    RestrictionType.RestrictedByPlan:
        'Upgrade to Business plan to use this feature',
    RestrictionType.NotActive: 'Your subscription is not active',
    RestrictionType.Partner: 'Partner access is in development'
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Label(
              text: title,
              type: LabelType.Header2,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: CustomColorScheme.tableBorder,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120.0,
                        child: Image.asset(
                          'assets/images/brand.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Label(
                          text: messageMapper[restrictionType] ?? '',
                          type: LabelType.Header3),
                      SizedBox(
                        height: 40,
                      ),
                      if (!(restrictionType == RestrictionType.Partner))
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ButtonItem(
                              context,
                              text: AppLocalizations.of(context)!
                                  .manageSubscription,
                              onPressed: onPressed,
                              buttonType: ButtonType.LargeText,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
