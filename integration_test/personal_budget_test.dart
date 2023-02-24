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
            'BAR_T138 Check that the Budget-Personal-Annual-Actual page appears after Sign In process',
            '',
            'STARTED');
        await personalBudgetScreen
            .verifyShowPersonalDefautPageAfterSignIn(tester);

        await htLogd(
            tester,
            'BAR_T138 Check that the Budget-Personal-Annual-Actual page appears after Sign In process',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T138 Check that the Budget-Personal-Annual-Actual page appears after Sign In process',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T121 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickMonthly(tester);
        await personalBudgetScreen.verifyBudgetMonthlyPage(tester);
        await htLogd(
            tester,
            'BAR_T121 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T121 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T122 Check that the user is redirected on Annual Actual page after clicking on “Actual” button on the top',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnActual, tester);
        await personalBudgetScreen.verifyShowActualPage(btnActual, tester);
        await htLogd(
            tester,
            'BAR_T122 Check that the user is redirected on Annual Actual page after clicking on “Actual” button on the top',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T122 Check that the user is redirected on Annual Actual page after clicking on “Actual” button on the top',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickBudgetTab(btnDifference, tester);
        await personalBudgetScreen.verifyShowDifferencePage(
            btnDifference, tester);
        await htLogd(
            tester,
            'BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T123 Check that the user is redirected on Annual Difference page after clicking on “Difference” button on the top',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T125 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickBudgetTab(btnDebt, tester);
        await personalBudgetScreen.verifyDebtsPage(tester);
        await htLogd(
            tester,
            'BAR_T125 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T125 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T126 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickBudgetTab(btnGoals, tester);
        await personalBudgetScreen.verifyGoalsPage(tester);
        await htLogd(
            tester,
            'BAR_T126 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T126 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T127 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickBudgetTab(btnTax, tester);
        await personalBudgetScreen.verifyTaxPage(tester);
        await htLogd(
            tester,
            'BAR_T127 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T127 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickBudgetTab(btnInvestments, tester);
        await personalBudgetScreen.verifyInvestmentsPage(tester);
        await htLogd(
            tester,
            'BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T128 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T129 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickBudgetTab(btnInvestments, tester);
        await personalBudgetScreen.verifyInvestmentsPage(tester);
        await personalBudgetScreen.clickRetirementTab(tester);
        await personalBudgetScreen.verifyRetirementPage(tester);
        await htLogd(
            tester,
            'BAR_T129 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T129 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T131 User is redirected on “FI Score” flow page after clicking on “FI Score” tab',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await dashboardScreen.clickButton(btnPeerScore, tester);
        await personalBudgetScreen.verifyPeerScorePage(tester);
        await htLogd(
            tester,
            'BAR_T131 User is redirected on “FI Score” flow page after clicking on “FI Score” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T131 User is redirected on “FI Score” flow page after clicking on “FI Score” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T132 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreen.verifyProfilePage(tester);
        await htLogd(
            tester,
            'BAR_T132 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T132 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T133 User is redirected on Planned screen after clicking on “Planned” button on the top',
            '',
            'STARTED');
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.clickBudgetTab(btnPlanned, tester);
        await personalBudgetScreen.verifyShowPlannedPage(btnPlanned, tester);
        await htLogd(
            tester,
            'BAR_T133 User is redirected on Planned screen after clicking on “Planned” button on the top',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T133 User is redirected on Planned screen after clicking on “Planned” button on the top',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T134 Check that the user is able to Collapse and Expand categories',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyCollapseCategories(tester);
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await personalBudgetScreen.verifyExpandCategories(tester);
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await personalBudgetScreen.verifyCollapseCategories(tester);
        await htLogd(
            tester,
            'BAR_T134 Check that the user is able to Collapse and Expand categories',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T134 Check that the user is able to Collapse and Expand categories',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect('BAR_T140 Check List of Categories', '', 'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyCollapseCategories(tester);
        await personalBudgetScreen.clickCategoryArrowIcon(tester);
        await personalBudgetCategoryScreen
            .verifyPersonalListOfCategories(tester);
        await htLogd(
            tester, 'BAR_T140 Check List of Categories', '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester, 'Error BAR_T140 Check List of Categories', '', 'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T157 Check that user is able to switch months/years on Budget Personal Monthly page',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await personalBudgetScreen.clickMonthly(tester);
        await personalBudgetScreen.verifyBudgetMonthlyPage(tester);
        await personalBudgetScreen.verifyYearOnBudgetMonthly(
            currentYear, tester);
        await personalBudgetScreen.clickRightArrowBtn(tester);
        await personalBudgetScreen.verifyYearOnBudgetMonthly(nextYear, tester);
        await personalBudgetScreen.clickLeftArrowBtn(tester);
        await personalBudgetScreen.verifyYearOnBudgetMonthly(
            currentYear, tester);
        await personalBudgetScreen.clickLeftArrowBtn(tester);
        await personalBudgetScreen.verifyYearOnBudgetMonthly(
            previousYear, tester);
        await htLogd(
            tester,
            'BAR_T157 Check that user is able to switch months/years on Budget Personal Monthly page',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR-T157 Check that user is able to switch months/years on Budget Personal Monthly page',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T158 User is redirected on Budget Annual flow page after clicking on “Annual” button',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        await personalBudgetScreen.verifyPersonalBudgetPage(tester);
        await dashboardScreen.clickButton(btnAnnual, tester);
        await personalBudgetScreen.verifyBudgetAnnualPage(tester);
        await htLogd(
            tester,
            'BAR_T158 User is redirected on Budget Annual flow page after clicking on “Annual” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T158 User is redirected on Budget Annual flow page after clicking on “Annual” button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T124 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'STARTED');
        await dashboardScreen.clickProfileIcon(tester);
        await personalBudgetScreen.clickPersonalTab(tester);
        // await dashboardScreen.clickAccountsTransactionsIconCards(tester);
        // await personalBudgetScreen.verifyAccountsTransactionsPage(tester);
        await htLogd(
            tester,
            'BAR_T124 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Error BAR_T14 Check that the user is redirected on Accounts&Transactions page after clicking on “A&T” icon (cards)',
            '',
            'FINISHED');
      }
    });
  });
}
