import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'package:path_provider/path_provider.dart';
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/budgetCategories.dart';
import 'screen/profile.dart';

const String testDescription = 'Personal Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest personalBudgetScreen;
  BudgetCategoryScreenTest personalBudgetCategoryScreen;
  ProfileScreenTest profileScreen;
  await htTestInit(description: testDescription);
  group('Personal Budget', () {
    testWidgets('Personal Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      personalBudgetScreen = BudgetScreenTest(tester);
      personalBudgetCategoryScreen = BudgetCategoryScreenTest(tester);
      profileScreen = ProfileScreenTest(tester);
      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester);
      await signInScreen.clickLoginButton(tester, context: context);
      await personalBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect(
            'BAR_T124 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'STARTED');
        // await dashboardScreen.clickProfileIcon(tester);
        // await personalBudgetScreen.clickPersonalTab(tester);
        await dashboardScreen.clickAccountsTransactionsIconCards(tester);
        print('object----------------');
        await personalBudgetScreen.verifyAccountsTransactionsPage(tester);
        await htLogd(
            tester,
            'BAR_T124 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR_T14 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'FINISHED');
      }
    });
  });
}
