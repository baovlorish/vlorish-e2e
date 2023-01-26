import 'dart:html';

import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

class ForgotPasswordScreenTest {
  const ForgotPasswordScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnNext() async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tester.tap(btnNext);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailValue) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
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

  Future<void> verifyForgotPasswordPage() async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    expect(find.text('Password Recovery'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(ButtonItem, 'Next'));
    final email = find.text('Email').first;
    await tester.ensureVisible(email);
  }

  Future<void> verifyConfirmEmailPage() async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    expect(find.text('Confirm your email'), findsOneWidget);
    expect(find.text('Create a new password'), findsOneWidget);
  }

  Future<void> verifyErrorMessage(String msg) async {
    expect(find.text(msg), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyMessageErrorIsVisible(String msg) async {
    final text = tester.widget<Text>(find.text(msg));
    expect(text.style?.color, CustomColorScheme.inputErrorBorder);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
