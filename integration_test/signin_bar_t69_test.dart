import './lib/test_lib_common.dart';
import './lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
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

      final email = getRandomString(12) + '@gmail.com';
      await htLogdDirect(
          'BAR_T69 User cannot login with an invalid email address',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(email, 'Test123', tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
          tester,
          context: context);
      await htLogd(
          tester,
          'BAR_T69 User cannot login with an invalid email address',
          '',
          'FINISHED');
    });
  });
}
