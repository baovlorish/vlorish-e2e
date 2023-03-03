import 'dart:math';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/annual_monthly_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/test_lib_common.dart';
import '../lib/test_lib_const.dart';

class BudgetCategoryScreenTest {
  const BudgetCategoryScreenTest(this.tester);

  final WidgetTester tester;

  Future<void> verifyPersonalListOfCategories(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await htExpect(tester, find.text('Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Income text is visible'));
    await htExpect(tester, find.text('Salary Paycheck'), findsOneWidget,
        reason: ('Verify-' + context + 'Salary Paycheck text is visible'));
    await htExpect(tester, find.text('Owner Draw'), findsOneWidget,
        reason: ('Verify-' + context + 'Owner Draw text is visible'));
    await htExpect(tester, find.text('Rental Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Rental Income text is visible'));
    await htExpect(tester, find.text('Dividend Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Dividend Income text is visible'));
    await htExpect(tester, find.text('Investment Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Investment Income text is visible'));
    await htExpect(tester, find.text('Retirement Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Retirement Income text is visible'));
    await htExpect(tester, find.text('Other Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Other Income text is visible'));
    await htExpect(tester, find.text('Loan Received'), findsOneWidget,
        reason: ('Verify-' + context + 'Loan Received text is visible'));
    // await htExpect(tester, find.text('Unplanned Income'), findsOneWidget,
    //     reason: ('Verify-' + context + 'Unplanned Income text is visible'));
    await htExpect(tester, find.text('Uncategorized Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Uncategorized Income text is visible'));

    await htExpect(tester, find.text('Housing'), findsOneWidget,
        reason: ('Verify-' + context + 'Housing text is visible'));
    await htExpect(tester, find.text('Mortgage'), findsOneWidget,
        reason: ('Verify-' + context + 'Mortgage text is visible'));
    await htExpect(tester, find.text('Rent'), findsOneWidget,
        reason: ('Verify-' + context + 'Rent text is visible'));
    await htExpect(tester, find.text('Utilities'), findsOneWidget,
        reason: ('Verify-' + context + 'Utilities text is visible'));
    await htExpect(tester, find.text('Home Repairs'), findsOneWidget,
        reason: ('Verify-' + context + 'Home Repairs text is visible'));
    await htExpect(tester, find.text('Home Services'), findsOneWidget,
        reason: ('Verify-' + context + 'Home Services text is visible'));

    await htExpect(tester, find.text('Debt Payments'), findsOneWidget,
        reason: ('Verify-' + context + 'Debt Payments text is visible'));
    await htExpect(tester, find.text('Credit Cards'), findsOneWidget,
        reason: ('Verify-' + context + 'Credit Cards text is visible'));
    await htExpect(tester, find.text('Student Loans'), findsOneWidget,
        reason: ('Verify-' + context + 'Student Loans text is visible'));
    await htExpect(tester, find.text('Auto Loans'), findsOneWidget,
        reason: ('Verify-' + context + 'Auto Loans text is visible'));
    await htExpect(tester, find.text('Personal Loan'), findsOneWidget,
        reason: ('Verify-' + context + 'Personal Loan text is visible'));
    await htExpect(tester, find.text('Mortgage loan'), findsOneWidget,
        reason: ('Verify-' + context + 'Mortgage loan text is visible'));
    await htExpect(tester, find.text('Back Taxes'), findsOneWidget,
        reason: ('Verify-' + context + 'Back Taxes text is visible'));
    await htExpect(tester, find.text('Medical Bills'), findsOneWidget,
        reason: ('Verify-' + context + 'Medical Bills text is visible'));
    await htExpect(tester, find.text('Other debt'), findsOneWidget,
        reason: ('Verify-' + context + 'Other debt text is visible'));
    await htExpect(tester, find.text('Alimony'), findsOneWidget,
        reason: ('Verify-' + context + 'Alimony text is visible'));

    await htExpect(tester, find.text('Transportation'), findsOneWidget,
        reason: ('Verify-' + context + 'Transportation text is visible'));
    await htExpect(tester, find.text('Gas'), findsOneWidget,
        reason: ('Verify-' + context + 'Gas text is visible'));
    await htExpect(tester, find.text('Auto insurance'), findsOneWidget,
        reason: ('Verify-' + context + 'Auto insurance text is visible'));
    await htExpect(tester, find.text('Uber'), findsOneWidget,
        reason: ('Verify-' + context + 'Uber text is visible'));
    await htExpect(tester, find.text('Public Transportation'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Public Transportation text is visible'));
    await htExpect(tester, find.text('Auto Repairs'), findsOneWidget,
        reason: ('Verify-' + context + 'Auto Repairs text is visible'));
    await htExpect(tester, find.text('Other Auto Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Other Auto Expenses text is visible'));

    await htExpect(tester, find.text('Living Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Living Expenses text is visible'));
    await htExpect(tester, find.text('Groceries'), findsOneWidget,
        reason: ('Verify-' + context + 'Groceries text is visible'));
    await htExpect(tester, find.text('Clothing'), findsOneWidget,
        reason: ('Verify-' + context + 'Clothing text is visible'));
    await htExpect(tester, find.text('Phone Bill'), findsOneWidget,
        reason: ('Verify-' + context + 'Phone Bill text is visible'));
    await htExpect(tester, find.text('Internet and Cable'), findsOneWidget,
        reason: ('Verify-' + context + 'Internet and Cable text is visible'));
    await htExpect(tester, find.text('Household Basics'), findsOneWidget,
        reason: ('Verify-' + context + 'Household Basics text is visible'));
    await htExpect(tester, find.text('Health Insurance'), findsOneWidget,
        reason: ('Verify-' + context + 'Health Insurance text is visible'));
    await htExpect(tester, find.text('Medical/healthcare'), findsOneWidget,
        reason: ('Verify-' + context + 'Medical/healthcare text is visible'));
    await htExpect(tester, find.text('Pet Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Pet Expenses text is visible'));

    await htExpect(tester, find.text('Lifestyle Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Lifestyle Expenses text is visible'));
    await htExpect(tester, find.text('Vacation'), findsOneWidget,
        reason: ('Verify-' + context + 'Vacation text is visible'));
    await htExpect(tester, find.text('Recreation/Fun'), findsOneWidget,
        reason: ('Verify-' + context + 'Recreation/Fun text is visible'));
    await htExpect(tester, find.text('Coffee & Eating out'), findsOneWidget,
        reason: ('Verify-' + context + 'Coffee & Eating out text is visible'));
    await htExpect(tester, find.text('Dry Cleaning'), findsOneWidget,
        reason: ('Verify-' + context + 'Dry Cleaning text is visible'));
    await htExpect(tester, find.text('Home Decor'), findsOneWidget,
        reason: ('Verify-' + context + 'Home Decor text is visible'));
    await htExpect(tester, find.text('House Help'), findsOneWidget,
        reason: ('Verify-' + context + 'House Help text is visible'));
    await htExpect(tester, find.text('Personal Care'), findsOneWidget,
        reason: ('Verify-' + context + 'Personal Care text is visible'));
    await htExpect(tester, find.text('Personal Development'), findsOneWidget,
        reason: ('Verify-' + context + 'Personal Development text is visible'));
    await htExpect(tester, find.text('Professional Services'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Professional Services text is visible'));
    await htExpect(tester, find.text('Elective Insurances'), findsOneWidget,
        reason: ('Verify-' + context + 'Elective Insurances text is visible'));
    await htExpect(tester, find.text('Leisure Shopping'), findsOneWidget,
        reason: ('Verify-' + context + 'Leisure Shopping text is visible'));

    await htExpect(tester, find.text('Kids'), findsOneWidget,
        reason: ('Verify-' + context + 'Kids text is visible'));
    await htExpect(tester, find.text('Child Care'), findsOneWidget,
        reason: ('Verify-' + context + 'Child Care text is visible'));
    await htExpect(tester, find.text('Baby Necessities'), findsOneWidget,
        reason: ('Verify-' + context + 'Baby Necessities text is visible'));
    await htExpect(tester, find.text('School Tuition & Fees'), findsOneWidget,
        reason:
            ('Verify-' + context + 'School Tuition & Fees text is visible'));
    await htExpect(tester, find.text('School Supplies'), findsOneWidget,
        reason: ('Verify-' + context + 'School Supplies text is visible'));
    await htExpect(tester, find.text('School Lunches'), findsOneWidget,
        reason: ('Verify-' + context + 'School Lunches text is visible'));
    await htExpect(tester, find.text('Tutoring'), findsOneWidget,
        reason: ('Verify-' + context + 'Tutoring text is visible'));
    await htExpect(tester, find.text('Activities'), findsOneWidget,
        reason: ('Verify-' + context + 'Activities text is visible'));
    await htExpect(tester, find.text('Kids shopping'), findsOneWidget,
        reason: ('Verify-' + context + 'Kids shopping text is visible'));
    await htExpect(tester, find.text('Toys'), findsOneWidget,
        reason: ('Verify-' + context + 'Toys text is visible'));
    await htExpect(tester, find.text('Allowance'), findsOneWidget,
        reason: ('Verify-' + context + 'Allowance text is visible'));
    await htExpect(tester, find.text('Child Support'), findsOneWidget,
        reason: ('Verify-' + context + 'Child Support text is visible'));

    await htExpect(tester, find.text('Giving'), findsOneWidget,
        reason: ('Verify-' + context + 'Giving text is visible'));
    await htExpect(tester, find.text('Family support'), findsOneWidget,
        reason: ('Verify-' + context + 'Family support text is visible'));
    await htExpect(tester, find.text('Donations'), findsOneWidget,
        reason: ('Verify-' + context + 'Donations text is visible'));
    await htExpect(tester, find.text('Gifts'), findsOneWidget,
        reason: ('Verify-' + context + 'Gifts text is visible'));

    await htExpect(tester, find.text('Taxes'), findsOneWidget,
        reason: ('Verify-' + context + 'Taxes text is visible'));
    await htExpect(tester, find.text('Federal Income Tax'), findsOneWidget,
        reason: ('Verify-' + context + 'Federal Income Tax text is visible'));
    await htExpect(tester, find.text('State Income Tax'), findsOneWidget,
        reason: ('Verify-' + context + 'State Income Tax text is visible'));

    await htExpect(tester, find.text('Other Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Other Expenses text is visible'));
    await htExpect(tester, find.text('Misc Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Misc Expenses text is visible'));
    await htExpect(tester, find.text('Uncategorized Expenses'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Uncategorized Expenses text is visible'));

    await htExpect(tester, find.text('Total Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Total Expenses text is visible'));

    await htExpect(tester, find.text('Net Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Net Income text is visible'));

    await htExpect(tester, find.text('Goals/Sinking Funds'), findsOneWidget,
        reason: ('Verify-' + context + 'Goals/Sinking Funds text is visible'));

    await htExpect(tester, find.text('Investments').last, findsOneWidget,
        reason: ('Verify-' + context + 'Investments text is visible'));
    await htExpect(tester, find.text('Stocks'), findsOneWidget,
        reason: ('Verify-' + context + 'Stocks text is visible'));
    // await htExpect(tester, find.text('Real Estate'), findsOneWidget,
    //     reason: ('Verify-' + context + 'Real Estate text is visible'));
    await htExpect(tester, find.text('Inv. Properties'), findsOneWidget,
        reason: ('Verify-' + context + 'Inv. Properties text is visible'));
    await htExpect(tester, find.text('Cryptocurrency'), findsOneWidget,
        reason: ('Verify-' + context + 'Cryptocurrency text is visible'));
    await htExpect(tester, find.text('Startup Investments'), findsOneWidget,
        reason: ('Verify-' + context + 'Startup Investments text is visible'));
    await htExpect(tester, find.text('Angel Investments'), findsOneWidget,
        reason: ('Verify-' + context + 'Angel Investments text is visible'));
    await htExpect(tester, find.text('Venture Capital'), findsOneWidget,
        reason: ('Verify-' + context + 'Venture Capital text is visible'));
    await htExpect(tester, find.text('Business Interest'), findsOneWidget,
        reason: ('Verify-' + context + 'Business Interest text is visible'));
    await htExpect(tester, find.text('Retirement Assets'), findsOneWidget,
        reason: ('Verify-' + context + 'Retirement Assets text is visible'));
    await htExpect(tester, find.text('Gold and Other Metals'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Gold and Other Metals text is visible'));
    await htExpect(tester, find.text('Digital Assets'), findsOneWidget,
        reason: ('Verify-' + context + 'Digital Assets text is visible'));
    await htExpect(tester, find.text('Other Investments'), findsOneWidget,
        reason: ('Verify-' + context + 'Other Investments text is visible'));

    await htExpect(tester, find.text('Free Cash'), findsOneWidget,
        reason: ('Verify-' + context + 'Free Cash text is visible'));
    await htExpect(tester, find.text('Total Cash Reserve'), findsOneWidget,
        reason: ('Verify-' + context + 'Total Cash Reserve text is visible'));
    await tester.pumpAndSettle();
  }

  Future<void> verifyBusinessListOfCategories(WidgetTester tester,
      {String context = ''}) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await htExpect(tester, find.text('Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Income text is visible'));
    await htExpect(tester, find.text('Business income'), findsOneWidget,
        reason: ('Verify-' + context + 'Business income text is visible'));
    await htExpect(tester, find.text('Other Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Other Income text is visible'));
    await htExpect(tester, find.text('Loan Received'), findsOneWidget,
        reason: ('Verify-' + context + 'Loan Received text is visible'));
    await htExpect(tester, find.text('Investment in business'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Investment in business text is visible'));
    // await htExpect(tester, find.text('Unplanned Income'), findsOneWidget,
    //     reason: ('Verify-' + context + 'Unplanned Income text is visible'));
    await htExpect(tester, find.text('Uncategorized Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Uncategorized Income text is visible'));

    await htExpect(tester, find.text('Personnel Costs'), findsOneWidget,
        reason: ('Verify-' + context + 'Personnel Costs text is visible'));
    await htExpect(tester, find.text('Owner pay'), findsOneWidget,
        reason: ('Verify-' + context + 'Owner pay text is visible'));
    await htExpect(tester, find.text('Staff salaries'), findsOneWidget,
        reason: ('Verify-' + context + 'Staff salaries text is visible'));
    await htExpect(tester, find.text('Employee benefits'), findsOneWidget,
        reason: ('Verify-' + context + 'Employee benefits text is visible'));
    await htExpect(tester, find.text('Payroll taxes'), findsOneWidget,
        reason: ('Verify-' + context + 'Payroll taxes text is visible'));

    await htExpect(tester, find.text('Professional Services'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Professional Services text is visible'));
    await htExpect(tester, find.text('Accounting'), findsOneWidget,
        reason: ('Verify-' + context + 'Accounting text is visible'));
    await htExpect(tester, find.text('Financial planning'), findsOneWidget,
        reason: ('Verify-' + context + 'Financial planning text is visible'));
    await htExpect(tester, find.text('Content writing'), findsOneWidget,
        reason: ('Verify-' + context + 'Content writing text is visible'));
    await htExpect(tester, find.text('Social media management'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Social media management text is visible'));
    await htExpect(
        tester, find.text('Video production & editing'), findsOneWidget,
        reason: ('Verify-' +
            context +
            'Video production & editing text is visible'));
    // await htExpect(tester, find.text('App development'), findsOneWidget,
    //     reason: ('Verify-' + context + 'App development text is visible'));
    await htExpect(tester, find.text('Software development'), findsOneWidget,
        reason: ('Verify-' + context + 'Software development text is visible'));
    await htExpect(tester, find.text('E-commerce assistant'), findsOneWidget,
        reason: ('Verify-' + context + 'E-commerce assistant text is visible'));
    await htExpect(tester, find.text('Admin assistant'), findsOneWidget,
        reason: ('Verify-' + context + 'Admin assistant text is visible'));
    await htExpect(
        tester, find.text('Other professional services'), findsOneWidget,
        reason: ('Verify-' +
            context +
            'Other professional services text is visible'));

    await htExpect(tester, find.text('Product Costs'), findsOneWidget,
        reason: ('Verify-' + context + 'Product Costs text is visible'));
    await htExpect(tester, find.text('Product cost'), findsOneWidget,
        reason: ('Verify-' + context + 'Product cost text is visible'));
    await htExpect(tester, find.text('Fulfillment fees'), findsOneWidget,
        reason: ('Verify-' + context + 'Fulfillment fees text is visible'));
    await htExpect(tester, find.text('Storage fees'), findsOneWidget,
        reason: ('Verify-' + context + 'Storage fees text is visible'));
    await htExpect(tester, find.text('Shipping & handling'), findsOneWidget,
        reason: ('Verify-' + context + 'Shipping & handling text is visible'));
    await htExpect(tester, find.text('Online selling plans'), findsOneWidget,
        reason: ('Verify-' + context + 'Online selling plans text is visible'));
    await htExpect(tester, find.text('Referral fees'), findsOneWidget,
        reason: ('Verify-' + context + 'Referral fees text is visible'));
    await htExpect(tester, find.text('Merchant fees'), findsOneWidget,
        reason: ('Verify-' + context + 'Merchant fees text is visible'));
    await htExpect(tester, find.text('Returns'), findsOneWidget,
        reason: ('Verify-' + context + 'Returns text is visible'));
    await htExpect(tester, find.text('Product loss'), findsOneWidget,
        reason: ('Verify-' + context + 'Product loss text is visible'));

    await htExpect(tester, find.text('Brand Development'), findsOneWidget,
        reason: ('Verify-' + context + 'Brand Development text is visible'));
    await htExpect(
        tester, find.text(' Advertising & marketing'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Advertising & marketing text is visible'));
    await htExpect(
        tester, find.text('Brand deals & co-marketing'), findsOneWidget,
        reason: ('Verify-' +
            context +
            'Brand deals & co-marketing text is visible'));
    await htExpect(tester, find.text('Referral fee'), findsOneWidget,
        reason: ('Verify-' + context + 'Referral fee text is visible'));
    await htExpect(
        tester, find.text('Social media technology fees'), findsOneWidget,
        reason: ('Verify-' +
            context +
            'Social media technology fees text is visible'));
    await htExpect(tester, find.text('Software subscriptions'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Software subscriptions text is visible'));
    await htExpect(tester, find.text('Other biz development'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Other biz development text is visible'));

    await htExpect(tester, find.text('Office Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Office Expenses text is visible'));
    await htExpect(tester, find.text('Office rent & utilities'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Office rent & utilities text is visible'));
    await htExpect(tester, find.text('Office supplies'), findsOneWidget,
        reason: ('Verify-' + context + 'Office supplies text is visible'));
    await htExpect(tester, find.text('Office equipment'), findsOneWidget,
        reason: ('Verify-' + context + 'Office equipment text is visible'));
    await htExpect(
        tester, find.text('Office furnishing & decor'), findsOneWidget,
        reason: ('Verify-' +
            context +
            'Office furnishing & decor text is visible'));
    await htExpect(tester, find.text('General office expenses'), findsOneWidget,
        reason:
            ('Verify-' + context + 'General office expenses text is visible'));

    await htExpect(tester, find.text('General Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'General Expenses text is visible'));
    await htExpect(tester, find.text('Auto expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Auto expenses text is visible'));
    await htExpect(tester, find.text('Phone & Internet'), findsOneWidget,
        reason: ('Verify-' + context + 'Phone & Internet text is visible'));
    await htExpect(tester, find.text('Meals & entertainment'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Meals & entertainment text is visible'));
    await htExpect(tester, find.text('Travel expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Travel expenses text is visible'));
    await htExpect(tester, find.text('Events & venue fees'), findsOneWidget,
        reason: ('Verify-' + context + 'Events & venue fees text is visible'));
    await htExpect(
        tester, find.text('Website & email services'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Website & email services text is visible'));
    await htExpect(
        tester, find.text('Professional development'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Professional development text is visible'));
    //---------
    // await htExpect(tester, find.text('Business insurance'), findsOneWidget,
    //     reason: ('Verify-' + context + 'Business insurance text is visible'));
    //---------

    await htExpect(tester, find.text('Debts').last, findsOneWidget,
        reason: ('Verify-' + context + 'Debts text is visible'));
    await htExpect(tester, find.text('Credit Cards'), findsOneWidget,
        reason: ('Verify-' + context + 'Credit Cards text is visible'));
    await htExpect(tester, find.text('Business Loan'), findsOneWidget,
        reason: ('Verify-' + context + 'Business Loan text is visible'));
    await htExpect(tester, find.text('Auto Loan'), findsOneWidget,
        reason: ('Verify-' + context + 'Auto Loan text is visible'));

    await htExpect(tester, find.text('Other Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Other Expenses text is visible'));
    await htExpect(tester, find.text('Misc Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Misc Expenses text is visible'));
    await htExpect(tester, find.text('Uncategorized Expenses'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Uncategorized Expenses text is visible'));

    await htExpect(tester, find.text('Total Expenses'), findsOneWidget,
        reason: ('Verify-' + context + 'Total Expenses text is visible'));

    await htExpect(tester, find.text('Net Income'), findsOneWidget,
        reason: ('Verify-' + context + 'Net Income text is visible'));

    await htExpect(tester, find.text('Owner Draw'), findsOneWidget,
        reason: ('Verify-' + context + 'Owner Draw text is visible'));

    await htExpect(
        tester, find.text('Retained in the Business'), findsOneWidget,
        reason:
            ('Verify-' + context + 'Retained in the Business text is visible'));

    await htExpect(tester, find.text('Ending Cash Reserve'), findsOneWidget,
        reason: ('Verify-' + context + 'Ending Cash Reserve text is visible'));

    await tester.pumpAndSettle();
  }
}
