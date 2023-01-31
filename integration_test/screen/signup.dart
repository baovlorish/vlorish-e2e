import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:html';

class SignUpScreenTest {
  const SignUpScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnSignIn(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Sign-in').first;
    await tapSomething(
        tester, btnSignIn, addContext(context, "click Btn SignIn"));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailUser, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await writeSomething(
        tester, email, emailUser, addContext(context, 'Input email'));
    await tester.enterText(email, emailUser);
  }

  Future<void> inputPassword(String passUser, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).first;
    await writeSomething(
        tester, pass, passUser, addContext(context, 'Input password'));
    await tester.enterText(pass, passUser);
  }

  Future<void> ClearPassword() async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).first;
    await tester.tap(pass);
    await simulateKeyDownEvent(LogicalKeyboardKey.backspace);
  }

  Future<void> inputConfirmPassword(String passUser, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).last;
    await writeSomething(
        tester, pass, passUser, addContext(context, 'Input Confirm password'));
    await tester.enterText(pass, passUser);
  }

  Future<void> verifyCurrentPassword(String passUser, WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.text(passUser), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Current password is correct'));
  }

  Future<void> verifyNotCurrentPassword(String passUser, WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final currentPass = find.byType(TextField).first;
    print(currentPass.toString());
    await htExpect(tester, currentPass.toString(), passUser,
        reason: ("Verify-" +
            context +
            "-" +
            'Current password is not this value ' +
            passUser));
  }

  Future<void> clickButtonNext(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tapSomething(tester, btnNext, addContext(context, 'click Btn Next'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickEyePassword(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).first;
    await tapSomething(tester, btnNext, addContext(context, "Click on Eye"));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordShow(String pass) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    print('password is visible');
  }

  Future<void> verifyPasswordHidden(String pass) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    print('password is invisible');
  }

  Future<void> clickEyeConfirmPassword(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).last;
    await tapSomething(tester, btnNext,
        addContext(context, "Click on Eye in confirm password"));
    await tester.pumpAndSettle();
  }

  Future<void> verifyConfirmPasswordShow(String pass) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    print('confirm password is visible');
  }

  Future<void> verifyConfirmPasswordHidden(String pass) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    print('confirm password is invisible');
  }

  Future<void> verifyErrorMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ("Verify-" + context + "-" + msg + ' is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyPasswordPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, find.text('Create a password'), findsOneWidget,
        reason: ("Verify-" + context + '- Text Create a password is visible'));
    await htExpect(tester, find.text('Password'), findsOneWidget,
        reason: ("Verify-" + context + '- Text Password is visible'));
    await htExpect(tester, find.text('Confirm Password'), findsOneWidget,
        reason: ("Verify-" + context + '- Text Confirm Password is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickAgreeAndContinueBtn(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnAgree = find.text('Agree & Continue').first;
    await tester.ensureVisible(btnAgree);
    await tapSomething(
        tester, btnAgree, addContext(context, 'click Btn Agree & Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickAndVerifyTermLink(String homeURL, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final termUrl = find.text('Terms').first;
    await tapSomething(tester, termUrl, addContext(context, 'click Term link'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    var currentUrl = Uri.base.toString();
    print(currentUrl);
    await htExpect(tester, homeURL + '#/terms_and_conditions', currentUrl,
        reason: ("Verify-" + context + '-Link terms_and_conditions is called'));
  }

  Future<void> clickAndVerifyPrivacyLink(String homeURL, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    final privacyLink = find.text('Privacy Policy').first;
    await tapSomething(
        tester, privacyLink, addContext(context, 'click Privacy link'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    var currentUrl = Uri.base.toString();
    print(currentUrl);
    await htExpect(tester, homeURL + '#/privacy_policy', currentUrl,
        reason: ("Verify-" + context + '-Link Privacy Policy is called'));
  }

  Future<void> verifySignUpPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    expect(find.text('Please enter your email address to create an account'),
        findsOneWidget);
    await htExpect(
        tester,
        find.text('Please enter your email address to create an account'),
        findsOneWidget,
        reason: ("Verify-" +
            context +
            '- Text Please enter your email address to create an account is visible'));
  }
}
