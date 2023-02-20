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
  BudgetScreenTest businessBudgetScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      businessBudgetScreen = BudgetScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await businessBudgetScreen.verifyPersonalBudgetPage(tester);

      await htLogdDirect(
          'BAR_T170 User is redirected on Goals flow page after clicking on “Goals” tab',
          '',
          'STARTED');
      await businessBudgetScreen.clickBusinessTab(tester);
      await businessBudgetScreen.verifyBusinessBudgetPage(tester);
      await businessBudgetScreen.clickBudgetTab(btnGoals, tester);
      await businessBudgetScreen.verifyGoalsPage(tester);
      await htLogd(
          tester,
          'BAR_T170 User is redirected on Goals flow page after clicking on “Goals” tab',
          '',
          'FINISHED');
    });
  });
}
