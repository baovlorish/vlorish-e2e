import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/test_lib_const.dart';
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
          'BAR-T6 User see error message on SignUp page if email is already exists in database',
          '',
          'STARTED');
      await signInScreen.clickBtnSignUp(tester, context: context);
      await signUpScreen.inputEmail(emailLogin, tester, context: context);
      await signUpScreen.clickButtonNext(tester, context: context);
      await signUpScreen.verifyErrorMessage(
          'This email has already been taken by some other user. Please try using another email address',
          tester,
          context: context);
      await htLogd(
          tester,
          'BAR-T6 User see error message on SignUp page if email is already exists in database',
          '',
          'FINISHED');
    });
  });
}
