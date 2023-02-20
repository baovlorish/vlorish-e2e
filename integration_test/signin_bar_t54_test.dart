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
          'BAR_T54 User cannot login with password that does not match with the email',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(
          emailLogin, 'Test1@123456', tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'The password is incorrect. Please check the password and try again',
          tester,
          context: context);
      await htLogd(
          tester,
          'BAR_T54 User cannot login with password that does not match with the email',
          '',
          'FINISHED');
    });
  });
}
