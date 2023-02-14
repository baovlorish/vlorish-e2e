import 'dart:io';
import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
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
          'BAR-T81 User see error message if click on Next button with empty Email field',
          '',
          'STARTED');
      await signInScreen.clickForgotPassword(tester, context: context);
      await forgotPassScreen.verifyForgotPasswordPage(tester, context: context);
      await forgotPassScreen.inputEmail('');
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyErrorMessage(
          'Please, enter your email', tester,
          context: context);
      await htLogd(
          tester,
          'BAR-T81 User see error message if click on Next button with empty Email field',
          '',
          'FINISHED');
    });
  });
}
