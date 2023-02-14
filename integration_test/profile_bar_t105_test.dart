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
          'BAR_T105 User can make password invisible after clicking on “eye” button if password is visible',
          '',
          'STARTED');
      await dashboardScreen.clickProfileIcon(tester);
      await profileScreen.verifyProfilePage(tester);
      await profileScreen.inputUpdatePassword(passLogin, '', tester);
      await profileScreen.clickEyePassword(0, tester);
      await profileScreen.verifyPasswordShow(passLogin, tester);
      await profileScreen.clickEyePassword(0, tester);
      await profileScreen.verifyPasswordHidden(passLogin, tester);

      await htLogd(
          tester,
          'BAR_T105 User can make password invisible after clicking on “eye” button if password is visible',
          '',
          'FINISHED');
    });
  });
}
