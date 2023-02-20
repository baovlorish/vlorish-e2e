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
          'BAR-T5 Sign In page is displayed after click on "Sign In" button on the Sign Up page',
          '',
          'STARTED');
      await signInScreen.clickBtnSignUp(tester);
      await signUpScreen.verifySignUpPage(tester);
      await signUpScreen.clickBtnSignIn(tester);
      await signInScreen.verifySignInPage(tester);
      await htLogd(
          tester,
          'BAR-T5 Sign In page is displayed after click on "Sign In" button on the Sign Up page',
          '',
          'FINISHED');
    });
  });
}
