import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';

import 'package:flutter_test/flutter_test.dart';

class ForgotPasswordScreenTest {
  const ForgotPasswordScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnNext() async {
    await tester.pumpAndSettle();
    final btnNext = find.byType(ButtonItem).first;
    await tester.tap(btnNext);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> inputEmail(String emailValue) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final emailInput = find.byType(InputItem).first;
    await tester.tap(emailInput);
    await tester.enterText(emailInput, emailValue);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyForgotPasswordPage() async {
    await tester.pumpAndSettle(const Duration(seconds: 6));
    expect(find.text('Password Recovery'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(ButtonItem, 'Next'));
    final email = find.text('Email').first;
    await tester.ensureVisible(email);
  }

  Future<void> verifyErrorMessage(String msg) async {
    expect(find.text(msg), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}
