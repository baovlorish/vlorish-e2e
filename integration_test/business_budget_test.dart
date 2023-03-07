import 'dart:io';
import './lib/test_lib_common.dart';
import './lib/test_lib_const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burgundy_budgeting_app/main.dart' as app;
import 'screen/dashboard.dart';
import 'screen/signin.dart';
import 'screen/budget.dart';
import 'screen/budgetCategories.dart';
import 'screen/profile.dart';

const String testDescription = 'Business Budget';
void main() async {
  SignInScreenTest signInScreen;
  DashboardScreenTest dashboardScreen;
  BudgetScreenTest businessBudgetScreen;
  BudgetCategoryScreenTest businessBudgetCategoryScreen;
  ProfileScreenTest profileScreenScreen;
  await htTestInit(description: testDescription);
  group('Business Budget', () {
    testWidgets('Business Budget test', (tester, [String? context]) async {
      await app.main();
      signInScreen = SignInScreenTest(tester);
      dashboardScreen = DashboardScreenTest(tester);
      businessBudgetScreen = BudgetScreenTest(tester);
      businessBudgetCategoryScreen = BudgetCategoryScreenTest(tester);
      profileScreenScreen = ProfileScreenTest(tester);

      context = context ?? '';

      await dashboardScreen.clickLogoText();
      await signInScreen.inputEmailAndPassword(emailLogin, passLogin, tester,
          context: context);
      await signInScreen.clickLoginButton(tester, context: context);
      await businessBudgetScreen.verifyPersonalBudgetPage(tester);

      try {
        await htLogdDirect(
            'BAR_T163 Check List of Categories on Budget Business Annual page',
            '',
            'STARTED');
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickCategoryArrowIcon(tester);
        await businessBudgetCategoryScreen
            .verifyBusinessListOfCategories(tester);
        await htLogd(
            tester,
            'BAR_T163 Check List of Categories on Budget Business Annual page',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T163 Check List of Categories on Budget Business Annual page',
            '',
            'FINISHED');
      }

      // try {
      //   await htLogdDirect(
      //       'BAR_T167 User is redirected on Available Annually tab button after clicking on “Difference” button',
      //       '',
      //       'STARTED');
      //   await businessBudgetScreen.clickPersonalTab(tester);
      //   await businessBudgetScreen.verifyPersonalBudgetPage(tester);
      //   await businessBudgetScreen.clickBusinessTab(tester);
      //   await businessBudgetScreen.verifyBusinessBudgetPage(tester);
      //   await businessBudgetScreen.clickBudgetTab(btnDifference, tester);
      //   await businessBudgetScreen.verifyShowDifferencePage(
      //       btnDifference, tester);
      //   await htLogd(
      //       tester,
      //       'BAR_T167 User is redirected on Available Annually tab button after clicking on “Difference” button',
      //       '',
      //       'FINISHED');
      // } catch (e) {
      //   await htLogd(
      //       tester,
      //       'Failed BAR-T167 User is redirected on Available Annually tab button after clicking on “Difference” button',
      //       '',
      //       'FINISHED');
      // }

      try {
        await htLogdDirect(
            'BAR_T169 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickBudgetTab(btnDebt, tester);
        await businessBudgetScreen.verifyDebtsPage(tester);
        await htLogd(
            tester,
            'BAR_T169 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T169 User is redirected on Debts flow page after clicking on “Debts” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T170 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickBudgetTab(btnGoals, tester);
        await businessBudgetScreen.verifyGoalsPage(tester);
        await htLogd(
            tester,
            'BAR_T170 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T170 User is redirected on Goals flow page after clicking on “Goals” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T171 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickBudgetTab(btnTax, tester);
        await businessBudgetScreen.verifyTaxPage(tester);
        await htLogd(
            tester,
            'BAR_T171 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T171 User is redirected on Tax flow page after clicking on “Tax” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T172 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickBudgetTab(btnInvestments, tester);
        await businessBudgetScreen.verifyInvestmentsPage(tester);
        await htLogd(
            tester,
            'BAR_T172 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T172 User is redirected on Investments flow page after clicking on “Investments” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T173 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickBudgetTab(btnInvestments, tester);
        await businessBudgetScreen.verifyInvestmentsPage(tester);
        await businessBudgetScreen.clickRetirementTab(tester);
        await businessBudgetScreen.verifyRetirementPage(tester);
        await htLogd(
            tester,
            'BAR_T173 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T173 User is redirected on Retirement flow page after clicking on “Retirement” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T175 User is redirected on “FI Score” flow page after clicking on “FI Score” tab',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickBudgetTab(btnPeerScore, tester);
        await businessBudgetScreen.verifyPeerScorePage(tester);
        await htLogd(
            tester,
            'BAR_T175 User is redirected on “FI Score” flow page after clicking on “FI Score” tab',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T175 User is redirected on “FI Score” flow page after clicking on “FI Score” tab',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T176 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await dashboardScreen.clickProfileIcon(tester);
        await profileScreenScreen.verifyProfilePage(tester);
        await htLogd(
            tester,
            'BAR_T176 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T176 User is redirected on Profile flow page after clicking on Profile icon',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T177 User is redirected on Planned screen after clicking on “Planned” button',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickBudgetTab(btnPlanned, tester);
        await businessBudgetScreen.verifyShowPlannedPage(btnPlanned, tester);
        await htLogd(
            tester,
            'BAR_T177 User is redirected on Planned screen after clicking on “Planned” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T177 User is redirected on Planned screen after clicking on “Planned” button',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T178 User is able to hide/unhide categories', '', 'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.verifyHideBusinessCategories(tester);
        await businessBudgetScreen.clickCategoryArrowIcon(tester);
        await businessBudgetScreen.verifyShowBusinessCategories(tester);
        await businessBudgetScreen.clickCategoryArrowIcon(tester);
        await businessBudgetScreen.verifyHideBusinessCategories(tester);
        await htLogd(tester, 'BAR_T178 User is able to hide/unhide categories',
            '', 'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T178 User is able to hide/unhide categories',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T181 Check that user is able to decreasing or  increasing years on Budget Business Annual',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.verifyYearOnBudgetAnnual(
            currentYear, tester);
        await businessBudgetScreen.clickRightArrowBtn(tester);
        await businessBudgetScreen.verifyYearOnBudgetAnnual(nextYear, tester);
        await businessBudgetScreen.clickLeftArrowBtn(tester);
        await businessBudgetScreen.verifyYearOnBudgetAnnual(
            currentYear, tester);
        await businessBudgetScreen.clickLeftArrowBtn(tester);
        await businessBudgetScreen.verifyYearOnBudgetAnnual(
            previousYear, tester);
        await htLogd(
            tester,
            'BAR_T181 Check that user is able to decreasing or  increasing years on Budget Business Annual',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T181 Check that user is able to decreasing or  increasing years on Budget Business Annual',
            '',
            'FINISHED');
      }

      try {
        await htLogdDirect(
            'BAR_T165 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'STARTED');
        await businessBudgetScreen.clickPersonalTab(tester);
        await businessBudgetScreen.verifyPersonalBudgetPage(tester);
        await businessBudgetScreen.clickBusinessTab(tester);
        await businessBudgetScreen.verifyBusinessBudgetPage(tester);
        await businessBudgetScreen.clickMonthly(tester);
        await businessBudgetScreen.verifyBudgetMonthlyPage(tester);
        await htLogd(
            tester,
            'BAR_T165 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'FINISHED');
      } catch (e) {
        await htLogd(
            tester,
            'Failed BAR-T165 User is redirected on Budget Monthly flow page after clicking on “Monthly” button',
            '',
            'FINISHED');
      }
    });
  });
}
