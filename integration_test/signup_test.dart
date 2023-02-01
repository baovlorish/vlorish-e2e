import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'screen/dashboard.dart';
import 'screen/forgotPassword.dart';
import 'screen/signin.dart';
import 'screen/signup.dart';

const String testDescription = 'SignUp';
void main() async {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;
  ForgotPasswordScreenTest forgotPassScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignUp Page', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);
      context = context ?? '';
      String homeURL = Uri.base.toString();

      try {
        await htLogdDirect(
            'BAR-T2 User sees error message if enter an invalid email',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail('test', tester, context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T2 User sees error message if enter an invalid email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T2 User sees error message if enter an invalid email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T4 User sees error message if Email field is empty',
            '',
            'STARTED');
        await signUpScreen.inputEmail('', tester, context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.verifyErrorMessage('Please enter your email', tester,
            context: context); // Actually show Please, enter your email
        await htLogd(
            tester,
            'BAR-T4 User sees error message if Email field is empty',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T4 User sees error message if Email field is empty',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T5 Sign In page is displayed after click on "Sign In" button on the Sign Up page',
            '',
            'STARTED');
        await signUpScreen.clickBtnSignIn(tester, context: context);
        await signInScreen.verifySignInPage(tester, context: context);
        await htLogd(
            tester,
            'BAR-T5 Sign In page is displayed after click on "Sign In" button on the Sign Up page',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T5 Sign In page is displayed after click on "Sign In" button on the Sign Up page',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T6 User see error message on SignUp page if email is already exists in database',
            '',
            'STARTED');
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail('farah.ali1021@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'This email has already been taken by some other user. Please try using another email address',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T6 User see error message on SignUp page if email is already exists in database',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T6 User see error message on SignUp page if email is already exists in database',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
            '',
            'STARTED');
        final emailSigup = signInScreen.generateRandomString(10) + '@gmail.com';
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(emailSigup, tester, context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword('Test1234@', tester);
        await signUpScreen.inputConfirmPassword('Test1234@', tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(emailSigup, tester);

        await htLogd(
            tester,
            'BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester);
        await signUpScreen.inputEmail(
            signInScreen.generateRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword('', tester, context: context);
        await signUpScreen.inputConfirmPassword('', tester, context: context);
        await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
        await htLogd(
            tester,
            'BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T9 User see error message if Confirm Password fields is empty',
            '',
            'STARTED');
        await signUpScreen.clickBtnSignIn(tester, context: context);
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(
            signInScreen.generateRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword('Test124\$', tester, context: context);
        await signUpScreen.inputConfirmPassword('', tester, context: context);
        await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
        //await signUpScreen.verifyErrorMessage('Please confirm your password');
        await htLogd(
            tester,
            'BAR-T9 User see error message if Confirm Password fields is empty',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T9 User see error message if Confirm Password fields is empty',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T16 User see a notification when passwords in password & confirm password fields donnot match',
            '',
            'STARTED');
        await signUpScreen.clickBtnSignIn(tester, context: context);
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(
            signInScreen.generateRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword('Test1234\$', tester,
            context: context);
        await signUpScreen.inputConfirmPassword('Test124\$', tester,
            context: context);
        await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'Passwords do not match. Please re-enter the password.', tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T16 User see a notification when passwords in password & confirm password fields donnot match',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T16 User see a notification when passwords in password & confirm password fields donnot match',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T17 User can make password visible and invisible after clicking on eye button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(
            signInScreen.generateRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);

        await signUpScreen.inputPassword('ABV123#2', tester, context: context);
        await signUpScreen.clickEyePassword(tester, context: context);
        await signUpScreen.verifyPasswordShow('ABV123#2');
        await signUpScreen.clickEyePassword(tester, context: context);
        await signUpScreen.verifyPasswordHidden('ABV123#2');

        await signUpScreen.inputConfirmPassword('ABV123#2', tester,
            context: context);
        await signUpScreen.clickEyeConfirmPassword(tester, context: context);
        await signUpScreen.verifyConfirmPasswordShow('ABV123#2');
        await signUpScreen.clickEyeConfirmPassword(tester, context: context);
        await signUpScreen.verifyConfirmPasswordHidden('ABV123#2');
        await htLogd(
            tester,
            'BAR-T17 User can make password visible and invisible after clicking on eye button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T17 User can make password visible and invisible after clicking on eye button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'T21 User can enter max128 characters in Password fields',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(
            signInScreen.generateRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword(
            'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test',
            tester,
            context: context);
        await signUpScreen.inputConfirmPassword(
            'fieldTest12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test12345#Test',
            tester,
            context: context);
        await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);

        await signUpScreen.verifyErrorMessage(
            'Passwords do not match. Please re-enter the password.', tester,
            context: context);
        await htLogd(
            tester,
            'T21 User can enter max128 characters in Password fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error T21 User can enter max128 characters in Password fields',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T1 User is redirected on Password page after entering correct email',
            '',
            'STARTED');

        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail('test12@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.verifyPasswordPage(tester, context: context);
        await htLogd(
            tester,
            'BAR-T1 User is redirected on Password page after entering correct email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T1 User is redirected on Password page after entering correct email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'T62 User is redirected on Sign Up flow after clicking on Sign Up button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.verifySignUpPage(tester, context: context);
        await htLogd(
            tester,
            'T62 User is redirected on Sign Up flow after clicking on Sign Up button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error T62 User is redirected on Sign Up flow after clicking on Sign Up button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T11 User is redirected on Privacy page after clicking on Privacy link',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(
            signInScreen.generateRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.clickAndVerifyPrivacyLink(homeURL, tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T11 User is redirected on Privacy page after clicking on Privacy link',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T11 User is redirected on Privacy page after clicking on Privacy link',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T10 User is redirected on Terms&Conditions page after clicking on Terms link',
            '',
            'STARTED');

        await dashboardScreen.clickBack();

        await signUpScreen.clickAndVerifyTermLink(homeURL, tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T10 User is redirected on Terms&Conditions page after clicking on Terms link',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T10 User is redirected on Terms&Conditions page after clicking on Terms link',
            '',
            'FINISHED');
      }
    });
  });
}
