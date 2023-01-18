import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginScreenTest {
  const LoginScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> inputEmailAndPassword(String emailUser, String passUser) async {
    await tester.pumpAndSettle();
    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;
    await tester.enterText(email, emailUser);
    await tester.enterText(password, passUser);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> clickLoginButton() async {
    final btnSubmit = find.text('Sign-in').first;
    await tester.ensureVisible(btnSubmit);
    await tester.tap(btnSubmit);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifyErrorMessage(String msg) async {
    expect(find.text(msg), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> verifySignInPage() async {
    await tester.pumpAndSettle(const Duration(seconds: 4));
    await tester.ensureVisible(find.widgetWithText(ButtonItem, 'sign-in'));
    final email = find.byType(InputItem).first;
    final password = find.byType(InputItem).last;
    await tester.ensureVisible(email);
    await tester.ensureVisible(password);
  }
}
