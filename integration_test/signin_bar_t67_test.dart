import './lib/test_lib_common.dart';
import './lib/function_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/signin.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      context = context ?? '';

      final email = getRandomString(12) + '@gmail.com';
      await htLogdDirect(
          'BAR-T67 User can edit visible password', '', 'STARTED');

      await signInScreen.inputEmailAndPassword(email, 'test123!ABC', tester,
          context: context);
      await signInScreen.clickEyePassword(tester, context: context);
      await signInScreen.verifyPasswordShow('test123!ABC');
      await signInScreen.inputEmailAndPassword(email, '123', tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await signInScreen.verifyErrorMessage(
          'Password should contain at least 8 characters, max 128 characters and should contain at least: 1 special char, 1 number, 1 uppercase, 1 lowercase',
          tester,
          context: context);
      await htLogd(
          tester, 'BAR-T67 User can edit visible password', '', 'FINISHED');
    });
  });
}
