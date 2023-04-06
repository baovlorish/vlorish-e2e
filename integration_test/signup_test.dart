import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/function_common.dart';
import 'lib/test_lib_const.dart';
import 'screen/signin.dart';
import 'screen/passwordRecovery.dart';
import 'screen/signup.dart';
import 'screen/dashboard.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  PasswordRecoveryScreenTest passwordRecoveryScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      passwordRecoveryScreen = PasswordRecoveryScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'TC02-001 Verify fields on the let’s sign in landing page', '', 'STARTED');
        await signInScreen.clickSignupBtn(tester);
        await signUpScreen.verifyShowSignupPage(tester);

        await htLogd(
            tester, 'TC02-001 Verify fields on the let’s sign in landing page', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Failed TC02-001 Verify fields on the let’s sign in landing page', '',
            'FINISHED');
      }

      try {
        await htLogdDirect('TC02-002 Verify the create account step details', '', 'STARTED');
        final emailSignup = getRandomCharacter(10).toLowerCase() + '@vlorish.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickSignupBtn(tester);
        await signUpScreen.verifyShowSignupPage(tester);
        await signUpScreen.inputEmail(emailSignup, tester);
        await signUpScreen.clickButton('Next', tester);
        await signUpScreen.verifyShowSignupPasswordPage(tester);

        await htLogd(tester, 'TC02-002 Verify the create account step details', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed TC02-002 Verify the create account step details', '', 'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC02-003 User Sign-up Functionality verification for create account paget',
            '',
            'STARTED');
        final emailSignup = 'baoq' + getRandomNumber(15) + '@vlorish.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickSignupBtn(tester);
        await signUpScreen.inputEmail(emailSignup, tester);
        await signUpScreen.clickButton('Next', tester);
        await signUpScreen.inputPassword('Test@1234', tester);
        await signUpScreen.verifyMessageForPasswordIsVisible(
            containsBothLowerAndUpperCaseLettersMsg, tester);
        await signUpScreen.verifyMessageForPasswordIsVisible(
            containsAtLeastOneNumberAndASymbolMsg, tester);
        await signUpScreen.verifyMessageForPasswordIsVisible(containsAtLeast8CharactersMsg, tester);
        await signUpScreen.inputConfirmPassword('Test@1234', tester);
        await signUpScreen.clickButton('Agree & Continue', tester);
        await signUpScreen.verifyShowText('Confirm your email', tester);

        await htLogd(
            tester,
            'TC02-003 User Sign-up Functionality verification for create account paget',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC02-003 User Sign-up Functionality verification for create account page',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC02-004 Verify that Vlorish is displaying correct messages when email field is empty or incorrect',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickSignupBtn(tester);
        await signUpScreen.inputEmail(emailLogin, tester);
        await signUpScreen.clickButton('Next', tester);
        await signUpScreen.verifyShowText(
            'This email has already been taken by some other user. Please try using another email address',
            tester);

        final incorrectEmail = getRandomCharacter(15);
        await dashboardScreen.clickLogoText();
        await signInScreen.clickSignupBtn(tester);
        await signUpScreen.inputEmail(incorrectEmail, tester);
        await signUpScreen.clickButton('Next', tester);
        await signUpScreen.verifyShowText(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester);

        await dashboardScreen.clickLogoText();
        await signInScreen.clickSignupBtn(tester);
        await signUpScreen.clickButton('Next', tester);
        await signUpScreen.verifyShowText('Please, enter your email', tester);

        await htLogd(
            tester,
            'TC02-004 Verify that Vlorish is displaying correct messages when email field is empty or incorrect',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC02-004 Verify that Vlorish is displaying correct messages when email field is empty or incorrect',
            '',
            'FINISHED');
      }
    });
  });
}
