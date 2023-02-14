import './lib/test_lib_common.dart';
import './lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/signin.dart';
import 'screen/signup.dart';

const String testDescription = 'SignUp';
void main() async {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignUp Page', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      context = context ?? '';

      await htLogdDirect(
          'BAR-T62 User is redirected on Sign Up flow after clicking on Sign Up button',
          '',
          'STARTED');
      await signInScreen.clickBtnSignUp(tester, context: context);
      await signUpScreen.verifySignUpPage(tester, context: context);
      await htLogd(
          tester,
          'BAR-T62 User is redirected on Sign Up flow after clicking on Sign Up button',
          '',
          'FINISHED');
    });
  });
}
