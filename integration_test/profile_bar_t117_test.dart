import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/forgotPassword.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/profile.dart';

const String testDescription = 'Profile Page Test';

void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  ProfileScreenTest profileScreen;
  ForgotPasswordScreenTest forgotPasswordScreen;
  await htTestInit(description: testDescription);
  group('Profile Page', () {
    testWidgets('Profile Detail test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      forgotPasswordScreen = ForgotPasswordScreenTest(tester);
      context = context ?? '';
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      await htLogdDirect(
          'BAR_T117 User sees error message if password fields are empty',
          '',
          'STARTED');
      await dashboardScreen.clickProfileIcon(tester);
      await profileScreen.inputUpdatePassword('', '', tester);
      await profileScreen.clickUpdatePasswordButton(tester);
      await profileScreen.verifyShowMessage(
          'Please enter your current password', tester);
      await forgotPasswordScreen.verifyMessageErrorIsVisible(
          'contains at least 8 characters', tester);
      await forgotPasswordScreen.verifyMessageErrorIsVisible(
          'contains both lower (a-z) and upper case letters (A-Z)', tester);
      await forgotPasswordScreen.verifyMessageErrorIsVisible(
          'contains at least one number (0-9) and a symbol', tester);
      await htLogd(
          tester,
          'BAR_T117 User sees error message if password fields are empty',
          '',
          'FINISHED');
    });
  });
}
