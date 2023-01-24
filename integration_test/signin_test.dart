import 'package:flutter_driver/flutter_driver.dart';
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
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);
      report = Report();

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
        await report.writeReport('Complete case T59');
      } catch (e) {
        await report.writeReport('Error case T59');
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
        print(
            'BAR-T17 User can make password visible and invisible  after clicking on eye button');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp();
        await signUpScreen
            .inputEmail(signInScreen.generateRandomString(10) + '@gmail.com');
        await signUpScreen.clickBtnNext();

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
        await signUpScreen.clickBtnNext();
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
        print('T66 User is redirected  to the Forgot Password flow pages');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickForgotPassword();
        await forgotPassScreen.verifyForgotPasswordPage();
        print('Complete case T66');
      } catch (e) {
        print('Error case T66');
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

      print(
          'BAR-T1 User is redirected on Password page after entering correct email');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp();
      await signUpScreen.inputEmail('test12@gmail.com');
      await signUpScreen.clickBtnNext();
      await signUpScreen.verifyPasswordPage();

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
        await forgotPassScreen.verifyErrorMessage('Please enter your email');
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
        await signUpScreen.clickBtnNext();
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
        await signUpScreen.clickBtnNext();
        await signUpScreen.clickAndVerifyTermLink();
        print('Complete case T10');
      } catch (e) {
        print('Error case T10');
      }
    });
  });
}

mixin DefaultFirebaseOptions {}
