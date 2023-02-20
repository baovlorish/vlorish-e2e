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
          'BAR-T91 User sees error message and can not recover password if password does not contain 1 special char',
          '',
          'STARTED');
      await signInScreen.clickForgotPassword(tester, context: context);
      await forgotPassScreen.verifyForgotPasswordPage(tester, context: context);
      await forgotPassScreen.inputEmail(emailLogin);
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
      await forgotPassScreen.inputPasswordinConfirmEmailScreen('test12345');
      await forgotPassScreen
          .inputConfirmPasswordinConfirmEmailScreen('test12345');
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyMessageErrorIsVisible(
          'contains at least one number (0-9) and a symbol', tester,
          context: context);
      await htLogd(
          tester,
          'BAR-T91 User sees error message and can not recover password if password does not contain 1 special char',
          '',
          'FINISHED');
    });
  });
}
