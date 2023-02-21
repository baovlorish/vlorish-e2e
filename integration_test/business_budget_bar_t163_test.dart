import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/budgetCategories.dart';

const String testDescription = 'Business Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest businessBudgetScreen;
  BudgetCategoryScreenTest businessBudgetCategoryScreen;
  await htTestInit(description: testDescription);
  group('Business Budget', () {
    testWidgets('Business Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      businessBudgetScreen = BudgetScreenTest(tester);
      businessBudgetCategoryScreen = BudgetCategoryScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await businessBudgetScreen.verifyPersonalBudgetPage(tester);

      await htLogdDirect(
          'BAR_T163 Check List of Categories on Budget Business Annual page',
          '',
          'STARTED');
      await businessBudgetScreen.clickBusinessTab(tester);
      await businessBudgetScreen.verifyBusinessBudgetPage(tester);
      await businessBudgetScreen.clickCategoryArrowIcon(tester);
      await businessBudgetCategoryScreen.verifyBusinessListOfCategories(tester);
      await htLogd(
          tester,
          'BAR_T163 Check List of Categories on Budget Business Annual page',
          '',
          'FINISHED');
    });
  });
}
