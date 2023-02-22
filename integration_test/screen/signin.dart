import 'dart:math';

import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/test_lib_common.dart';

class SignInScreenTest {
  const SignInScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnSignUp(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Sign-up').first;
    await tapSomething(
        tester, btnSignIn, addContext(context, "click Btn SignUp"));
  }

  Future<void> inputEmail(String emailUser, WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await writeSomething(
        tester, email, emailUser, addContext(context, "Input email"));
  }

  Future<void> clickBtnNext(WidgetTester tester, {String context = ""}) async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tapSomething(tester, btnNext, addContext(context, "click Btn Next"));
  }

  Future<void> verifyErrorMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ("Verify-" + context + "-" + msg + ' is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordPage(String msg, WidgetTester tester,
      {String context = ""}) async {
    await htExpect(tester, find.text('Create a password'), findsOneWidget,
        reason:
            ("Verify-" + context + "-" + 'Create a password text is visible'));
    await htExpect(tester, find.text('Password'), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Password'));
    await htExpect(tester, find.text('Confirm Password'), findsOneWidget,
        reason:
            ("Verify-" + context + "-" + 'Confirm Password text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> inputEmailAndPassword(
      String emailUser, String passUser, WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;
    await writeSomething(
        tester, email, emailUser, addContext(context, "Input email"));
    await writeSomething(
        tester, password, passUser, addContext(context, "Input password"));
    await tester.pumpAndSettle();
  }

  Future<void> clickLoginButton(WidgetTester tester,
      {String context = ""}) async {
    final btnSubmit = find.text('Sign-in').first;
    await tapSomething(
        tester, btnSubmit, addContext(context, "Click Btn Submit"));
    await tester.pumpAndSettle();
  }

  Future<void> verifySignInPage(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    await htExpect(
        tester, find.widgetWithText(ButtonItem, 'Sign-in'), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Sign-in text is visible'));
    await tester.ensureVisible(find.widgetWithText(ButtonItem, 'Sign-in'));
    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;
    await tapSomething(
        tester, email, addContext(context, "Email is available"));
    await tapSomething(
        tester, password, addContext(context, "password is available"));
  }

  Future<void> clickEyePassword(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).first;
    await tapSomething(tester, btnNext, addContext(context, "Click on Eye"));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordShow(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    await htExpect(tester, find.text(pass), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Password show text is visible'));
  }

  Future<void> verifyPasswordHidden(String pass, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    await htExpect(tester, input.obscureText, true,
        reason:
            ("Verify-" + context + "-" + 'Password show text is NOT visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickForgotPassword(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final btnForgotPass = find.text('Forgot Password').first;
    await tapSomething(tester, btnForgotPass,
        addContext(context, "Click on btn Forgot password"));
    await tester.pumpAndSettle();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
