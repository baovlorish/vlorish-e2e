import '../lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import '../lib/function_common.dart';
import '../lib/test_lib_const.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/forgotPassword.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  ForgotPasswordScreenTest forgotPassScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'BAR_T69 User cannot login with an invalid email address', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('@@', 'Test@123', tester, context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester, 'BAR_T69 User cannot login with an invalid email address', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T69 User cannot login with an invalid email address', '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T80 User can leave Forgot Password window by tapping back button', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester, context: context);
        await dashboardScreen.clickBack();
        await signInScreen.verifySignInPage(tester, context: context);
        await htLogd(tester, 'BAR_T80 User can leave Forgot Password window by tapping back button',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T80 User can leave Forgot Password window by tapping back button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T52 User can login by correct Email and correct password', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await dashboardScreen.clickLogoutButton(tester);
        await htLogd(
            tester, 'BAR_T52 User can login by correct Email and correct password', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed BAR-T52 User can login by correct Email and correct password',
            '', 'FINISHED');
      }
    });
  });
}
