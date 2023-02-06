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
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'baoq+1@vlorish.com', 'Test@1234', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickProfileIcon(tester);
        await personalBudgetScreen.verifyProfilePage(tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputUpdateName(
            'FName Update', 'LName Update', tester);
        await profileScreen.clickUpdateProfileButton(tester);
        await profileScreen.clickBackButton(tester);
        await personalBudgetScreen.clickProfileIcon(tester);
        await profileScreen.verifyNameUpdate(
            'FName Update', 'LName Update', tester);
        await profileScreen.clickProfileDetailsButton(tester);
        await profileScreen.verifyProfileDetailtPage(tester);
        await profileScreen.inputUpdateName('Bao', 'Test', tester);
        await profileScreen.clickUpdateProfileButton(tester);

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
            'BAR_T99 Check that user can update password', '', 'STARTED');
        await dashboardScreen.clickBack();
        await personalBudgetScreen.clickProfileIcon(tester);
        await personalBudgetScreen.verifyProfilePage(tester);
        await profileScreen.inputUpdatePassword(
            'Test@1234', 'Hello@1234', tester);
        await profileScreen.clickUpdatePasswordButton(tester);
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
