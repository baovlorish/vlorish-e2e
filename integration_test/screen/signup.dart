// ignore_for_file: avoid_relative_lib_imports

import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import '../lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';

const List<String> genderSignupOptions = [
  'Male',
  'Female',
  'Gender Neutral',
  'Decline to Answer',
];
final createAccountTitle = 'Create account';
final createAccountDescription = 'Add email and create a secure password';

class SignUpScreenTest {
  const SignUpScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyShowSignupPage(WidgetTester tester, {String context = ''}) async {
    await htExpect(tester, find.text('Welcome to Vlorish'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Welcome to Vlorish title is visible'));
    await htExpect(
        tester, find.text('Please enter your email address to create an account'), findsOneWidget,
        reason: ('Verify-' +
            context +
            '-' +
            'Please enter your email address to create an account is visible'));
    await htExpect(tester, find.text('Do you have an account already? '), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Do you have an account already? text is visible'));
    await htExpect(tester, find.text('Sign-in'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Sign-in link is visible'));
    await htExpect(tester, find.text('Next'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Next button is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickSignInButton(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final viewIconFinder = find.text('Sign-in').first;
    await tapSomething(tester, viewIconFinder, addContext(context, 'click Sign-in button'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyShowInputField(String inputName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final textFormFieldFinder = find.descendant(
        of: find.ancestor(of: find.text(inputName), matching: find.byType(InputItem)),
        matching: find.byType(TextFormField));

    await htExpect(tester, textFormFieldFinder, findsOneWidget,
        reason: ('Verify-' + context + '-' + '$inputName input field is visible'));
  }

  Future<void> inputEmail(String emailUser, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await writeSomething(tester, email, emailUser, addContext(context, 'Input email'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputPassword(String inputPassword, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final textFormFieldFinder = find.descendant(
        of: find.ancestor(of: find.text('Password'), matching: find.byType(InputItem)),
        matching: find.byType(TextFormField));
    await writeSomething(
        tester, textFormFieldFinder, inputPassword, addContext(context, 'Input password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputConfirmPassword(String inputConfirmPassword, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final textFormFieldFinder = find.descendant(
        of: find.ancestor(of: find.text('Confirm Password'), matching: find.byType(InputItem)),
        matching: find.byType(TextFormField));
    await writeSomething(tester, textFormFieldFinder, inputConfirmPassword,
        addContext(context, 'Input confirm password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickButton(String buttonName, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final viewIconFinder = find.text(buttonName).first;
    await tapSomething(tester, viewIconFinder, addContext(context, 'click $buttonName button'));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyShowSignupPasswordPage(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.text('Create a password'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Create a password title is visible'));
    await verifyShowInputField('Password', tester);
    await verifyShowInputField('Confirm Password', tester);
    await htExpect(tester, find.text('Agree & Continue'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Agree & Continue button is visible'));
    final termsPrivacyPolicy = find.widgetWithText(Wrap,
        'By clicking Agree & Continue, you agree to the Terms and confirm that you have read Privacy Policy');
    await htExpect(tester, termsPrivacyPolicy, findsOneWidget,
        reason: ('Verify-' +
            context +
            '-' +
            'By clicking Agree & Continue, you agree to the Terms and confirm that you have read Privacy Policy is visible'));
    await htExpect(tester, find.text('Do you have an account already? '), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Do you have an account already? text is visible'));
    await htExpect(tester, find.text('Sign-in'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Sign-in link is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyMessageForPasswordIsVisible(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final text = tester.widget<Text>(find.text(msg));
    expect(text.style?.color, equals(const Color(0xff62b999)));
    await htExpect(tester, text.style?.color, equals(const Color(0xff62b999)),
        reason: ('Verify-' + context + '$msg text is green is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyMessageErrorIsVisible(String msg, WidgetTester tester,
      {String context = ''}) async {
    final text = tester.widget<Text>(find.text(msg));
    expect(text.style?.color, equals(const Color(0xffbb1639)));
    await htExpect(tester, text.style?.color, equals(const Color(0xffbb1639)),
        reason: ('Verify-' + context + '$msg error text is red is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyShowText(String txt, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(txt), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$txt is visible'));
    await tester.pumpAndSettle();
  }
}
