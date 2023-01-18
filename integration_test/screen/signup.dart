import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class SignUpScreenTest {
  const SignUpScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnSignIn() async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Sign-in').first;
    await tester.tap(btnSignIn);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailUser) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    await tester.enterText(email, emailUser);
  }

  Future<void> inputPassword(String passUser) async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).first;
    await tester.enterText(pass, passUser);
    await tester.enterText(pass, passUser);
  }

  Future<void> ClearPassword() async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).first;
    await tester.tap(pass);
    await simulateKeyDownEvent(LogicalKeyboardKey.backspace);
  }

  Future<void> inputConfirmPassword(String passUser) async {
    await tester.pumpAndSettle();
    final pass = find.byType(InputItem).last;
    await tester.enterText(pass, passUser);
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

  Future<void> clickAgreeAndContinueBtn() async {
    final btnAgree = find.text('Agree & Continue').first;
    await tester.ensureVisible(btnAgree);
    await tester.tap(btnAgree);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickAndVerifyTermLink() async {
    await tester.pumpAndSettle();
    final termUrl = find.text('Terms').first;
    await tester.tap(termUrl);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Terms & Conditions'), findsOneWidget);
  }
}
