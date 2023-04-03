import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:html';

const List<String> genderSignupOptions = [
  'Male',
  'Female',
  'Gender Neutral',
  'Decline to Answer',
];

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
    await tester.pumpAndSettle();
  }

  Future<void> clickSignInButton(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final viewIconFinder = find.text('Sign-in').first;
    await tapSomething(tester, viewIconFinder, addContext(context, 'click Sign-in button'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
