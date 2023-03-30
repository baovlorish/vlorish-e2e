import 'dart:math';

import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/test_lib_common.dart';

class GoalsScreenTest {
  const GoalsScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnGoals(WidgetTester tester, {String context = ""}) async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Goals').first;
    await tapSomething(tester, btnSignIn, addContext(context, 'click Btn Goals'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  Future<void> clickBtnAddAGoals(WidgetTester tester, {String context = ""}) async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Add a Goal');
    await tapSomething(tester, btnSignIn, addContext(context, 'click Btn Add a Goal'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  Future<void> inputGoalName(String goalName, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final nameInput = find.byType(InputItem).at(0);
    await writeSomething(tester, nameInput, goalName, addContext(context, ''));
  }

  Future<void> clickBtnSave(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnSave = find.text('Save');
    await tapSomething(tester, btnSave, addContext(context, 'click Btn Save'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyErrorMessage(String msg, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ('Verify-' + context + '-' + msg + ' is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyShowText(String msg, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ('Verify-' + context + '-' + msg + ' is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> inputFundedAmount(String fundedAmount, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final fundedAmountInput = find.byType(InputItem).at(1);
    await writeSomething(tester, fundedAmountInput, fundedAmount, addContext(context, ''));
    await tester.pumpAndSettle();
  }

  Future<void> inputTargetAmount(String targetAmount, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final targetAmountInput = find.byType(InputItem).at(1);
    await writeSomething(tester, targetAmountInput, targetAmount, addContext(context, ''));
    await tester.pumpAndSettle();
  }
}
