import 'dart:io';
import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'lib/function_common.dart';
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
          'BAR-T78 User see error message and cannot send request for password if enters Email without local part',
          '',
          'STARTED');
      await signInScreen.clickForgotPassword(tester, context: context);
      await forgotPassScreen.verifyForgotPasswordPage(tester, context: context);
      await forgotPassScreen.inputEmail('@gmail.com');
      await forgotPassScreen.clickBtnNext(tester, context: context);
      await forgotPassScreen.verifyErrorMessage(
          'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
          tester,
          context: context);
      await htLogd(
          tester,
          'BAR-T78 User see error message and cannot send request for password if enters Email without local part',
          '',
          'FINISHED');
    });
  });
}
