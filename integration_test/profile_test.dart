import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import './lib/function_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/personalBudget.dart';
import 'screen/profile.dart';

const String testDescription = 'Profile Page Test';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  PersonalBudgetScreenTest personalBudgetScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Profile Page', () {
    testWidgets('Profile Detail test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = PersonalBudgetScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'BAR_T98 Check that user can update “First Name” and “Last Name” fields',
            '',
            'STARTED');
        final fName = getRandomString(10);
        final lName = getRandomString(10);
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickProfileIcon(tester);
        await personalBudgetScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputUpdateName(fName, lName, tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.clickContinueButton('Success!', tester);
        await profileScreen.clickBackButton(tester);
        await personalBudgetScreen.clickProfileIcon(tester);
        await profileScreen.verifyNameUpdate(fName, lName, tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputUpdateName('Bao', 'Test', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.clickContinueButton('Success!', tester);

        await htLogd(
            tester,
            'BAR_T98 Check that user can update “First Name” and “Last Name” fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T98 Check that user can update “First Name” and “Last Name” fields',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T103 New Password field contains at least 8 characters',
            '',
            'STARTED');
        await dashboardScreen.clickBack();
        await personalBudgetScreen.clickProfileIcon(tester);
        await personalBudgetScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(passLogin, 'Test13@', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await signInScreen.verifyErrorMessage(
            'contains at least 8 characters', tester,
            context: context);
        await htLogd(
            tester,
            'BAR_T103 New Password field contains at least 8 characters',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T103 New Password field contains at least 8 characters',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T104 User can make password visible after clicking on "eye" button',
            '',
            'STARTED');
        await personalBudgetScreen.clickProfileIcon(tester);
        await profileScreen.inputUpdatePassword(passLogin, '', tester);
        await profileScreen.clickEyePassword(0, tester);
        await profileScreen.verifyPasswordShow(passLogin, tester);

        await htLogd(
            tester,
            'BAR_T104 User can make password visible after clicking on "eye" button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T104 User can make password visible after clicking on "eye" button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T105 User can make password invisible after clicking on “eye” button if password is visible',
            '',
            'STARTED');
        await profileScreen.clickEyePassword(0, tester);
        await profileScreen.verifyPasswordHidden(passLogin, tester);

        await htLogd(
            tester,
            'BAR_T105 User can make password invisible after clicking on “eye” button if password is visible',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T105 User can make password invisible after clicking on “eye” button if password is visible',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T106 User can enter max 128 characters in Password fields',
            '',
            'STARTED');
        final pass128 =
            'Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#';
        final passGreaterThan128 =
            'Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#9';
        await profileScreen.inputUpdatePassword(
            passLogin, passGreaterThan128, tester);
        await profileScreen.clickEyePassword(1, tester);
        await profileScreen.verifyNewPasswordMax128Char(
            pass128, passGreaterThan128, tester);
        await dashboardScreen.clickBack();
        await htLogd(
            tester,
            'BAR_T106 User can enter max 128 characters in Password fields',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T106 User can enter max 128 characters in Password fields',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T99 Check that user can update password', '', 'STARTED');
        await dashboardScreen.clickBack();
        await personalBudgetScreen.clickProfileIcon(tester);
        await personalBudgetScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(
            'Test@1234', 'Hello@1234', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.clickContinueButton(
            'Your password has been updated successfully.', tester);
        await personalBudgetScreen.clickLogoutButton(tester);
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'baoq+1@vlorish.com', 'Test@1234', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'The password is incorrect. Please check the password and try again',
            tester,
            context: context);
        await signInScreen.inputEmailAndPassword(
            'baoq+1@vlorish.com', 'Hello@1234', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickProfileIcon(tester);
        await personalBudgetScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(
            'Hello@1234', 'Test@1234', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
        await profileScreen.clickContinueButton(
            'Your password has been updated successfully.', tester);

        await htLogd(tester, 'BAR_T99 Check that user can update password', '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T99 Check that user can update password',
            '',
            'FINISHED');
      }
    });
  });
}