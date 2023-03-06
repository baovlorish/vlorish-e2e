import 'dart:math';

import 'package:burgundy_budgeting_app/ui/atomic/atom/dashboard_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class MonthDashboard extends StatelessWidget {
  final bool isVertical;

  final DashboardData data;

  final VoidCallback? onUnbudgeted;
  const MonthDashboard({
    required this.isVertical,
    required this.data,
    this.onUnbudgeted,
  });

  @override
  Widget build(BuildContext context) {
    var dashboardItems = [
      DashboardItem(
        text: AppLocalizations.of(context)!.totalPlanned.capitalize(),
        iconUrl: 'assets/images/icons/active.png',
        sumString: data.totalBudgeted.formattedWithDecorativeElementsString(),
        textSize: data.textSize,
      ),
      DashboardItem(
        text: AppLocalizations.of(context)!.totalSpent.capitalize(),
        iconUrl: 'assets/images/icons/categories_total_expenses.png',
        sumString: data.totalSpent.formattedWithDecorativeElementsString(),
        textSize: data.textSize,
      ),
      DashboardItem(
        text: AppLocalizations.of(context)!.difference.capitalize(),
        iconUrl: 'assets/images/icons/categories_free_cash.png',
        sumString: data.difference.formattedWithDecorativeElementsString(),
        textSize: data.textSize,
      ),
      DashboardItem(
        text: AppLocalizations.of(context)!.totalUncategorized.capitalize(),
        iconUrl: 'assets/images/icons/categories_other_expenses.png',
        sumString: data.totalUnbudgeted.formattedWithDecorativeElementsString(),
        textSize: data.textSize,
        onTap: onUnbudgeted,
      ),
    ];
    return isVertical
        ? Container(
            color: CustomColorScheme.blockBackground,
            height: 675,
            width: 400,
            child: Column(
              children: [
                Container(
                  height: 41,
                  decoration: BoxDecoration(
                    color: CustomColorScheme.blockBackground,
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColorScheme.tableBorder,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: dashboardItems,
                ),
              ],
            ),
          )
        : Container(
            height: 360,
            width: 890,
            decoration: BoxDecoration(
              color: CustomColorScheme.blockBackground,
              border: Border(
                bottom: BorderSide(
                  color: CustomColorScheme.tableBorder,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    dashboardItems[0],
                    dashboardItems[2],
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    dashboardItems[1],
                    dashboardItems[3],
                  ],
                ),
              ],
            ),
          );
  }
}

class DashboardData {
  final int totalBudgeted;
  final int totalSpent;
  final int totalUnbudgeted;
  final int difference;

  const DashboardData(
      {required this.totalBudgeted,
      required this.totalSpent,
      required this.totalUnbudgeted,
      required this.difference});

  double get textSize {
    var textSize = 26.0;
    var maxLength = [
      totalBudgeted.toString().length,
      totalSpent.toString().length,
      totalUnbudgeted.toString().length,
      difference.toString().length
    ].reduce(max);
    if (maxLength > 7) {
      textSize = 20.0;
    }
    if (maxLength > 9) {
      textSize = 17.0;
    }
    if (maxLength > 11) {
      textSize = 16.0;
    }
    return textSize;
  }
}
