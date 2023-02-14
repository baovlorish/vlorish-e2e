import './lib/test_lib_common.dart';
import './lib//function_common.dart';
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
          'BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button',
          '',
          'STARTED');
      await signInScreen.clickBtnSignUp(tester);
      await signUpScreen.inputEmail(getRandomString(10) + '@gmail.com', tester,
          context: context);
      await signUpScreen.clickButtonNext(tester, context: context);
      await signUpScreen.inputPassword('', tester, context: context);
      await signUpScreen.inputConfirmPassword('', tester, context: context);
      await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
      await signUpScreen.verifyErrorMessage(
          'Please enter your password', tester);
      await signUpScreen.verifyErrorMessage(
          'Please confirm your password', tester);
      await htLogd(
          tester,
          'BAR-T8 User see error message if Password fields are empty after clicking “Agree & Continue” button',
          '',
          'FINISHED');
    });
  });
}
