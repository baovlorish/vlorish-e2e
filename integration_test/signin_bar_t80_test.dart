import './lib/test_lib_common.dart';
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

      await htLogdDirect(
          'BAR_T80 User can leave Forgot Password window by tapping back button',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickForgotPassword(tester, context: context);
      await dashboardScreen.clickBack();
      await signInScreen.verifySignInPage(tester, context: context);
      await htLogd(
          tester,
          'BAR_T80 User can leave Forgot Password window by tapping back button',
          '',
          'FINISHED');
    });
  });
}
