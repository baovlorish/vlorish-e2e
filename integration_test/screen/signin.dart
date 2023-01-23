import 'dart:math';

import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SignInScreenTest {
  const SignInScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnSignUp() async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Sign-up').first;
    await tester.tap(btnSignIn);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailUser) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await tester.enterText(email, emailUser);
  }

  Future<void> clickBtnNext() async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tester.tap(btnNext);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyErrorMessage(String msg) async {
    expect(find.text(msg), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyPasswordPage() async {
    expect(find.text('Create a password'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmailAndPassword(String emailUser, String passUser) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;
    await tester.enterText(email, emailUser);
    await tester.enterText(password, passUser);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickLoginButton() async {
    final btnSubmit = find.text('Sign-in').first;
    await tester.ensureVisible(btnSubmit);
    await tester.tap(btnSubmit);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifySignInPage() async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    await tester.ensureVisible(find.widgetWithText(ButtonItem, 'Sign-in'));
    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;
    await tester.ensureVisible(email);
    await tester.ensureVisible(password);
  }

  Future<void> clickEyePassword() async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).first;
    await tester.tap(btnNext);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyPasswordShow(String pass) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    print('password is visible');
  }

  Future<void> verifyPasswordHidden(String pass) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    print('password is invisible');
  }

  Future<void> clickForgotPassword() async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnForgotPass = find.text('Forgot Password').first;
    await tester.tap(btnForgotPass);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
