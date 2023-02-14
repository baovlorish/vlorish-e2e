import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/test_lib_const.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/personalBudget.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  PersonalBudgetScreenTest personalBudgetScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = PersonalBudgetScreenTest(tester);
      context = context ?? '';

      await htLogdDirect(
          'BAR_T52 User can login by correct Email and correct password',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);
      await dashboardScreen.clickLogoutButton(tester);
      await htLogd(
          tester,
          'BAR_T52 User can login by correct Email and correct password',
          '',
          'FINISHED');
    });
  });
}
