import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import './lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/personalBudget.dart';
import 'screen/profile.dart';

const String testDescription = 'Profile Page Test';
var fName = getRandomString(10);
var lName = getRandomString(10);
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
          'BAR_T98 Check that user can update “First Name” and “Last Name” fields',
          '',
          'STARTED');

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);
      await dashboardScreen.clickProfileIcon(tester);
      await profileScreen.verifyProfilePage(tester);
      await profileScreen.clickProfileDetailsButton(tester);
      await profileScreen.verifyProfileDetailtPage(tester);
      await profileScreen.inputUpdateName(fName, lName, tester);
      await profileScreen.clickUpdateProfileButton(tester);
      await profileScreen.clickContinueButton('Success!', tester);
      await profileScreen.clickBackButton(tester);
      await dashboardScreen.clickProfileIcon(tester);
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
    });
  });
}
