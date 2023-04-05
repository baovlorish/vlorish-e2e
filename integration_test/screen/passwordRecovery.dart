// ignore_for_file: avoid_field_initializers_in_const_classes, avoid_relative_lib_imports

import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import '../lib/test_lib_common.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter_test/flutter_test.dart';

final newPassword = 'Hello@1234';
final codeIsIncorrectErrorMsg = 'Please re-enter or have a new one sent to you.';
final passwordRecoveryTitle = 'Password Recovery';
final passwordRecoveryDescription = 'Enter the email address associated with your account';
final verifyAndSetPasswordTitle = 'Verify & set password';
final verifyAndSetPasswordDescription =
    'Enter the 6 digit code that was sent to your email and set new password';
final recoverMyPasswordBtn = 'Recover my password';
final saveMyNewPasswordBtn = 'Save my new password';
final newPasswordText = 'New password';
final confirmNewPasswordText = 'Confirm your new password';
final confirmpasswordText = 'Confirm password';
final cancelBtn = 'Cancel';
final continueBtn = 'Continue';
final backBtn = 'Back';
final resentBtn = 'Resent';
final didNotGetCodeDescription = "Didn't get the code?";
final success = 'Success!';
final codeWasSentToYourEmail = 'Code was sent to your email';
final emailDoesntExistErrorMsg =
    'There is no user with such an email. Please check if the email is correct and try again';
final containsAtLeast8CharactersMsg = 'contains at least 8 characters';
final containsBothLowerAndUpperCaseLettersMsg =
    'contains both lower (a-z) and upper case letters (A-Z)';
final containsAtLeastOneNumberAndASymbolMsg = 'contains at least one number (0-9) and a symbol';
final passwordDontMatchMsg = 'Passwords do not match. Please re-enter the password.';

class PasswordRecoveryScreenTest {
  const PasswordRecoveryScreenTest(this.tester);

  final WidgetTester tester;
  final invalidEmailErorMsg =
      'Please enter a valid email address. Valid email address example: nameofthemail@mail.com';

  Future<void> verifyShowPasswordRecoveryPage(WidgetTester tester, {String context = ''}) async {
    await htExpect(tester, find.text(passwordRecoveryTitle), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$passwordRecoveryTitle title is visible'));
    await htExpect(tester, find.text(passwordRecoveryDescription), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$passwordRecoveryDescription is visible'));
    final emailfinder = find.descendant(of: find.text('Email'), matching: find.byType(TextField));
    final emailInput = tester.firstWidget<TextField>(emailfinder);
    expect(emailInput.obscureText, false);
    await htExpect(tester, emailInput, findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Email input field is visible'));
    await htExpect(tester, find.text(recoverMyPasswordBtn), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$recoverMyPasswordBtn button is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> clickButton(String buttonName, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final viewIconFinder = find.text(buttonName).first;
    await tapSomething(tester, viewIconFinder, addContext(context, 'click $buttonName button'));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailUser, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await writeSomething(tester, email, emailUser, addContext(context, 'Input email'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputConfirmCodeEmail(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Tap on the center of the OTPTextField widget
    final otpFieldRect = tester.getRect(find.byType(OTPTextField));
    final otpFieldCenter = otpFieldRect.center;
    await tester.tapAt(otpFieldCenter);

    // Check if another widget is obscuring the OTPTextField widget
    final hitTestResult = tester.hitTestOnBinding(otpFieldCenter);
    for (final hitTestEntry in hitTestResult.path) {
      print('Hit: ${hitTestEntry.target.runtimeType}');
    }
    // Check if another widget is obscuring the OTPTextField widget
    // await tester.scrollUntilVisible(otpField, 100);

    await tester.pumpAndSettle(const Duration(seconds: 10));

    // final code = find.byType(OTPTextField);
    // // find.descendant(of: find.byType(OTPTextField), matching: find.byType(AnimatedContainer));
    // tester.printToConsole('code: -------- $code');
    // await tester.tap(code);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.enterText(find.byType(OTPTextField), '123456');
    // await writeSomething(
    //     tester, code, getRandomNumber(6), addContext(context, 'Input code set new password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputNewPassword(String password, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final passwordFinder = find.byType(InputItem).first;
    await writeSomething(tester, passwordFinder, password, addContext(context, 'Input email'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputConfirmYourNewPassword(String password, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final passwordFinder = find.byType(InputItem).last;
    await writeSomething(tester, passwordFinder, password, addContext(context, 'Input email'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyShowMessage(String msg, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ('Verify-' + context + '-' + msg + ' is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordShow(String pass, WidgetTester tester, {String context = ''}) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    await htExpect(tester, find.text(pass), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Password show text is visible'));
  }

  Future<void> verifyPasswordHidden(String pass, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    await htExpect(tester, input.obscureText, true,
        reason: ('Verify-' + context + '-' + 'Password show text is NOT visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyShowVerifyAndSetPasswordPage(WidgetTester tester,
      {String context = ''}) async {
    await htExpect(tester, find.text(verifyAndSetPasswordTitle), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$verifyAndSetPasswordTitle title is visible'));
    await htExpect(tester, find.text(verifyAndSetPasswordDescription), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$verifyAndSetPasswordDescription is visible'));
    await htExpect(tester, find.byType(OTPTextField), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'OTP code is visible'));
    await htExpect(tester, find.text(didNotGetCodeDescription), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$didNotGetCodeDescription text is visible'));
    await htExpect(tester, find.text(resentBtn), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$resentBtn button is visible'));
    final newpasswordfinder =
        find.descendant(of: find.text(newPasswordText), matching: find.byType(TextField));
    final newpasswordInput = tester.firstWidget<TextField>(newpasswordfinder);
    expect(newpasswordInput.obscureText, false);
    await htExpect(tester, newpasswordInput, findsOneWidget,
        reason: ('Verify-' + context + '-' + '$newPasswordText input field is visible'));
    final confirmNewpasswordfinder =
        find.descendant(of: find.text(confirmNewPasswordText), matching: find.byType(TextField));
    final confirmNewpasswordInput = tester.firstWidget<TextField>(confirmNewpasswordfinder);
    expect(confirmNewpasswordInput.obscureText, false);
    await htExpect(tester, confirmNewpasswordInput, findsOneWidget,
        reason: ('Verify-' + context + '-' + '$confirmNewPasswordText input field is visible'));
    await htExpect(tester, find.text(recoverMyPasswordBtn), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$recoverMyPasswordBtn button is visible'));
    await htExpect(tester, find.text(backBtn), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$backBtn button is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyMessageForPasswordIsVisible(String msg, WidgetTester tester,
      {String context = ''}) async {
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
}
