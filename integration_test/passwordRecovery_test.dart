import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/function_common.dart';
import 'lib/test_lib_const.dart';
import 'screen/signin.dart';
import 'screen/passwordRecovery.dart';
import 'screen/dashboard.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  PasswordRecoveryScreenTest passwordRecoveryScreen;
  DashboardScreenTest dashboardScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('Password Recovery test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      passwordRecoveryScreen = PasswordRecoveryScreenTest(tester);
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

      try {
        await htLogdDirect(
            'TC01-011 Display "Password recovery" Step after user clicks “Forgot Password” Button in Vlorish.',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester);
        await passwordRecoveryScreen.verifyShowPasswordRecoveryPage(tester);
        await htLogd(
            tester,
            'TC01-011 Display "Password recovery" Step after user clicks “Forgot Password” Button in Vlorish.',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-011 Display "Password recovery" Step after user clicks “Forgot Password” Button in Vlorish.',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-012 Verify the “Password Recovery” error messages when user enters incorrect or unregistered email',
            '',
            'STARTED');
        final emailDoesntExist = (getRandomCharacter(10) + '@gmail.com').toLowerCase();
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester);
        await passwordRecoveryScreen.inputEmail(getRandomCharacter(10).toLowerCase(), tester);
        await passwordRecoveryScreen.clickButton(recoverMyPasswordBtn, tester);
        await passwordRecoveryScreen.verifyShowMessage(
            passwordRecoveryScreen.invalidEmailErorMsg, tester);

        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester);
        await passwordRecoveryScreen.inputEmail(emailDoesntExist, tester);
        await passwordRecoveryScreen.clickButton(recoverMyPasswordBtn, tester);
        await passwordRecoveryScreen.verifyShowMessage(emailDoesntExistErrorMsg, tester);
        await htLogd(
            tester,
            'TC01-012 Verify the “Password Recovery” error messages when user enters incorrect or unregistered email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-012 Verify the “Password Recovery” error messages when user enters incorrect or unregistered email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-014 Validate that Vlorish displays the confirmation step after user inputs email and click next',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester);
        await passwordRecoveryScreen.inputEmail('baoq+4@vlorish.com', tester);
        await passwordRecoveryScreen.clickButton(recoverMyPasswordBtn, tester);
        await passwordRecoveryScreen.verifyShowVerifyAndSetPasswordPage(tester);
        await htLogd(
            tester,
            'TC01-014 Validate that Vlorish displays the confirmation step after user inputs email and click next',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-014 Validate that Vlorish displays the confirmation step after user inputs email and click next',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'TC01-019 Validate that Vlorish displays correct messages on the password field',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester);
        await passwordRecoveryScreen.inputEmail('baoq+4@vlorish.com', tester);
        await passwordRecoveryScreen.clickButton(recoverMyPasswordBtn, tester);
        await passwordRecoveryScreen.clickButton(saveMyNewPasswordBtn, tester);
        await passwordRecoveryScreen.verifyShowMessage(confirmpasswordText, tester);

        await passwordRecoveryScreen.inputNewPassword('Ab', tester);
        await passwordRecoveryScreen.verifyMessageForPasswordIsVisible(
            containsBothLowerAndUpperCaseLettersMsg, tester);
        await passwordRecoveryScreen.inputNewPassword('Ab12!@#', tester);
        await passwordRecoveryScreen.verifyMessageForPasswordIsVisible(
            containsAtLeastOneNumberAndASymbolMsg, tester);
        await passwordRecoveryScreen.inputNewPassword('Ab12!@#c', tester);
        await passwordRecoveryScreen.verifyMessageForPasswordIsVisible(
            containsAtLeast8CharactersMsg, tester);
        await passwordRecoveryScreen.verifyPasswordHidden(newPasswordText, tester);
        await passwordRecoveryScreen.clickEyePassword(newPasswordText, tester);
        await passwordRecoveryScreen.verifyPasswordShow(newPasswordText, tester);

        await passwordRecoveryScreen.inputConfirmYourNewPassword(getRandomCharacter(10), tester);
        await passwordRecoveryScreen.clickButton(saveMyNewPasswordBtn, tester);
        await passwordRecoveryScreen.verifyShowMessage(passwordDontMatchMsg, tester);
        await passwordRecoveryScreen.inputConfirmYourNewPassword('', tester);
        await passwordRecoveryScreen.clickButton(saveMyNewPasswordBtn, tester);
        await passwordRecoveryScreen.verifyShowMessage(confirmpasswordText, tester);

        await passwordRecoveryScreen.inputNewPassword(getRandomNumber(4), tester);
        await passwordRecoveryScreen.verifyMessageErrorIsVisible(
            containsBothLowerAndUpperCaseLettersMsg, tester);
        await passwordRecoveryScreen.verifyMessageErrorIsVisible(
            containsAtLeastOneNumberAndASymbolMsg, tester);
        await passwordRecoveryScreen.verifyMessageErrorIsVisible(
            containsAtLeast8CharactersMsg, tester);
        await htLogd(
            tester,
            'TC01-019 Validate that Vlorish displays correct messages on the password field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed TC01-019 Validate that Vlorish displays correct messages on the password field',
            '',
            'FINISHED');
      }
    });
  });
}
