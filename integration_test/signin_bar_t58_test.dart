import './lib/test_lib_common.dart';
import './lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      context = context ?? '';

      await htLogdDirect(
          'BAR_T58 User cannot login with empty one of the fields',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword('', 'Abcd123!@#', tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage('Please, enter your email', tester,
          context: context);
      await signInScreen.inputEmailAndPassword(
          getRandomString(12) + '@gmail.com', '', tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'Please enter your password', tester,
          context: context);
      await htLogd(
          tester,
          'BAR_T58 User cannot login with empty one of the fields',
          '',
          'FINISHED');
    });
  });
}
