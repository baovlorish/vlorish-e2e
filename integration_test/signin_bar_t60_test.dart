import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/test_lib_const.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      context = context ?? '';

      await htLogdDirect(
          'BAR_T60 User sees error message after entering incorrect password 2 times',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(
          emailLogin, 'Test1@123456', tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'There is no user with such an email. Please check if the email is correct and try again',
          tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'The password is incorrect. Please check the password and try again. You have got 3 more attempts',
          tester,
          context:
              context); // status is pending, will check again after enable to connect DB
      await htLogd(
          tester,
          'BAR_T60 User sees error message after entering incorrect password 2 times',
          '',
          'FINISHED');
    });
  });
}
