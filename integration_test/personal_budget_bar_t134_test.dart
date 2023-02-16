import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      await htLogdDirect(
          'BAR_T134 Check that the user is able to Collapse and Expand categories',
          '',
          'STARTED');
      await personalBudgetScreen.verifyCollapseCategories(tester);
      await personalBudgetScreen.clickCategoryArrowIcon(tester);
      await personalBudgetScreen.verifyExpandCategories(tester);
      await personalBudgetScreen.clickCategoryArrowIcon(tester);
      await personalBudgetScreen.verifyCollapseCategories(tester);
      await htLogd(
          tester,
          'BAR_T134 Check that the user is able to Collapse and Expand categories',
          '',
          'FINISHED');
    });
  });
}