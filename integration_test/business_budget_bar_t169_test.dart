import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';

const String testDescription = 'Business Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest businessBudgetScreen;
  await htTestInit(description: testDescription);
  group('Business Budget', () {
    testWidgets('Business Budget test', (tester, [String? context]) async {
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
          'BAR_T169 User is redirected on Debts flow page after clicking on “Debts” tab',
          '',
          'STARTED');
      await businessBudgetScreen.clickBusinessTab(tester);
      await businessBudgetScreen.verifyBusinessBudgetPage(tester);
      await businessBudgetScreen.clickBudgetTab(btnDebt, tester);
      await businessBudgetScreen.verifyDebtsPage(tester);
      await htLogd(
          tester,
          'BAR_T169 User is redirected on Debts flow page after clicking on “Debts” tab',
          '',
          'FINISHED');
    });
  });
}
