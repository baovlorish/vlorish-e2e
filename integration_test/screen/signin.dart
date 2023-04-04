import 'dart:math';

import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/test_lib_common.dart';

final letSignInText = 'Let’s sign-in';
final emailText = 'Email';
final passwordText = 'Password';
final forgotPasswordText = 'Forgot Password';
final signinBtn = 'Sign-in';
final signupBtn = 'Sign-up';
final invalidEmailErorMsg =
    'Please enter a valid email address. Valid email address example: nameofthemail@mail.com';
final unregisteredEmailErrorMsg =
    'There is no user with such an email. Please check if the email is correct and try again';
final emptyEmailMsg = 'Please, enter your email';
final emptyPasswordMsg = 'Please enter your password';
final incorrectPasswordErrMsg =
    'The password is incorrect. Please check the password and try again';
final wrongPasswordFomatErrMsg =
    'Password should contain at least 8 characters, max 128 characters and should contain at least: 1 special char, 1 number, 1 uppercase, 1 lowercase';

class SignInScreenTest {
  const SignInScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyShowSignInPage(WidgetTester tester, {String context = ''}) async {
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;

    await htExpect(tester, find.text(letSignInText), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$letSignInText Title is visible'));
    await htExpect(tester, find.text(emailText), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$emailText text is visible'));
    await tapSomething(tester, email, addContext(context, 'Email input is available'));
    await htExpect(tester, find.text(passwordText), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$passwordText text is visible'));
    await tapSomething(tester, password, addContext(context, 'Password input is available'));
    await htExpect(tester, find.text(forgotPasswordText), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$forgotPasswordText is visible'));
    await htExpect(tester, find.text(signinBtn), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$signinBtn is visible'));
    await htExpect(tester, find.text(signupBtn), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$signupBtn is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputAndVerifyInputField(String inputName, String textInput, WidgetTester tester,
      {String context = ''}) async {
    final inputFinder = find.ancestor(
      of: find.text(inputName),
      matching: find.byType(InputItem),
    );

    final inputFormFieldFinder = find.descendant(
      of: inputFinder,
      matching: find.byType(TextFormField),
    );

    if (textInput != '') {
      await writeSomething(
          tester, inputFormFieldFinder, textInput, addContext(context, 'Input $inputName'));
    } else {
      await htExpect(tester, inputFormFieldFinder, findsOneWidget,
          reason: ('Verify-' + context + '-' + '$inputName field is visible'));
    }

    await tester.pumpAndSettle();
  }

  Future<void> verifyViewIcon(bool isShowPassword, WidgetTester tester,
      {String context = ''}) async {
    AssetImage assetImage;

    if (isShowPassword == true) {
      assetImage = AssetImage('assets/images/icons/trailing_open.png');
    } else {
      assetImage = AssetImage('assets/images/icons/trailing.png');
    }

    final imageIconFinder = find.byWidgetPredicate((widget) {
      if (widget is ImageIcon) {
        if (widget.image is AssetImage && widget.image == assetImage) {
          return true;
        }
      }
      return false;
    });

    if (isShowPassword == true) {
      await htExpect(tester, imageIconFinder, findsOneWidget,
          reason: ('Verify-' + context + '-' + 'View password icon is visible'));
    } else {
      await htExpect(tester, imageIconFinder, findsOneWidget,
          reason: ('Verify-' + context + '-' + 'Hide password icon is visible'));
    }

    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickEyePassword(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(IconButton).first;
    await tapSomething(tester, btnNext, addContext(context, 'Click on Eye'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickForgotPassword(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text(forgotPasswordText).first;
    await tapSomething(tester, btnSignIn, addContext(context, 'click button $forgotPasswordText'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailUser, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await writeSomething(tester, email, emailUser, addContext(context, 'Input email'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputPassword(String passUser, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final password = find.byType(InputItem).last;
    await writeSomething(tester, password, passUser, addContext(context, 'Input password'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickSignupBtn(WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text(signupBtn).first;
    await tapSomething(tester, btnSignIn, addContext(context, 'click button $signupBtn'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickSignInButton(WidgetTester tester, {String context = ''}) async {
    final btnSubmit = find.text('Sign-in').first;
    await tapSomething(tester, btnSubmit, addContext(context, 'Click button Sign-in'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyShowText(String txt, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(txt), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$txt is visible'));
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

  Future<void> verifyMessageErrorIsVisible(String msg, WidgetTester tester,
      {String context = ''}) async {
    final text = tester.widget<Text>(find.text(msg));
    expect(text.style?.color, CustomColorScheme.inputErrorBorder);
    await htExpect(tester, text.style?.color, CustomColorScheme.inputErrorBorder,
        reason: ('Verify-' + context + '-' + msg + ' error is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

//------------

  Future<void> clickBtnNext(WidgetTester tester, {String context = ""}) async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tapSomething(tester, btnNext, addContext(context, 'click Btn Next'));
  }

  Future<void> verifyErrorMessage(String msg, WidgetTester tester, {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ('Verify-' + context + '-' + msg + ' is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordPage(String msg, WidgetTester tester, {String context = ""}) async {
    await htExpect(tester, find.text('Create a password'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Create a password text is visible'));
    await htExpect(tester, find.text('Password'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Password'));
    await htExpect(tester, find.text('Confirm Password'), findsOneWidget,
        reason: ('Verify-' + context + '-' + 'Confirm Password text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> inputEmailAndPassword(String emailUser, String passUser, WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;
    await writeSomething(tester, email, emailUser, addContext(context, "Input email"));
    await writeSomething(tester, password, passUser, addContext(context, "Input password"));
    await tester.pumpAndSettle();
  }

  // Future<void> verifySignInPage(WidgetTester tester, {String context = ""}) async {
  //   await tester.pumpAndSettle();
  //   await htExpect(tester, find.widgetWithText(ButtonItem, 'Sign-in'), findsOneWidget,
  //       reason: ("Verify-" + context + "-" + 'Sign-in text is visible'));
  //   await tester.ensureVisible(find.widgetWithText(ButtonItem, 'Sign-in'));
  //   final email = find.byType(InputItem).first;
  //   final password = find.byType(InputItem).last;
  //   await tapSomething(tester, email, addContext(context, "Email is available"));
  //   await tapSomething(tester, password, addContext(context, "password is available"));
  // }

  Future<void> clickLoginButton(WidgetTester tester, {String context = ""}) async {
    final btnSubmit = find.text('Sign-in').first;
    await tapSomething(tester, btnSubmit, addContext(context, 'Click Btn Submit'));
    await tester.pumpAndSettle();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
