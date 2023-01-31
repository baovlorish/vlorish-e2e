import 'dart:html';
import '../lib/test_lib_common.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

class ForgotPasswordScreenTest {
  const ForgotPasswordScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnNext(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tapSomething(tester, btnNext, addContext(context, 'click Next Btn'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailValue) async {
    await tester.pumpAndSettle();
    final emailInput = find.byType(InputItem).first;
    await tester.tap(emailInput);
    await tester.enterText(emailInput, emailValue);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputPasswordinConfirmEmailScreen(String password) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final passwordInput = find.byType(InputItem).at(1);
    await tester.tap(passwordInput);
    await tester.enterText(passwordInput, password);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputConfirmPasswordinConfirmEmailScreen(String password) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final cfPasswordInput = find.byType(InputItem).last;
    await tester.tap(cfPasswordInput);
    await tester.enterText(cfPasswordInput, password);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyForgotPasswordPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.text('Password Recovery'), findsOneWidget,
        reason: ("Verify-" + context + '- Password Recovery is visible'));
    await tester.ensureVisible(find.widgetWithText(ButtonItem, 'Next'));
    await htExpect(
        tester, find.widgetWithText(ButtonItem, 'Next'), findsOneWidget,
        reason: ("Verify-" + context + '- Next Button is visible'));
    final email = find.text('Email').first;
    await tester.ensureVisible(email);
    await htExpect(tester, email, findsOneWidget,
        reason: ("Verify-" + context + '- Text Email is visible'));
  }

  Future<void> verifyConfirmEmailPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.text('Confirm your email'), findsOneWidget,
        reason: ('Verify-' + context + '- Password Recovery is visible'));
    await htExpect(tester, find.text('Create a new password'), findsOneWidget,
        reason: ('Verify-' + context + '- Password Recovery is visible'));
  }

  Future<void> verifyErrorMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ("Verify-" + context + "-" + msg + ' is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyMessageErrorIsVisible(String msg) async {
    final text = tester.widget<Text>(find.text(msg));
    expect(text.style?.color, CustomColorScheme.inputErrorBorder);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
