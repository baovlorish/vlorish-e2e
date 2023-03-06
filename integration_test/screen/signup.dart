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

  Future<void> clickBtnSignIn(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Sign-in').first;
    await tapSomething(
        tester, btnSignIn, addContext(context, "click Btn SignIn"));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailUser, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await writeSomething(
        tester, email, emailUser, addContext(context, 'Input email'));
    await tester.enterText(email, emailUser);
  }

  Future<void> inputPassword(String passUser, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).first;
    await writeSomething(
        tester, pass, passUser, addContext(context, 'Input password'));
    await tester.enterText(pass, passUser);
  }

  Future<void> ClearPassword() async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).first;
    await tester.tap(pass);
    await simulateKeyDownEvent(LogicalKeyboardKey.backspace);
  }

  Future<void> inputConfirmPassword(String passUser, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).last;
    await writeSomething(
        tester, pass, passUser, addContext(context, 'Input Confirm password'));
    await tester.enterText(pass, passUser);
  }

  Future<void> verifyCurrentPassword(String passUser, WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.text(passUser), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Current password is correct'));
  }

  Future<void> verifyNotCurrentPassword(String passUser, WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle();
    final currentPass = find.byType(TextField).first;
    print(currentPass.toString());
    await htExpect(tester, currentPass.toString(), passUser,
        reason: ("Verify-" +
            context +
            "-" +
            'Current password is not this value ' +
            passUser));
  }

  Future<void> clickButtonNext(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tapSomething(tester, btnNext, addContext(context, 'click Btn Next'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickEyePassword(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).first;
    await tapSomething(tester, btnNext, addContext(context, "Click on Eye"));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordShow(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    await htExpect(tester, find.text(pass), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Password show text is visible'));
  }

  Future<void> verifyPasswordHidden(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).first;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    await htExpect(tester, input.obscureText, true,
        reason:
            ("Verify-" + context + "-" + 'Password show text is NOT visible'));
  }

  Future<void> clickEyeConfirmPassword(WidgetTester tester,
      {String context = ""}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnNext = find.byType(IconButton).last;
    await tapSomething(tester, btnNext,
        addContext(context, "Click on Eye in confirm password"));
    await tester.pumpAndSettle();
  }

  Future<void> verifyConfirmPasswordShow(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, false);
    await htExpect(tester, find.text(pass), findsOneWidget,
        reason: ("Verify-" + context + "-" + 'Password show text is visible'));
  }

  Future<void> verifyConfirmPasswordHidden(String pass, WidgetTester tester,
      {String context = ''}) async {
    final finder = find.byType(TextField).last;
    final input = tester.firstWidget<TextField>(finder);
    expect(input.obscureText, true);
    await htExpect(tester, input.obscureText, true,
        reason:
            ("Verify-" + context + "-" + 'Password show text is NOT visible'));
  }

  Future<void> verifyErrorMessage(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    await htExpect(tester, find.text(msg), findsOneWidget,
        reason: ("Verify-" + context + "-" + msg + ' is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyPasswordPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, find.text('Create a password'), findsOneWidget,
        reason: ("Verify-" + context + '- Text Create a password is visible'));
    await htExpect(tester, find.text('Password'), findsOneWidget,
        reason: ("Verify-" + context + '- Text Password is visible'));
    await htExpect(tester, find.text('Confirm Password'), findsOneWidget,
        reason: ("Verify-" + context + '- Text Confirm Password is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickAgreeAndContinueBtn(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final btnAgree = find.text('Agree & Continue').first;
    await tester.ensureVisible(btnAgree);
    await tapSomething(
        tester, btnAgree, addContext(context, 'click Btn Agree & Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickAndVerifyTermLink(String homeURL, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final termUrl = find.text('Terms').first;
    await tapSomething(tester, termUrl, addContext(context, 'click Term link'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    var currentUrl = Uri.base.toString();
    print(currentUrl);
    await htExpect(tester, homeURL + '#/terms_and_conditions', currentUrl,
        reason: ("Verify-" + context + '-Link terms_and_conditions is called'));
  }

  Future<void> clickAndVerifyPrivacyLink(String homeURL, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    final privacyLink = find.text('Privacy Policy').first;
    await tapSomething(
        tester, privacyLink, addContext(context, 'click Privacy link'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    var currentUrl = Uri.base.toString();
    print(currentUrl);
    await htExpect(tester, homeURL + '#/privacy_policy', currentUrl,
        reason: ("Verify-" + context + '-Link Privacy Policy is called'));
  }

  Future<void> verifySignUpPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    expect(find.text('Please enter your email address to create an account'),
        findsOneWidget);
    await htExpect(
        tester,
        find.text('Please enter your email address to create an account'),
        findsOneWidget,
        reason: ("Verify-" +
            context +
            '- Text Please enter your email address to create an account is visible'));
  }

  Future<void> verifySigupMailCodePage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await htExpect(tester, find.text('Confirm your email'), findsOneWidget,
        reason: ("Verify-" + context + '- Text Confirm your email is visible'));
    await htExpect(
        tester, find.text('We sent an email with a code to '), findsOneWidget,
        reason: ("Verify-" +
            context +
            '- Text We sent an email with a code is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputConfirmCodeEmail(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final code = find.byType(TextField).first;
    await writeSomething(tester, code, '111111',
        addContext(context, 'Input code confirm your email'));
    // await tester.enterText(code, '111111');
    await tester.pumpAndSettle();
  }

  Future<void> verifySigupPersonalInfoPage(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await htExpect(
        tester, find.text('We want to know you better'), findsOneWidget,
        reason:
            ("Verify-" + context + '- Personal Info Page Title is visible'));
    await htExpect(tester, find.text('Please add some details about yourself'),
        findsOneWidget,
        reason: ("Verify-" +
            context +
            '- Text Please add some details about yourself is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyMessageErrorIsVisible(String msg, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final text = tester.widget<Text>(find.text(msg));
    expect(text.style?.color, CustomColorScheme.inputErrorBorder);
    await htExpect(
        tester, text.style?.color, CustomColorScheme.inputErrorBorder,
        reason: ("Verify-" + context + "-" + msg + ' error is visible'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> scrollThePage(String textScroll) async {
    await tester.dragUntilVisible(
      find.text(textScroll), // what you want to find
      find.byKey(ValueKey('Text')), // widget you want to scroll
      const Offset(-500, 0), // delta to move
    );
  }

  Future<void> inputFirstName(String fName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final firstName = find.byType(InputItem).first;
    await writeSomething(
        tester, firstName, fName, addContext(context, 'Input first name'));
    await tester.enterText(firstName, fName);
  }

  Future<void> inputLastName(String lName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final lastName = find.byType(InputItem).at(1);
    await writeSomething(
        tester, lastName, lName, addContext(context, 'Input last name'));
    await tester.enterText(lastName, lName);
  }

  Future<void> selectCity(String searchCityName,
      String selectSuggestionCityName, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle();
    final typeAheadFinder = find.byType(TypeAheadFormField);
    await tester.tap(typeAheadFinder);
    await tester.enterText(typeAheadFinder, searchCityName);
    await tester.pumpAndSettle(const Duration(seconds: 10));
    if (selectSuggestionCityName != '') {
      final suggestionFinder = find.text(selectSuggestionCityName);
      await tester.tap(suggestionFinder);
    }
    await tester.pumpAndSettle(const Duration(seconds: 10));
  }

  Future<void> clickDropdownButton(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final assetImage = AssetImage('assets/images/icons/dropdown.png');
    final imageIconFinder = find.byWidgetPredicate((widget) {
      if (widget is ImageIcon) {
        if (widget.image is AssetImage && widget.image == assetImage) {
          return true;
        }
      }
      return false;
    });
    await tapSomething(tester, imageIconFinder.first,
        addContext(context, 'Click on dropdown button'));
    await tester.pumpAndSettle();
  }

  Future<void> verifySelectDropdown(String valueSelect, WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final valueFinder = find.text(valueSelect).last;
    await tester.ensureVisible(valueFinder);
    await tapSomething(tester, valueFinder,
        addContext(context, 'Click on value $valueSelect'));
    await tester.pumpAndSettle();
  }

  Future<void> clickStepEmailConfirmation(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnSignIn = find.text('Email confirmation').first;
    await tapSomething(tester, btnSignIn,
        addContext(context, "click Step Email Confirmation"));
    await tester.pumpAndSettle();
  }

  Future<void> clickStepPersonalInfo(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final btnSignIn = find.text('Personal Info').first;
    await tapSomething(
        tester, btnSignIn, addContext(context, "click step Personal Info"));
    await tester.pumpAndSettle();
  }
}
