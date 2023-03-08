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
            'Failed BAR-T2 User sees error message if enter an invalid email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T4 User sees error message if Email field is empty',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail('', tester, context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'Please, enter your email', tester,
            context: context); // Actually show Please, enter your email
        await htLogd(
            tester,
            'BAR-T4 User sees error message if Email field is empty',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T4 User sees error message if Email field is empty',
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
            'Failed BAR-T5 Sign In page is displayed after click on "Sign In" button on the Sign Up page',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T6 User see error message on SignUp page if email is already exists in database',
            '',
            'STARTED');
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(emailLogin, tester, context: context);
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
            'Failed BAR-T6 User see error message on SignUp page if email is already exists in database',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
            '',
            'STARTED');
        final emailSigup = getRandomString(10) + '@gmail.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(emailSigup, tester, context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword('Test1234@', tester);
        await signUpScreen.inputConfirmPassword('Test1234@', tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(tester);
        await signUpScreen.inputConfirmCodeEmail(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifySigupPersonalInfoPage(tester);

        await htLogd(
            tester,
            'BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
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
            getRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword('', tester, context: context);
        await signUpScreen.inputConfirmPassword('', tester, context: context);
        await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'Please enter your password', tester);
        await signUpScreen.verifyErrorMessage(
            'Please confirm your password', tester);
        await htLogd(
            tester,
            'BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T9 User see error message if one of the Password fields is empty',
            '',
            'STARTED');
        await signUpScreen.clickBtnSignIn(tester, context: context);
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(
            getRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.inputPassword('Test124\$', tester, context: context);
        await signUpScreen.inputConfirmPassword('', tester, context: context);
        await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'Please confirm your password', tester);
        await signUpScreen.inputPassword('', tester, context: context);
        await signUpScreen.inputConfirmPassword('Test124\$', tester,
            context: context);
        await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'Please enter your password', tester);
        await htLogd(
            tester,
            'BAR-T9 User see error message if Confirm Password fields is empty',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T9 User see error message if Confirm Password fields is empty',
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
            getRandomString(10) + '@gmail.com', tester,
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
            'Failed BAR-T16 User see a notification when passwords in password & confirm password fields donnot match',
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
            getRandomString(10) + '@gmail.com', tester,
            context: context);
        await signUpScreen.clickButtonNext(tester, context: context);

        await signUpScreen.inputPassword('1ABV123#24', tester,
            context: context);
        await signUpScreen.clickEyePassword(tester, context: context);
        await signUpScreen.verifyPasswordShow('1ABV123#24', tester);
        await signUpScreen.clickEyePassword(tester, context: context);
        await signUpScreen.verifyPasswordHidden('1ABV123#24', tester);

        await signUpScreen.inputConfirmPassword('AB1V123#2', tester,
            context: context);
        await signUpScreen.clickEyeConfirmPassword(tester, context: context);
        await signUpScreen.verifyConfirmPasswordShow('AB1V123#2', tester);
        await signUpScreen.clickEyeConfirmPassword(tester, context: context);
        await signUpScreen.verifyConfirmPasswordHidden('AB1V123#2', tester);
        await htLogd(
            tester,
            'BAR-T17 User can make password visible and invisible after clicking on eye button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T17 User can make password visible and invisible after clicking on eye button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T21 User can enter max128 characters in Password fields',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail(
            getRandomString(10) + '@gmail.com', tester,
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
            'BAR-T21 User can enter max128 characters in Password fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T21 User can enter max128 characters in Password fields',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T26 User sees error message and is not redirected on Employment page if he leaves empty all fields and click on Next button',
            '',
            'STARTED');
        final email26 = getRandomString(10) + '@gmail.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester);
        await signUpScreen.inputEmail(email26, tester, context: context);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputPassword(passLogin, tester);
        await signUpScreen.inputConfirmPassword(passLogin, tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(tester);
        await signUpScreen.inputConfirmCodeEmail(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifySigupPersonalInfoPage(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter your first name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter last name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please chose your gender', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter the name of your city', tester);

        await htLogd(
            tester,
            'BAR-T26 User sees error message and is not redirected on Employment page if he leaves empty all fields and click on Next buttons',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T26 User sees error message and is not redirected on Employment page if he leaves empty all fields and click on Next button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T27 User sees error message and he is not redirected on Employment page if he leaves at least one empty field (First Name, Last Name, City, Gender) and clicks on Next button',
            '',
            'STARTED');
        final email27 = getRandomString(10) + '@gmail.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester);
        await signUpScreen.inputEmail(email27, tester, context: context);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputPassword(passLogin, tester);
        await signUpScreen.inputConfirmPassword(passLogin, tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(tester);
        await signUpScreen.inputConfirmCodeEmail(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifySigupPersonalInfoPage(tester);
        await signUpScreen.inputFirstName(getRandomCharacter(10), tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter last name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please chose your gender', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter the name of your city', tester);

        await signUpScreen.clickStepEmailConfirmation(tester);
        await signUpScreen.clickStepPersonalInfo(tester);
        await signUpScreen.inputLastName(getRandomCharacter(10), tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter your first name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please chose your gender', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter the name of your city', tester);

        await signUpScreen.clickStepEmailConfirmation(tester);
        await signUpScreen.clickStepPersonalInfo(tester);
        await signUpScreen.clickDropdownButton(tester);
        await signUpScreen.verifySelectDropdown(genderSignupOptions[0], tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter your first name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter last name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter the name of your city', tester);

        await signUpScreen.clickStepEmailConfirmation(tester);
        await signUpScreen.clickStepPersonalInfo(tester);
        await signUpScreen.selectCity('san fran', 'San Francisco, CA', tester);
        await signUpScreen.clickButtonNext(tester);

        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter your first name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please enter last name', tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'Please chose your gender', tester);

        await htLogd(
            tester,
            'BAR-T27 User sees error message and he is not redirected on Employment page if he leaves at least one empty field (First Name, Last Name, City, Gender) and clicks on Next button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T27 User sees error message and he is not redirected on Employment page if he leaves at least one empty field (First Name, Last Name, City, Gender) and clicks on Next button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T28 User cannot enter city that does not exist in "City" feild',
            '',
            'STARTED');
        final email28 = getRandomString(10) + '@gmail.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester);
        await signUpScreen.inputEmail(email28, tester, context: context);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputPassword(passLogin, tester);
        await signUpScreen.inputConfirmPassword(passLogin, tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(tester);
        await signUpScreen.inputConfirmCodeEmail(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifySigupPersonalInfoPage(tester);
        await signUpScreen.selectCity('Sap Prancisco', '', tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyMessageErrorIsVisible(
            'There is no city with such a name. Please check if the name you are inputting is correct',
            tester);

        await htLogd(
            tester,
            'BAR-T28 User cannot enter city that does not exist in "City" feild',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T28 User cannot enter city that does not exist in "City" feild',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect('BAR-T29 User can select gender', '', 'STARTED');
        final email29 = getRandomString(10) + '@gmail.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester);
        await signUpScreen.inputEmail(email29, tester, context: context);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputPassword(passLogin, tester);
        await signUpScreen.inputConfirmPassword(passLogin, tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(tester);
        await signUpScreen.inputConfirmCodeEmail(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.clickDropdownButton(tester);
        await signUpScreen.verifySelectDropdown(genderSignupOptions[0], tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyErrorMessage(genderSignupOptions[0], tester);

        await signUpScreen.clickStepEmailConfirmation(tester);
        await signUpScreen.clickStepPersonalInfo(tester);
        await signUpScreen.verifySelectDropdown(genderSignupOptions[1], tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyErrorMessage(genderSignupOptions[1], tester);

        await signUpScreen.clickStepEmailConfirmation(tester);
        await signUpScreen.clickStepPersonalInfo(tester);
        await signUpScreen.verifySelectDropdown(genderSignupOptions[2], tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyErrorMessage(genderSignupOptions[2], tester);

        await signUpScreen.clickStepEmailConfirmation(tester);
        await signUpScreen.clickStepPersonalInfo(tester);
        await signUpScreen.verifySelectDropdown(genderSignupOptions[3], tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyErrorMessage(genderSignupOptions[3], tester);

        await htLogd(tester, 'BAR-T29 User can select gender', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Failed BAR-T29 User can select gender', '', 'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T31 First name field contains max 50 characters',
            '',
            'STARTED');
        final email31 = getRandomString(10) + '@gmail.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester);
        await signUpScreen.inputEmail(email31, tester, context: context);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputPassword(passLogin, tester);
        await signUpScreen.inputConfirmPassword(passLogin, tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(tester);
        await signUpScreen.inputConfirmCodeEmail(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputFirstName(getRandomCharacter(50), tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyHideMessageError(
            'First name should be up to 32 characters', tester);

        await htLogd(
            tester,
            'BAR-T31 First name field contains max 50 characters',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T31 First name field contains max 50 characters',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect('BAR-T32 Last name field contains max 50 characters',
            '', 'STARTED');
        final email31 = getRandomString(10) + '@gmail.com';
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester);
        await signUpScreen.inputEmail(email31, tester, context: context);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputPassword(passLogin, tester);
        await signUpScreen.inputConfirmPassword(passLogin, tester);
        await signUpScreen.clickAgreeAndContinueBtn(tester);
        await signUpScreen.verifySigupMailCodePage(tester);
        await signUpScreen.inputConfirmCodeEmail(tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.inputLastName(getRandomCharacter(50), tester);
        await signUpScreen.clickButtonNext(tester);
        await signUpScreen.verifyHideMessageError(
            'Last name should be up to 32 characters', tester);

        await htLogd(
            tester,
            'BAR-T32 Last name field contains max 50 characters',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T32 Last name field contains max 50 characters',
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
        await signUpScreen.inputEmail(
            getRandomString(10) + '@gmail.com', tester,
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
            'Failed BAR-T1 User is redirected on Password page after entering correct email',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR-T62 User is redirected on Sign Up flow after clicking on Sign Up button',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.verifySignUpPage(tester, context: context);
        await htLogd(
            tester,
            'BAR-T62 User is redirected on Sign Up flow after clicking on Sign Up button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T62 User is redirected on Sign Up flow after clicking on Sign Up button',
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
            getRandomString(10) + '@gmail.com', tester,
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
            'Failed BAR-T11 User is redirected on Privacy page after clicking on Privacy link',
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
            'Failed BAR-T10 User is redirected on Terms&Conditions page after clicking on Terms link',
            '',
            'FINISHED');
      }
    });
  });
}
