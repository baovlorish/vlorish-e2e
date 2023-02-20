import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/signup.dart';

const String testDescription = 'SignUp';
void main() async {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignUp Page', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      context = context ?? '';

      await htLogdDirect(
          'BAR-T4 User sees error message if Email field is empty',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.clickBtnSignUp(tester);
      await signUpScreen.inputEmail('', tester);
      await signUpScreen.clickButtonNext(tester);
      await signUpScreen.verifyErrorMessage('Please, enter your email', tester,
          context:
              context); // Expected Results test case: Please enter your email
      await htLogd(
          tester,
          'BAR-T4 User sees error message if Email field is empty',
          '',
          'FINISHED');
    });
  });
}
