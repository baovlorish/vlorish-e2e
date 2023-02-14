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
          'BAR-T9 User see error message if Confirm Password fields is empty',
          '',
          'STARTED');
      await signInScreen.clickBtnSignUp(tester, context: context);
      await signUpScreen.inputEmail(getRandomString(10) + '@gmail.com', tester,
          context: context);
      await signUpScreen.clickButtonNext(tester, context: context);
      await signUpScreen.inputPassword('Test124\$', tester, context: context);
      await signUpScreen.inputConfirmPassword('', tester, context: context);
      await signUpScreen.clickAgreeAndContinueBtn(tester, context: context);
      await signUpScreen.verifyErrorMessage(
          'Please confirm your password', tester);
      await htLogd(
          tester,
          'BAR-T9 User see error message if Confirm Password fields is empty',
          '',
          'FINISHED');
    });
  });
}
