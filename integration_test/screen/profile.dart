import 'dart:math';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_layout.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/test_lib_common.dart';

class ProfileScreenTest {
  const ProfileScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyProfileDetailtPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text('Personal Details'), findsOneWidget,
        reason:
            ('Verify-' + context + '-' + 'Personal Details Title is visible'));
    await htExpect(tester, find.text('First Name'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'First Name text is visible'));
    await htExpect(tester, find.text('Date of birth'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Date of birth text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickProfileDetailsButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final profileButton = find.widgetWithText(Label, 'Profile details');
    await tapSomething(tester, profileButton,
        addContext(context, 'Click on btn Profile Details'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputUpdateName(
      String firstName, String lastName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final first = find.byType(InputItem).at(0);
    final last = find.byType(InputItem).at(1);
    await writeSomething(
        tester, first, firstName, addContext(context, 'Input First Name'));
    await writeSomething(
        tester, last, lastName, addContext(context, 'Input Last Name'));
    await tester.pumpAndSettle(const Duration(seconds: 20));
  }

  Future<void> verifyNameUpdate(
      String firstName, String lastName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(firstName), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'First Name is visible'));
    await htExpect(tester, find.text(lastName), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Last Name text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickUpdateProfileButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final updateButton = find.text('Update');
    await tapSomething(tester, updateButton,
        addContext(context, 'Click on btn Update Profile Button'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputUpdatePassword(
      String oldPassword, String newPassord, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final oldPass = find.byType(InputItem).at(0);
    final newPass = find.byType(InputItem).at(1);
    await writeSomething(tester, oldPass, oldPassword,
        addContext(context, 'Input Old Password'));
    await writeSomething(
        tester, newPass, newPassord, addContext(context, 'Input New Password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickUpdatePasswordButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final updateButton = find.text('Update password');
    // await tester.tap(updateButton);
    await tapSomething(tester, updateButton,
        addContext(context, 'Click on btn Update Password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickContinueButton(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 20));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ('Verify-' + context + '-' + msg + ' text is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 15));
    final continueBtn = find.text('Continue');
    await tapSomething(
        tester, continueBtn, addContext(context, 'Click on btn Update'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickBackButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnBackIcon = find.byType(CustomBackButton);
    await tapSomething(
        tester, btnBackIcon, addContext(context, 'Click on btn BackIcon'));
    await tester.pumpAndSettle();
  }

  Future<void> clickEyePassword(int index, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).at(index);
    await tapSomething(tester, btnNext, addContext(context, 'Click on Eye'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordShow(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    final findtext = find.text(pass);
    await htExpect(tester, findtext, findsOneWidget,
        reason: ('Verify-' + context + '- Show Password text is visible'));
  }

  Future<void> verifyPasswordHidden(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    final findtext = find.text(pass);
    await htExpect(tester, findtext, findsNothing,
        reason: ('Verify-' + context + '- Password is invisible'));
  }

  Future<void> verifyNewPasswordMax128Char(
      String pass128, String pass129, WidgetTester tester,
      {String context = ''}) async {
    final findtext128 = find.text(pass128);
    await htExpect(tester, findtext128, findsOneWidget,
        reason: ('Verify-' + context + '- Password Max 128 Chars is visible'));
    final findtext129 = find.text(pass129);
    await htExpect(tester, findtext129, findsNothing,
        reason:
            ('Verify-' + context + '- Password Max 129 Chars is invisible'));
  }

  Future<void> verifyShowMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ('Verify-' + context + '-' + msg + ' text is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyHideMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(msg), findsNothing,
        reason: ('Verify-' + context + '-' + msg + ' text is not existing'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickPopupButton(String btnText, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 15));
    final updateButton = find.text(btnText);
    await tapSomething(tester, updateButton,
        addContext(context, 'Click on btn ' + btnText + ' Button'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickButton(String btn, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final updateButton = find.text(btn);
    // await tester.tap(updateButton);
    await tapSomething(
        tester, updateButton, addContext(context, 'Click on btn ' + btn));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> scrollThePage() async {
    final listFinder = find.byType(ProfileOverviewLayout);
    await tester.fling(listFinder, const Offset(0, 1000), 10000);
    await tester.pumpAndSettle();
  }
}
