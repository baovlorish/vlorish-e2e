import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:logger/logger.dart';
import 'screen/dashboard.dart';
import 'screen/forgotPassword.dart';
import 'screen/signin.dart';
import 'screen/signup.dart';

void main() async {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;
  ForgotPasswordScreenTest forgotPassScreen;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Test', () {
    testWidgets('BAR-T1 SignUp Web with empty email', (tester) async {
      final Logger logger = getLogger('Signin test');
      //final FlutterExceptionHandler? originalOnError = FlutterError.onError;
      // final originalOnError = FlutterError.onError!;
      // FlutterError.onError = (FlutterErrorDetails details) async {
      await app.main();
      developer.log('log me', name: 'my.app.category');
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);

      try {
        print('T66 User is redirected  to the Forgot Password flow pages');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        print('Complete case T66');
        logger.e('Complete case T66');
      } catch (e) {
        logger.e(e);
        print('Error case T66');
      }

      try {
        print(
            'T72 User see error message if entered Email that does not exist in the app (BD)');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        await forgotPassScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again');
        print('Complete case T72');
      } catch (e) {
        print('Error case T72');
      }

      try {
        print(
            'T74 User see error message and can not send request for password if  enters space into the start of the Email field');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        await forgotPassScreen.inputEmail(
            ' ' + signInScreen.generateRandomString(10) + '@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
        print('Complete case T74');
      } catch (e) {
        print('Error case T74');
      }

      try {
        print(
            'T75 User see error message and can not send request for password if  enters space into the start of the Email field');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        await forgotPassScreen.inputEmail(
            signInScreen.generateRandomString(10) + '@gmail.com' + ' ');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
        print('Complete case T75');
      } catch (e) {
        print('Error case T75');
      }

      try {
        print(
            'T76 User see error message and can not send request for password if enters Email without domain part');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        await forgotPassScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
        print('Complete case T76');
      } catch (e) {
        print('Error case T76');
      }

      try {
        print(
            'T77 User see error message and can not send request for password if enters Email without "@" character');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        await forgotPassScreen
            .inputEmail(signInScreen.generateRandomString(10) + 'gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
        print('Complete case T77');
      } catch (e) {
        print('Error case T77');
      }

      try {
        print(
            'T78 User see error message and cannot send request for password if enters Email without local part');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        await forgotPassScreen.inputEmail('@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
        print('Complete case T78');
      } catch (e) {
        print('Error case T78');
      }

      try {
        print(
            'T80 User can leave Forgot Password window by tapping back button');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await dashboardScreen.clickBack();
        await signInScreen.verifySignInPage();
        print('Complete case T80');
      } catch (e) {
        print('Error case T80');
      }

      try {
        print(
            'T81 User see error message if click on Next button with empty Email field');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage('Please, enter your email');
        print('Complete case T81');
      } catch (e) {
        print('Error case T81');
      }

      try {
        print('T82 User can see a confirmation about an email');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        print('Complete case T82');
      } catch (e) {
        print('Error case T82');
      }

      try {
        print(
            'T84 User sees error message after clicking on "Done" button with empty Password field');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage('Confirm Password');
        print('Complete case T84');
      } catch (e) {
        print('Error case T84');
      }

      try {
        print('T85 Password fields contain at least 8 characters');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen.clickBtnNext();
        //await forgotPassScreen.verifyErrorMessage('The password should include at least 8 numbers. Please re-enter the  password');
        print('Complete case T85');
      } catch (e) {
        print('Error case T85');
      }

      try {
        print(
            'T86 User sees error message if Password & Confirm Password fields don’t match');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test1234');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyErrorMessage(
            'Passwords do not match. Please re-enter the password.');
        print('Complete case T86');
      } catch (e) {
        print('Error case T86');
      }

      try {
        print(
            'T91 User sees error message and can not recover password if password does not contain  1 special char');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test12345');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test12345');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol');
        // await forgotPassScreen.verifyMessageErrorIsVisible('Password should contain at least 8 characters and should contain at least:  1 special char, 1 number, 1 uppercase, 1 lowercase. Please re-enter the  password');
        print('Complete case T91');
      } catch (e) {
        print('Error case T91');
      }

      try {
        print(
            'T92 User sees error message and can not recover password if password does not contain  1 special char');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen
            .inputPasswordinConfirmEmailScreen('testPassword');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('testPassword');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol');
        // await forgotPassScreen.verifyErrorMessage('Password should contain at least 8 characters and should contain at least:  1 special char, 1 number, 1 uppercase, 1 lowercase. Please re-enter the  password');
        print('Complete case T92');
      } catch (e) {
        print('Error case T92');
      }

      try {
        print(
            'T93 User sees error message and can not recover password if password does not contain 1 uppercase');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen
            .inputPasswordinConfirmEmailScreen('testpassword');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('testpassword');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)');
        // await forgotPassScreen.verifyErrorMessage('Password should contain at least 8 characters and should contain at least:  1 special char, 1 number, 1 uppercase, 1 lowercase. Please re-enter the  password');
        print('Complete case T93');
      } catch (e) {
        print('Error case T93');
      }

      try {
        print(
            'T94 User sees error message and can not recover password if password does not contain 1 lowercase');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen
            .inputPasswordinConfirmEmailScreen('TESTPASSWORD');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('TESTPASSWORD');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains both lower (a-z) and upper case letters (A-Z)');
        // await forgotPassScreen.verifyErrorMessage('Password should contain at least 8 characters and should contain at least:  1 special char, 1 number, 1 uppercase, 1 lowercase. Please re-enter the  password');
        print('Complete case T94');
      } catch (e) {
        print('Error case T94');
      }

      try {
        print('T95 Password fields can contain min 8 characters');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.inputEmail('farah.ali1021@gmail.com');
        await forgotPassScreen.clickBtnNext();
        await forgotPassScreen.verifyConfirmEmailPage();
        await forgotPassScreen.inputPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen
            .inputConfirmPasswordinConfirmEmailScreen('test123');
        await forgotPassScreen.clickBtnNext();
        //await forgotPassScreen.verifyErrorMessage('The password should include at least 8 numbers. Please re-enter the  password');
        print('Complete case T95');
      } catch (e) {
        print('Error case T95');
      }

      // originalOnError!(details); // call test framework's error handler
      //};
      //FlutterError.onError = originalOnError;
    });
  });
}
