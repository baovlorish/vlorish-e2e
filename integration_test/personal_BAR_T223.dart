import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/budgetCategories.dart';
import 'screen/profile.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  BudgetCategoryScreenTest personalBudgetCategoryScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      personalBudgetCategoryScreen = BudgetCategoryScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect('BAR_T223 Check', '', 'STARTED');
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        await personalBudgetScreen.clickCategoryList('Income', tester);
        await personalBudgetScreen.inputValuePlannedCell(
            'Owner Draw', 1, '9', tester);
        await personalBudgetScreen.inputValuePlannedCell(
            'Owner Draw', 3, '', tester);
        await personalBudgetScreen.getValueCell('Owner Draw', 1, '9', tester);
        await tester.pumpAndSettle(const Duration(seconds: 10));
        await htLogd(tester, 'BAR_T223 Check ', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR_T223 Check', '', 'FINISHED');
      }
    });
  });
}
