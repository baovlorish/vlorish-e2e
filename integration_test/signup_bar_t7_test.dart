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
          'BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
          '',
          'STARTED');
      final emailSigup = getRandomString(10) + '@gmail.com';
      await signInScreen.clickBtnSignUp(tester, context: context);
      await signUpScreen.inputEmail(emailSigup, tester, context: context);
      await signUpScreen.clickButtonNext(tester, context: context);
      await signUpScreen.inputPassword('Test1234@', tester);
      await signUpScreen.inputConfirmPassword('Test1234@', tester);
      await signUpScreen.clickAgreeAndContinueBtn(tester);
      await signUpScreen.verifySigupMailCodePage(emailSigup, tester);

      await htLogd(
          tester,
          'BAR-T7 User can enter valid password in Password fields and he is redirected on Personal Data page',
          '',
          'FINISHED');
    });
  });
}
