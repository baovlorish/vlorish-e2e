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
          'BAR-T17 User can make password visible and invisible after clicking on eye button',
          '',
          'STARTED');
      await signInScreen.clickBtnSignUp(tester, context: context);
      await signUpScreen.inputEmail(getRandomString(10) + '@gmail.com', tester,
          context: context);
      await signUpScreen.clickButtonNext(tester, context: context);
      await signUpScreen.inputPassword('ABV123#2', tester, context: context);
      await signUpScreen.clickEyePassword(tester, context: context);
      await signUpScreen.verifyPasswordShow('ABV123#2');
      await signUpScreen.clickEyePassword(tester, context: context);
      await signUpScreen.verifyPasswordHidden('ABV123#2');

      await signUpScreen.inputConfirmPassword('ABV123#2', tester,
          context: context);
      await signUpScreen.clickEyeConfirmPassword(tester, context: context);
      await signUpScreen.verifyConfirmPasswordShow('ABV123#2');
      await signUpScreen.clickEyeConfirmPassword(tester, context: context);
      await signUpScreen.verifyConfirmPasswordHidden('ABV123#2');
      await htLogd(
          tester,
          'BAR-T17 User can make password visible and invisible after clicking on eye button',
          '',
          'FINISHED');
    });
  });
}
