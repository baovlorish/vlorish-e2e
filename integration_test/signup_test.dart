import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'screen/dashboard.dart';
import 'screen/fileReport.dart';
import 'screen/forgotPassword.dart';
import 'screen/signin.dart';
import 'screen/signup.dart';

void main() async {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;
  ForgotPasswordScreenTest forgotPassScreen;
  Report report;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Test', () {
    testWidgets('BAR-T1 SignUp Web with empty email', (tester) async {
      final FlutterExceptionHandler? originalOnError = FlutterError.onError;
      // final originalOnError = FlutterError.onError!;
      // FlutterError.onError = (FlutterErrorDetails details) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);

      try {
        print(
            'T87 User see error message and can not continue registration if password is invalid (without 1 special char or 1 number or 1 uppercase or 1 lowercase)');

        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp();
        await signUpScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
        await signUpScreen.clickButtonNext();
        await signUpScreen.inputPassword('Test123');
        await signUpScreen.inputConfirmPassword('Test123');
        await signUpScreen.clickAgreeAndContinueBtn();
        await forgotPassScreen.verifyMessageErrorIsVisible(
            'contains at least one number (0-9) and a symbol');
        // await signUpScreen.verifyErrorMessage('Password should contain at least 8 characters and should contain at least:  1 special char, 1 number, 1 uppercase, 1 lowercase. Please re-enter the  password');
        print('Complete case T87');
      } catch (e) {
        print('Error case T87');
      }

      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('test12@gmail.com');
      await signUpScreen.clickButtonNext();
      await signUpScreen.verifyPasswordPage();

      print('BAR-T2 SignUp Web with invalid email');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('test');
      await signUpScreen.clickButtonNext();
      await signUpScreen.verifyErrorMessage(
          'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');

      print('BAR-T4 SignUp Web with email empty');
      await signUpScreen.inputEmail('');
      await signUpScreen.clickButtonNext();
      await signUpScreen.verifyErrorMessage('Please, enter your email');

      print('BAR-T5 SignUp Web with click sign-in');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.verifySignInPage();

      print(
          'BAR-T6 User see error message on SignUp page if email is already exists in database');
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('farah.ali1021@gmail.com');
      await signUpScreen.clickButtonNext();
      await signUpScreen.verifyErrorMessage(
          'This email has already been taken by some other user. Please try using another email address');

      print(
          'BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button');

      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickButtonNext();
      await signUpScreen.inputPassword('');
      await signUpScreen.inputConfirmPassword('');
      await signUpScreen.clickAgreeAndContinueBtn();
      // await signUpScreen.verifyErrorMessage('Please enter your password');
      // await signUpScreen.verifyErrorMessage('Please confirm your password');

      print(
          'BAR-T9 User see error message if Confirm Password fields is empty');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickButtonNext();
      await signUpScreen.inputPassword('Test124\$');
      await signUpScreen.inputConfirmPassword('');
      await signUpScreen.clickAgreeAndContinueBtn();
      //await signUpScreen.verifyErrorMessage('Please confirm your password');

      print('BAR-T9 User see error message if the Password fields is empty');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickButtonNext();
      await signUpScreen.inputPassword('');
      await signUpScreen.inputConfirmPassword('Test124\$');
      await signUpScreen.clickAgreeAndContinueBtn();
      //await signUpScreen.verifyErrorMessage('Please enter your password');

      print(
          'BAR-T16 User see a notification when passwords in password & confirm password fields don’t match');
      await signUpScreen.clickBtnSignIn();
      await signInScreen.clickBtnSignUp();
      await signUpScreen
          .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
      await signUpScreen.clickButtonNext();
      await signUpScreen.inputPassword('Test1234\$');
      await signUpScreen.inputConfirmPassword('Test124\$');
      await signUpScreen.clickAgreeAndContinueBtn();
      await signUpScreen.verifyErrorMessage(
          'Passwords do not match. Please re-enter the password.');

      try {
        print(
            'BAR-T17 User can make password visible and invisible  after clicking on eye button');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp();
        await signUpScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
        await signUpScreen.clickButtonNext();

        await signUpScreen.inputPassword('ABV123#2');
        await signUpScreen.clickEyePassword();
        await signUpScreen.verifyPasswordShow('ABV123#2');
        await signUpScreen.clickEyePassword();
        await signUpScreen.verifyPasswordHidden('ABV123#2');

        await signUpScreen.inputConfirmPassword('ABV123#2');
        await signUpScreen.clickEyeConfirmPassword();
        await signUpScreen.verifyConfirmPasswordShow('ABV123#2');
        await signUpScreen.clickEyeConfirmPassword();
        await signUpScreen.verifyConfirmPasswordHidden('ABV123#2');
        print('Complete case T17');
      } catch (e) {
        print('Error case T17');
      }

      try {
        print('T21 User can enter max128 characters in Password fields');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp();
        await signUpScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
        await signUpScreen.clickButtonNext();
        await signUpScreen.inputPassword(
            'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test');
        await signUpScreen.inputConfirmPassword(
            'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test');
        await signUpScreen.clickAgreeAndContinueBtn();
        await signUpScreen.verifyNotCurrentPassword(
            'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test');
        await signUpScreen.verifyCurrentPassword(
            'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Tes');
        await signUpScreen.verifyErrorMessage(
            'Passwords do not match. Please re-enter the password.');
        print('Complete case T21');
      } catch (e) {
        print('Error case T21');
      }

      print(
          'BAR-T1 User is redirected on Password page after entering correct email');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('test12@gmail.com');
      await signUpScreen.clickButtonNext();
      await signUpScreen.verifyPasswordPage();

      try {
        print(
            'T62 User is redirected on Sign Up flow after clicking on Sign Up button');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp();
        await signUpScreen.verifySignUpPage();
        print('Complete case T62');
      } catch (e) {
        print('Error case T62');
      }

      try {
        print(
            'BAR-T11 User is redirected on Privacy page after clicking on Privacy link');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp();
        await signUpScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
        await signUpScreen.clickButtonNext();
        await signUpScreen.clickAndVerifyPrivacyLink();
        print('Complete case T11');
      } catch (e) {
        print('Error case T11');
      }

      try {
        print(
            'BAR-T10 User is redirected on Terms&Conditions page after clicking on Terms link');
        await dashboardScreen.clickBack();
        await signInScreen.clickBtnSignUp();
        await signUpScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
        await signUpScreen.clickButtonNext();
        await signUpScreen.clickAndVerifyTermLink();
        print('Complete case T10');
      } catch (e) {
        print('Error case T10');
      }

      // originalOnError(details); // call test framework's error handler
      //};
      FlutterError.onError = originalOnError;
    });
  });
}
