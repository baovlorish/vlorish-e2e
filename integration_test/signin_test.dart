import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/function_common.dart';
import 'lib/test_lib_const.dart';
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
            'BAR_T54 User cannot login with password that does not match with the email',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            emailLogin, 'Test1@123456', tester);
        await signInScreen.clickLoginButton(tester);
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again',
            tester);
        await htLogd(
            tester,
            'BAR_T54 User cannot login with password that does not match with the email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T54 User cannot login with password that does not match with the email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T57 Login Web with empty email and empty password',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', '', tester);
        await signInScreen.clickLoginButton(tester);
        await signInScreen.verifyErrorMessage(
            'Please, enter your email', tester);
        await signInScreen.verifyErrorMessage(
            'Please enter your password', tester);
        await htLogd(
            tester,
            'BAR_T57 Login Web with empty email and empty password',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T57 Login Web with empty email and empty password',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T58 User cannot login with empty one of the fields',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', 'Abcd123!@#', tester);
        await signInScreen.clickLoginButton(tester);
        await signInScreen.verifyErrorMessage(
            'Please, enter your email', tester);
        await signInScreen.inputEmailAndPassword(
            getRandomString(12) + '@gmail.com', '', tester);
        await signInScreen.clickLoginButton(tester);
        await signInScreen.verifyErrorMessage(
            'Please enter your password', tester);
        await htLogd(
            tester,
            'BAR_T58 User cannot login with empty one of the fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T58 User cannot login with empty one of the fields',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T59 User cannot login with password that does not match with the email of user',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            getRandomString(12) + '@gmail.com', 'test123!ABC', tester,
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
            'Error BAR-T59 User cannot login with password that does not match with the email of user',
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
            emailLogin, 'Test1@123456', tester);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again',
            tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again. You have got 3 more attempts',
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
            'Error BAR-T60 User sees error message after entering incorrect password 2 times',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T61 User sees error message after entering incorrect password 5 times',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            emailLogin, getRandomString(3) + getRandomNumber(3) + 'aB@', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again',
            tester);
        for (int i = 0; i < 5; i++) {
          await signInScreen.inputPassword(
              getRandomString(3) + getRandomNumber(3) + 'aB@', tester);
          await signInScreen.clickLoginButton(tester, context: context);
        }

        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Unfortunately you have got no more attempts to sign in',
            tester);

        await htLogd(
            tester,
            'BAR_T61 User sees error message after entering incorrect password 5 times',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T61 User sees error message after entering incorrect password 5 times',
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
        await signInScreen.verifyPasswordShow('Test123', tester);
        await htLogd(
            tester,
            'BAR_T64 User can make password visible after tap on “eye“ button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T64 User can make password visible after tap on “eye“ button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T65 User can make password invisible after tap on “eye” button if password is visible',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', 'Test123', tester);
        await signInScreen.clickEyePassword(tester, context: context);
        await signInScreen.verifyPasswordShow('Test123', tester);
        await signInScreen.clickEyePassword(tester, context: context);
        await signInScreen.verifyPasswordHidden('Test123', tester);
        await htLogd(
            tester,
            'BAR_T65 User can make password invisible after tap on “eye” button if password is visible',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T65 User can make password invisible after tap on “eye” button if password is visible',
            '',
            'FINISHED');
      }

      try {
        final email67 = getRandomString(12) + '@gmail.com';
        await htLogdDirect(
            'BAR-T67 User can edit visible password', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(email67, 'test123!ABC', tester,
            context: context);
        await signInScreen.clickEyePassword(tester, context: context);
        await signInScreen.verifyPasswordShow('test123!ABC', tester);
        await signInScreen.inputEmailAndPassword(email67, '123', tester,
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
            'BAR_T68 User can login with visible password', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
            context: context);
        await signInScreen.clickEyePassword(tester);
        await signInScreen.verifyPasswordShow(passLogin, tester);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await dashboardScreen.clickLogoutButton(tester);
        await htLogd(tester, 'BAR_T68 User can login with visible password', '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T68 User can login with visible password',
            '',
            'FINISHED');
      }

      try {
        // final email = getRandomString(12) + '@gmail.com';
        await htLogdDirect(
            'BAR_T69 User cannot login with an invalid email address',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('@@', 'Test123', tester,
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
            'Error BAR-T69 User cannot login with an invalid email address',
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
        await forgotPassScreen.verifyForgotPasswordPage(tester,
            context: context);
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
            'Error BAR-T80 User can leave Forgot Password window by tapping back button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T52 User can login by correct Email and correct password',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await dashboardScreen.clickLogoutButton(tester);
        await htLogd(
            tester,
            'BAR_T52 User can login by correct Email and correct password',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T52 User can login by correct Email and correct password',
            '',
            'FINISHED');
      }
    });
  });
}
