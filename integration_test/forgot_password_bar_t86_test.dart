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
          'BAR-T86 User sees error message if Password & Confirm Password fields do not match',
          '',
          'STARTED');
      await signInScreen.clickForgotPassword(tester, context: context);
      await forgotPassScreen.verifyForgotPasswordPage(tester, context: context);
      await forgotPassScreen.inputEmail(emailLogin);
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyConfirmEmailPage(tester, context: context);
      await forgotPassScreen.inputPasswordinConfirmEmailScreen('test123');
      await forgotPassScreen
          .inputConfirmPasswordinConfirmEmailScreen('test1234');
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyErrorMessage(
          'Passwords do not match. Please re-enter the password.', tester,
          context: context);
      await htLogd(
          tester,
          'BAR-T86 User sees error message if Password & Confirm Password fields don’t match',
          '',
          'FINISHED');
    });
  });
}
