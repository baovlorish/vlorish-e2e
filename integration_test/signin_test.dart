import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:logger/logger.dart';
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
      final Logger logger = getLogger('Signin test');
      final FlutterExceptionHandler? originalOnError = FlutterError.onError;
      // final originalOnError = FlutterError.onError!;
      // FlutterError.onError = (FlutterErrorDetails details) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);

      try {
        print('T67 User can edit visible password');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', 'test123!ABC');
        await signInScreen.clickEyePassword();
        await signInScreen.verifyPasswordShow('test123!ABC');
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', '123');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage(
            'Password should contain at least 8 characters, max 128 characters and should contain at least: 1 special char, 1 number, 1 uppercase, 1 lowercase');
        print('Complete case T67');
      } catch (e) {
        print('Error case T67');
      }

      try {
        print(
            'T59 User cannot login with password that does not match with the email of user ');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', 'test123!ABC');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again');
        print('Complete case T59');
      } catch (e) {
        print('Error case T59');
      }

      try {
        print('T57 Login Web with empty email and empty password');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', '');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage('Please, enter your email');
        await signInScreen.verifyErrorMessage('Please enter your password');
        print('Complete case T57');
      } catch (e) {
        print('Error case T57');
      }

      try {
        print('T58 Login Web with empty email');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', 'Abcd123!@#');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage('Please, enter your email');
        print('Complete case T58 empty email');
      } catch (e) {
        print('Error case T58 empty email');
      }

      try {
        print('T58 Login Web with empty password');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('test123@gmail.com', '');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage('Please enter your password');
        print('Complete case T58 empty password');
      } catch (e) {
        print('Error case T58 empty password');
      }

      try {
        print('T64 User can make password visible after tap on “eye“ button');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword('', 'Test123');
        await signInScreen.clickEyePassword();
        await signInScreen.verifyPasswordShow('Test123');

        print('Complete case T64');
      } catch (e) {
        print('Error case T64');
      }

      try {
        print('T65 User can make password visible after tap on “eye“ button');
        await signInScreen.clickEyePassword();
        await signInScreen.verifyPasswordHidden('Test123');
        print('Complete case T65');
      } catch (e) {
        print('Error case T65');
      }

      try {
        print('T69 User cannot login with an invalid email address');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            signInScreen.generateRandomString(10), '');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
        print('Complete case T69');
      } catch (e) {
        print('Error case T69');
      }

      try {
        print('T69 User cannot login with an invalid email address');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            signInScreen.generateRandomString(10), '');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com');
        print('Complete case T69');
      } catch (e) {
        print('Error case T69');
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
        print('T54 User can edit visible password');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021@gmail.com', 'Hello@123456');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again.');
        print('Complete case T54');
      } catch (e) {
        print('Error case T54');
      }

      try {
        print('T60 User can edit visible password');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', 'Hello@123456');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage(
            'There is no user with such an email. Please check if the email is correct and try again');
        await signInScreen.clickLoginButton();
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again. You  have got 3 more attempts');
        print('Complete case T60');
      } catch (e) {
        print('Error case T60');
      }

      // originalOnError(details); // call test framework's error handler
      //};
      FlutterError.onError = originalOnError;
    });
  });
}
