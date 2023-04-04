import 'package:otp_text_field/otp_field.dart';
import 'package:petitparser/petitparser.dart';
import '../lib/function_common.dart';
import '../lib/test_lib_common.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:flutter_test/flutter_test.dart';

final newPassword = 'Hello@1234';
final codeIsIncorrectErrorMsg = 'Please re-enter or have a new one sent to you.';
final passwordRecoveryTitle = 'Password Recovery';
final enterEmailText = 'Enter the email address associated with your account';
final recoverMyPasswordBtn = 'Recover my password';
final saveMyNewPasswordBtn = 'Save my new password';
final cancelBtn = 'Cancel';
final continueBtn = 'Continue';
final backBtn = 'Back';
final resentBtn = 'Resent';
final success = 'Success!';
final codeWasSentToYourEmail = 'Code was sent to your email';

class PasswordRecoveryScreenTest {
  const PasswordRecoveryScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyShowPasswordRecoveryPage(WidgetTester tester, {String context = ""}) async {
    await htExpect(tester, find.text(passwordRecoveryTitle), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$passwordRecoveryTitle title is visible'));
    await htExpect(tester, find.text(enterEmailText), findsOneWidget,
        reason: ('Verify-' + context + '-' + '$enterEmailText is visible'));
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
    await tester.pumpAndSettle();
    final code = find.byType(OTPTextField);
    tester.printToConsole('code: -------- $code');
    await writeSomething(
        tester, code, getRandomNumber(6), addContext(context, 'Input code set new password'));
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
}
