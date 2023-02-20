import './lib/test_lib_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';

const String testDescription = 'SignIn';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  await htTestInit(description: testDescription);
  group('Authentication Test', () {
    testWidgets('SignIn test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      context = context ?? '';

      await htLogdDirect(
          'BAR_T64 User can make password visible after tap on “eye“ button',
          '',
          'STARTED');
      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword('', 'Test123', tester,
          context: context);
      await signInScreen.clickEyePassword(tester, context: context);
      await signInScreen.verifyPasswordShow('Test123');
      await htLogd(
          tester,
          'BAR_T64 User can make password visible after tap on “eye“ button',
          '',
          'FINISHED');
    });
  });
}
