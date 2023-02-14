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
      String homeURL = Uri.base.toString();

      await htLogdDirect(
          'BAR-T11 User is redirected on Privacy page after clicking on Privacy link',
          '',
          'STARTED');
      await signInScreen.clickBtnSignUp(tester, context: context);
      await signUpScreen.inputEmail(getRandomString(10) + '@gmail.com', tester,
          context: context);
      await signUpScreen.clickButtonNext(tester, context: context);
      await signUpScreen.clickAndVerifyPrivacyLink(homeURL, tester,
          context: context);
      await htLogd(
          tester,
          'BAR-T11 User is redirected on Privacy page after clicking on Privacy link',
          '',
          'FINISHED');
    });
  });
}
