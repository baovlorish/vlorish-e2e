import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'lib/function_common.dart';
import 'screen/dashboard.dart';
import 'screen/forgotPassword.dart';
import 'screen/signin.dart';
import 'screen/signup.dart';

const String testDescription = 'Forgot Password';
void main() async {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;
  ForgotPasswordScreenTest forgotPassScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('Forgot Password Page', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);
      context = context ?? '';
      String homeURL = Uri.base.toString();

      try {
        await htLogdDirect(
            'BAR-T66 User is redirected to the Forgot Password flow pages',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T66 User is redirected to the Forgot Password flow pages',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T66 User is redirected to the Forgot Password flow pages',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T72 User see error message if entered Email that does not exist in the app (BD)',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(getRandomString(10) + '@gmail.com');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T72 User see error message if entered Email that does not exist in the app (BD)',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T72 User see error message if entered Email that does not exist in the app (BD)',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T74 User see error message and can not send request for password if enters space into the start of the Email field',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen
            .inputEmail(' ' + getRandomString(10) + '@gmail.com');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T74 User see error message and can not send request for password if enters space into the start of the Email field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T74 User see error message and can not send request for password if enters space into the start of the Email field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T75 User see error message and can not send request for password if enters space into the start of the Email field',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen
            .inputEmail(getRandomString(10) + '@gmail.com' + ' ');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T75 User see error message and can not send request for password if enters space into the start of the Email field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T75 User see error message and can not send request for password if enters space into the start of the Email field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T76 User see error message and can not send request for password if enters Email without domain part',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(getRandomString(10) + '@gmail');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T76 User see error message and can not send request for password if enters Email without domain part',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T76 User see error message and can not send request for password if enters Email without domain part',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T77 User see error message and can not send request for password if enters Email without "@" character',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(getRandomString(10) + 'gmail.com');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T77 User see error message and can not send request for password if enters Email without "@" character',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T77 User see error message and can not send request for password if enters Email without "@" character',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T78 User see error message and cannot send request for password if enters Email without local part',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail('@gmail.com');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T78 User see error message and cannot send request for password if enters Email without local part',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T78 User see error message and cannot send request for password if enters Email without local part',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T80 User can leave Forgot Password window by tapping back button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await dashboardScreen.clickBack();
        await signInScreen.verifySignInPage(tester, context: context);
        await htLogd(
            tester,
            'BAR-T80 User can leave Forgot Password window by tapping back button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T80 User can leave Forgot Password window by tapping back button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T81 User see error message if click on Next button with empty Email field',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail('');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'Please, enter your email', tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T81 User see error message if click on Next button with empty Email field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T81 User see error message if click on Next button with empty Email field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect('BAR-T82 User can see a confirmation about an email',
            '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await htLogd(
            tester,
            'BAR-T82 User can see a confirmation about an email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T82 User can see a confirmation about an email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T84 User sees error message after clicking on "Done" button with empty Password field',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least 8 characters', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'Confirm Password', tester);
        await htLogd(
            tester,
            'BAR-T84 User sees error message after clicking on "Done" button with empty Password field',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T84 User sees error message after clicking on "Done" button with empty Password field',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T85 Password fields contain at least 8 characters',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least 8 characters', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);

        await htLogd(
            tester,
            'BAR-T85 Password fields contain at least 8 characters',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T85 Password fields contain at least 8 characters',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T86 User sees error message if Password & Confirm Password fields do not match',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test1234');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least 8 characters', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'Passwords do not match. Please re-enter the password.', tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T86 User sees error message if Password & Confirm Password fields don’t match',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T86 User sees error message if Password & Confirm Password fields don’t match',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T91 User sees error message and can not recover password if password does not contain 1 special char',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test12345');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test12345');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);
        await htLogd(
            tester,
            'BAR-T91 User sees error message and can not recover password if password does not contain 1 special char',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T91 User sees error message and can not recover password if password does not contain 1 special char',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T92 User sees error message and can not recover password if password does not contain 1 number',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen
            .inputPasswordinConfirmEmailScreen('testPassword');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('testPassword');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T92 User sees error message and can not recover password if password does not contain 1 number',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T92 User sees error message and can not recover password if password does not contain 1 number',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T93 User sees error message and can not recover password if password does not contain 1 uppercase',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen
            .inputPasswordinConfirmEmailScreen('testpassword');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('testpassword');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);
        await htLogd(
            tester,
            'BAR-T93 User sees error message and can not recover password if password does not contain 1 uppercase',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T93 User sees error message and can not recover password if password does not contain 1 uppercase',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T94 User sees error message and can not recover password if password does not contain 1 lowercase',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen
            .inputPasswordinConfirmEmailScreen('TESTPASSWORD');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('TESTPASSWORD');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)', tester);
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol', tester);
        await htLogd(
            tester,
            'BAR-T94 User sees error message and can not recover password if password does not contain 1 lowercase',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T94 User sees error message and can not recover password if password does not contain 1 lowercase',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T95 Password fields can contain min 8 characters',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
        await forgotPassScreen.inputEmail(emailLogin);
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen.clickBtnNext(tester, context: context);
        await forgotPassScreen.verifyErrorMessage(
            'The password should include at least 8 numbers. Please re-enter the password',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T95 Password fields can contain min 8 characters',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T95 Password fields can contain min 8 characters',
            '',
            'FINISHED');
      }
    });
  });
}
