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

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      // final originalOnError = FlutterError.onError!;
      // FlutterError.onError = (FlutterErrorDetails details) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      context = context ?? '';

      try {
        await htLogdDirect(
            'BAR-T67 User can edit visible password', '', 'STARTED');
        await dashboardScreen.clickLogoText();
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', 'test123!ABC', tester,
            context: context);
        await signInScreen.clickEyePassword(tester, context: context);
        await signInScreen.verifyPasswordShow('test123!ABC');
        await signInScreen.inputEmailAndPassword(
            'farah.ali1021aa@gmail.com', '123', tester,
            context: context);
        await signInScreen.clickLoginButton(tester, context: context);
        await signInScreen.verifyErrorMessage(
            'Password should contain at least 8 characters, max 128 characters and should contain at least: 1 special char, 1 number, 1 uppercase, 1 lowercase',
            tester,
            context: context);
        await htLogd(
            tester, 'BAR-T67 User can edit visible password', '', 'FINISHED');
      } catch (e) {
        await htLogd(tester, 'Error BAR-T67 User can edit visible password', '',
            'FINISHED');
      }
    });
  });
}
