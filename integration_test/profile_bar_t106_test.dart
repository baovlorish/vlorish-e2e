import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/profile.dart';

const String testDescription = 'Profile Page Test';

void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Profile Page', () {
    testWidgets('Profile Detail test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      await htLogdDirect(
          'BAR_T106 User can enter max 128 characters in Password fields',
          '',
          'STARTED');
      final pass128 =
          'Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#';
      final passGreaterThan128 =
          'Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#Test128#9';
      await dashboardScreen.clickProfileIcon(tester);
      await profileScreen.verifyProfilePage(tester);
      await profileScreen.inputUpdatePassword(
          passLogin, passGreaterThan128, tester);
      await profileScreen.clickEyePassword(1, tester);
      await profileScreen.verifyNewPasswordMax128Char(
          pass128, passGreaterThan128, tester);
      await htLogd(
          tester,
          'BAR_T106 User can enter max 128 characters in Password fields',
          '',
          'FINISHED');
    });
  });
}
