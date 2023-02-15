import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
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
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      await htLogdDirect(
          'BAR_T99 Check that user can update password', '', 'STARTED');
      await dashboardScreen.clickProfileIcon(tester);
      await profileScreen.verifyProfilePage(tester);
      await profileScreen.inputUpdatePassword(
          'Test@1234', 'Hello@1234', tester);
      await profileScreen.clickUpdatePasswordButton(tester);
      await profileScreen.clickContinueButton(
          'Your password has been updated successfully.', tester);
      await dashboardScreen.clickLogoutButton(tester);
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'The password is incorrect. Please check the password and try again',
          tester,
          context: context);
      await signInScreen.inputEmailAndPassword(emailLogin, 'Hello@1234', tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);
      await dashboardScreen.clickProfileIcon(tester);
      await profileScreen.verifyProfilePage(tester);
      await profileScreen.inputUpdatePassword('Hello@1234', passLogin, tester);
      await profileScreen.clickUpdatePasswordButton(tester);
      await profileScreen.clickContinueButton(
          'Your password has been updated successfully.', tester);

      await htLogd(tester, 'BAR_T99 Check that user can update password', '',
          'FINISHED');
    });
  });
}
