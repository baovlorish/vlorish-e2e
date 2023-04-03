import 'dart:html';
import '../lib/test_lib_common.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

class PasswordRecoveryScreenTest {
  const PasswordRecoveryScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyShowPasswordRecoveryPage(WidgetTester tester, {String context = ""}) async {
    await htExpect(tester, find.text('Password Recovery'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Password Recovery title is visible'));
    await htExpect(
        tester, find.text('Enter the email address associated with your account'), findsOneWidget,
        reason: ('Verify-' +
            context +
            '-' +
            'Enter the email address associated with your account is visible'));
    await htExpect(tester, find.text('Recover my password'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Recover my password button is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickCancelButton(WidgetTester tester, {String context = ""}) async {
    await tester.pumpAndSettle();
    final viewIconFinder = find.text('Cancel').first;
    await tapSomething(tester, viewIconFinder, addContext(context, 'click Cancel button'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
