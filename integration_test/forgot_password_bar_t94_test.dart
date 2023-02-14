import 'dart:io';
import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/test_lib_const.dart';
import 'screen/forgotPassword.dart';
import 'screen/signin.dart';

const String testDescription = 'Forgot Password';

void main() async {
  SignInScreenTest signInScreen;
  ForgotPasswordScreenTest forgotPassScreen;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('Forgot Password test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);
      context = context ?? '';

      await htLogdDirect(
          'BAR-T94 User sees error message and can not recover password if password does not contain 1 lowercase',
          '',
          'STARTED');
      await signInScreen.clickForgotPassword(tester, context: context);
      await forgotPassScreen.verifyForgotPasswordPage(tester, context: context);
      await forgotPassScreen.inputEmail(emailLogin);
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
      await forgotPassScreen.inputPasswordinConfirmEmailScreen('TESTPASSWORD');
      await forgotPassScreen
          .inputConfirmPasswordinConfirmEmailScreen('TESTPASSWORD');
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyMessageErrorIsVisible(
          'contains both lower (a-z) and upper case letters (A-Z)', tester,
          context: context);
      await htLogd(
          tester,
          'BAR-T94 User sees error message and can not recover password if password does not contain 1 lowercase',
          '',
          'FINISHED');
    });
  });
}
