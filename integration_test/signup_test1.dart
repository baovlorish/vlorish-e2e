import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'screen/dashboard.dart';
import 'screen/fileReport.dart';
import 'screen/forgotPassword.dart';
import 'screen/signin.dart';
import 'screen/signup.dart';

const String testDescription = 'SignUp';
void main() async {
  SignInScreenTest signInScreen;
  SignUpScreenTest signUpScreen;
  DashboardScreenTest dashboardScreen;
  ForgotPasswordScreenTest forgotPassScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignUp Page', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      signUpScreen = SignUpScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      forgotPassScreen = ForgotPasswordScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'BAR-T2 User sees error message if enter an invalid email',
            '',
            'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.clickBtnSignUp(tester, context: context);
        await signUpScreen.inputEmail('test', tester, context: context);
        await signUpScreen.clickButtonNext(tester, context: context);
        await signUpScreen.verifyErrorMessage(
            'Please enter a valid email address. Valid email address example: nameofthemail@mail.com',
            tester,
            context: context);
        await htLogd(
            tester,
            'BAR-T2 User sees error message if enter an invalid email',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T2 User sees error message if enter an invalid email',
            '',
            'FINISHED');
      }
    });
  });
}
