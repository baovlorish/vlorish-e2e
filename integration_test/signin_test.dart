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
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      passwordRecoveryScreen = PasswordRecoveryScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'TC01-001 Verify fields on the let’s sign in landing page', '', 'STARTED');
        await signInScreen.verifyShowSignInPage(tester);
        await signInScreen.verifyViewIcon(false, tester);
        await signInScreen.clickEyePassword(tester);
        await signInScreen.verifyViewIcon(true, tester);
        await signInScreen.clickForgotPassword(tester);
        await passwordRecoveryScreen.verifyShowPasswordRecoveryPage(tester);
        await passwordRecoveryScreen.clickButton(cancelBtn, tester);
        await signInScreen.clickSignupBtn(tester);
        await signUpScreen.verifyShowSignupPage(tester);
        await signUpScreen.clickSignInButton(tester);
        await htLogd(
            tester, 'TC01-001 Verify fields on the let’s sign in landing page', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-001 Failed Verify fields on the let’s sign in landing page',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-002 Successful user Sign-In with Email and Password Input', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.verifyShowText(emailLogin, tester);
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.clickEyePassword(tester);
        await signInScreen.verifyPasswordShow(passLogin, tester);
        await signInScreen.clickSignInButton(tester);
        await personalBudgetScreen.verifyShowPersonalBudgetPage(tester);
        await dashboardScreen.clickLogoutButton(tester);
        await htLogd(tester, 'TC01-002 Successful user Sign-In with Email and Password Input', '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-002 Successful user Sign-In with Email and Password Input',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-003 Vlorish Displays Error Message for Invalid/Unregistered Email Input',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        final ranomtext = getRandomCharacter(10);
        await signInScreen.inputEmail(ranomtext, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(invalidEmailErorMsg, tester);
        await dashboardScreen.clickLogoText();
        final ranomEmail = getRandomCharacter(10) + '@gmail.com';
        await signInScreen.inputEmail(ranomEmail, tester);
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(unregisteredEmailErrorMsg, tester);
        await htLogd(
            tester,
            'TC01-003 Vlorish Displays Error Message for Invalid/Unregistered Email Input',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-003 Vlorish Displays Error Message for Invalid/Unregistered Email Input',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-010 Verify that user is redirected to “Personal budget” when user successfully sign-in',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.clickSignInButton(tester);
        await personalBudgetScreen.verifyShowPersonalBudgetPage(tester);
        await dashboardScreen.clickLogoutButton(tester);
        await htLogd(
            tester,
            'TC01-010 Verify that user is redirected to “Personal budget” when user successfully sign-in',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-010 Verify that user is redirected to “Personal budget” when user successfully sign-in',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-005 Vlorish Displays Error Message for Incorrect Email Format Input',
            '',
            'STARTED');

        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmail('baoq+1@', tester);
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(invalidEmailErorMsg, tester);
        await htLogd(
            tester,
            'TC01-005 Vlorish Displays Error Message for Incorrect Email Format Input',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-005 Vlorish Displays Error Message for Incorrect Email Format Input',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-004 Vlorish Displays Error Messages for Empty Email and Password Fields on Sign-In',
            '',
            'STARTED');

        await dashboardScreen.clickLogoText();
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(emptyEmailMsg, tester);
        await signInScreen.verifyErrorMessage(emptyPasswordMsg, tester);

        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(emptyPasswordMsg, tester);

        await dashboardScreen.clickLogoText();
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(emptyEmailMsg, tester);

        await htLogd(
            tester,
            'TC01-004 Vlorish Displays Error Messages for Empty Email and Password Fields on Sign-In',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-004 Vlorish Displays Error Messages for Empty Email and Password Fields on Sign-Int',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-006 Vlorish Displays Error Message for Nonexistent Email Input', '', 'STARTED');

        final nonexistentEmail = (getRandomCharacter(10) + '@gmail.com').toLowerCase();
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmail(nonexistentEmail, tester);
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(unregisteredEmailErrorMsg, tester);
        await htLogd(tester, 'TC01-006 Vlorish Displays Error Message for Nonexistent Email Input',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-006 Vlorish Displays Error Message for Nonexistent Email Input',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-009 Verification of Default Encryption and Encryption/Decryption Functionality for Password Field',
            '',
            'STARTED');

        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.verifyPasswordHidden(passLogin, tester);

        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.inputPassword(passLogin, tester);
        await signInScreen.clickEyePassword(tester);
        await signInScreen.verifyPasswordShow(passLogin, tester);

        await htLogd(
            tester,
            'TC01-009 Verification of Default Encryption and Encryption/Decryption Functionality for Password Field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-009 Verification of Default Encryption and Encryption/Decryption Functionality for Password Field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-007 Vlorish Displays Error Message for Nonexistent Email Input', '', 'STARTED');

        final incorrectPassword = passLogin + getRandomCharacter(3);
        final wrongPassword = getRandomCharacter(6);
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.inputPassword(incorrectPassword, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(incorrectPasswordErrMsg, tester);

        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.inputPassword(wrongPassword, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(wrongPasswordFomatErrMsg, tester);

        await signInScreen.inputEmail(emailLogin, tester);
        await signInScreen.inputPassword(wrongPassword, tester);
        await signInScreen.clickSignInButton(tester);
        await signInScreen.verifyErrorMessage(wrongPasswordFomatErrMsg, tester);

        await htLogd(tester, 'TC01-007 Vlorish Displays Error Message for Nonexistent Email Input',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-007 Vlorish Displays Error Message for Nonexistent Email Input',
            '',
            'FINISHED');
      }
    });
  });
}
