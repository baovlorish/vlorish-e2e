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
import 'screen/personalBudget.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  PersonalBudgetScreenTest personalBudgetScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = PersonalBudgetScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'BAR-T67 User can edit visible password', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', 'test123!ABC', tester,
            context: context);
        await signInScreen.clickEyePassword(tester, context: context);
        await signInScreen.verifyPasswordShow('test123!ABC');
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', '123', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'Password should contain at least 8 characters, max 128 characters and should contain at least: 1 special char, 1 number, 1 uppercase, 1 lowercase',
            tester,
            context: context);
        await htLogd(
            tester, 'BAR-T67 User can edit visible password', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Error BAR-T67 User can edit visible password', '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T59 User cannot login with password that does not match with the email of user',
            '',
            'STARTED');

        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', 'test123!ABC', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T59 User cannot login with password that does not match with the email of user',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T59 User cannot login with password that does not match with the email of user',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T57 Login Web with empty email and empty password',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', '', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'Please, enter your email', tester,
            context: context);
        await signInScreen.verifyErrorMessage(
            'Please enter your password', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T57 Login Web with empty email and empty password',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T57 Login Web with empty email and empty password',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T58 User cannot login with empty one of the fields - empty email',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', 'Abcd123!@#', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'Please, enter your email', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T58 User cannot login with empty one of the fields - empty email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T58 User cannot login with empty one of the fields - empty email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T58 User cannot login with empty one of the fields - empty password',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'test123@gmail.com', '', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'Please enter your password', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T58 User cannot login with empty one of the fields - empty password',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T58 User cannot login with empty one of the fields - empty password',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T64 User can make password visible after tap on “eye“ button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', 'Test123', tester,
            context: context);
        await signInScreen.clickEyePassword(tester, context: context);
        await signInScreen.verifyPasswordShow('Test123');
        await htLogd(
            tester,
            'BAR_T64 User can make password visible after tap on “eye“ button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T64 User can make password visible after tap on “eye“ button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'User can make password invisible after tap on “eye” button if password is visible',
            '',
            'STARTED');
        await signInScreen.clickEyePassword(tester, context: context);
        await signInScreen.verifyPasswordHidden('Test123');
        await htLogd(
            tester,
            'BAR_T65 User can make password invisible after tap on “eye” button if password is visible',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error User can make password invisible after tap on “eye” button if password is visible',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T69 User cannot login with an invalid email address',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            signInScreen.generateRandomString(10), 'Test123', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T69 User cannot login with an invalid email address',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T69 User cannot login with an invalid email address',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T80 User can leave Forgot Password window by tapping back button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword(tester, context: context);
        await dashboardScreen.clickBack();
        await signInScreen.verifySignInPage(tester, context: context);
        await htLogd(
            tester,
            'BAR_T80 User can leave Forgot Password window by tapping back button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T80 User can leave Forgot Password window by tapping back button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T54 User cannot login with password that does not match with the email',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021@gmail.com', 'Hello@123456', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T54 User cannot login with password that does not match with the email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T54 User cannot login with password that does not match with the email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T60 User sees error message after entering incorrect password 2 times',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021@gmail.com', 'Hello@123456', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again',
            tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again. You  have got 3 more attempts',
            tester,
            context:
                context); // status is pending, will check again after enable to connect DB
        await htLogd(
            tester,
            'BAR_T60 User sees error message after entering incorrect password 2 times',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T60 User sees error message after entering incorrect password 2 times',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T52 User can login by correct Email and correct password',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021@gmail.com', 'Hello@1234', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickLogoutButton(tester);
        await htLogd(
            tester,
            'BAR_T52 User can login by correct Email and correct password',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T52 User can login by correct Email and correct password',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T68 User can login with visible password', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021@gmail.com', 'Hello@1234', tester,
            context: context);
        await signInScreen.clickEyePassword(tester);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await htLogd(tester, 'BAR_T68 User can login with visible password', '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T68 User can login with visible password',
            '',
            'FINISHED');
      }
    });
  });
}
