import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/function_common.dart';
import 'lib/test_lib_const.dart';
import 'screen/signin.dart';
import 'screen/passwordRecovery.dart';
import 'screen/signup.dart';
import 'screen/budget.dart';
import 'screen/dashboard.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  PasswordRecoveryScreenTest passwordRecoveryScreen;
  SignUpScreenTest signUpScreen;
  BudgetScreenTest personalBudgetScreen;
  DashboardScreenTest dashboardScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('Password Recovery test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      passwordRecoveryScreen = PasswordRecoveryScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect('TC01-015 Validate that user can click back', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester);
        await passwordRecoveryScreen.inputEmail(emailLogin, tester);
        await passwordRecoveryScreen.clickButton(recoverMyPasswordBtn, tester);
        await passwordRecoveryScreen.clickButton(backBtn, tester);

        await htLogd(tester, 'TC01-015 Validate that user can click back', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed TC01-015 Validate that user can click back', '', 'FINISHED');
      }
    });
  });
}
