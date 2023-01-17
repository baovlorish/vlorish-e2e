import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter_test/flutter_test.dart';

class SignInScreenTest {
  const SignInScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> clickBtnSignUp() async {
    await tester.pumpAndSettle();
    final btnSignIn = find.text('Sign-up').first;
    await tester.tap(btnSignIn);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

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
}
