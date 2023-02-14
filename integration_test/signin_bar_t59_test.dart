import './lib/test_lib_common.dart';
import './lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
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

      final email = getRandomString(12) + '@gmail.com';
      await htLogdDirect(
          'BAR_T59 User cannot login with password that does not match with the email of user',
          '',
          'STARTED');
      await signInScreen.inputEmailAndPassword(email, 'test123!ABC', tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'There is no user with such an email. Please check if the email is correct and try again',
          tester,
          context: context);
      await htLogd(
          tester,
          'BAR_T59 User cannot login with password that does not match with the email of user',
          '',
          'FINISHED');
    });
  });
}
