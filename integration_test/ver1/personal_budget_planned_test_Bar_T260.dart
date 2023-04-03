import 'dart:io';
import 'package:collection/collection.dart';

import '../lib/test_lib_common.dart';
import '../lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import '../lib/function_common.dart';
import 'screen/dashboard.dart';
import '../screen/signin.dart';
import 'screen/budget.dart';
import 'screen/budgetCategories.dart';
import 'screen/profile.dart';
import 'screen/plannedBudget.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  PlannedBudgetScreenTest plannedPersonalBudgetScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      plannedPersonalBudgetScreen = PlannedBudgetScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect(
            'BAR_T260 Check that sum is shown by subcategories for current months in category line',
            '',
            'STARTED');

        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        for (var i = 0; i < subCategoryInputList.length; i++) {
          await plannedPersonalBudgetScreen.getAndVerifyValueCurrentMonthCategory(
              btnPlanned, subCategoryInputList[i], subCategoryInputDetailList[i], tester);
        }

        await htLogd(
            tester,
            'BAR_T260 Check that sum is shown by subcategories for current months in category line',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T260 Check that sum is shown by subcategories for current months in category line',
            '',
            'FINISHED');
      }
    });
  });
}
