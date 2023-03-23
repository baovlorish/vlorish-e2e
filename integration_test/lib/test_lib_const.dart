import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// Passing test in parameters from environment
const String defaultUserName = 'howard@howardthompson.ca';
const String defaultUserPassword = 'justtesting';
const String envUserName = String.fromEnvironment('TEST_USER_NAME', defaultValue: defaultUserName);
const String envUserPassword =
    String.fromEnvironment('TEST_USER_PASSWORD', defaultValue: defaultUserPassword);

const String verifyStr = "Verify";

const Key testEmailKey = Key('emailKey');
const Key testPasswordKey = Key('passwordKey');
const Key testLogoutKey = Key('logoutKey');
const Key testSigninKey = Key('signinKey');
const Key testBackKey = Key('backButton');

const String emailLogin = 'baoq+1@vlorish.com';
const String passLogin = 'Test@1234';
const String btnPersonal = 'Personal';
const String btnBusiness = 'Business';
const String btnDebt = 'Debt';
const String btnNetWorth = 'Net Worth';
const String btnGoals = 'Goals';
const String btnTax = 'Tax';
const String btnInvestments = 'Investments';
const String btnPeerScore = 'Peer Score™';
const String btnAnnual = 'Annual';
const String btnMonthly = 'Monthly';
const String btnPlanned = 'Planned';
const String btnActual = 'Actual';
const String btnDifference = 'Difference';
const String currentYear = 'currentYear';
const String previousYear = 'previousYear';
const String nextYear = 'nextYear';

const incomeSubCategoryList = [
  'Salary Paycheck',
  'Owner Draw',
  'Rental Income',
  'Dividend Income',
  'Investment Income',
  'Retirement Income',
  'Other Income',
  'Loan Received',
  'Uncategorized Income'
];
const housingSubCategoryList = [
  'Housing',
  'Mortgage',
  'Rent',
  'Utilities',
  'Home Repairs',
  'Home Services'
];
const debtPaymentsSubCategoryList = [
  'Credit Cards',
  'Student Loans',
  'Auto Loans',
  'Personal Loan',
  'Mortgage loan',
  'Back Taxes',
  'Medical Bills',
  'Other debt',
  'Alimony'
];
const transportationSubCategoryList = [
  'Gas',
  'Auto insurance',
  'Uber',
  'Public Transportation',
  'Auto Repairs',
  'Other Auto Expenses'
];
const livingExpensesSubCategoryList = [
  'Groceries',
  'Clothing',
  'Phone Bill',
  'Internet and Cable',
  'Household Basics',
  'Health Insurance',
  'Medical/healthcare',
  'Pet Expenses'
];
const lifestyleExpensesSubCategoryList = [
  'Vacation',
  'Recreation/Fun',
  'Coffee & Eating out',
  'Dry Cleaning',
  'Home Decor',
  'House Help',
  'Personal Care',
  'Personal Development',
  'Professional Services',
  'Elective Insurances',
  'Leisure Shopping',
];
const kidsSubCategoryList = [
  'Child Care',
  'Baby Necessities',
  'School Tuition & Fees',
  'School Supplies',
  'School Lunches',
  'Tutoring',
  'Activities',
  'Kids shopping',
  'Toys',
  'Allowance',
  'Child Support'
];
const givingSubCategoryList = ['Family support', 'Donations', 'Gifts'];
const taxesSubCategoryList = ['Federal Income Tax', 'State Income Tax'];
const otherExpensesSubCategoryList = ['Misc Expenses', 'Uncategorized Expenses'];
const investmentsSubCategoryList = [
  'Stocks',
  'Inv. Properties',
  'Cryptocurrency',
  'Startup Investments',
  'Angel Investments',
  'Venture Capital',
  'Business Interest',
  'Retirement Assets',
  'Gold and Other Metals',
  'Digital Assets',
  'Other Investments'
];

const allSubCategoryList = [
  'Salary Paycheck',
  'Owner Draw',
  'Rental Income',
  'Dividend Income',
  'Investment Income',
  'Retirement Income',
  'Other Income',
  'Loan Received',
  'Uncategorized Income',
  'Housing',
  'Mortgage',
  'Rent',
  'Utilities',
  'Home Repairs',
  'Home Services',
  'Credit Cards',
  'Student Loans',
  'Auto Loans',
  'Personal Loan',
  'Mortgage loan',
  'Back Taxes',
  'Medical Bills',
  'Other debt',
  'Alimony',
  'Gas',
  'Auto insurance',
  'Uber',
  'Public Transportation',
  'Auto Repairs',
  'Other Auto Expenses',
  'Groceries',
  'Clothing',
  'Phone Bill',
  'Internet and Cable',
  'Household Basics',
  'Health Insurance',
  'Medical/healthcare',
  'Pet Expenses',
  'Vacation',
  'Recreation/Fun',
  'Coffee & Eating out',
  'Dry Cleaning',
  'Home Decor',
  'House Help',
  'Personal Care',
  'Personal Development',
  'Professional Services',
  'Elective Insurances',
  'Leisure Shopping',
  'Child Care',
  'Baby Necessities',
  'School Tuition & Fees',
  'School Supplies',
  'School Lunches',
  'Tutoring',
  'Activities',
  'Kids shopping',
  'Toys',
  'Allowance',
  'Child Support',
  'Family support',
  'Donations',
  'Gifts',
  'Federal Income Tax',
  'State Income Tax',
  'Misc Expenses',
  'Uncategorized Expenses',
  'Stocks',
  'Inv. Properties',
  'Cryptocurrency',
  'Startup Investments',
  'Angel Investments',
  'Venture Capital',
  'Business Interest',
  'Retirement Assets',
  'Gold and Other Metals',
  'Digital Assets',
  'Other Investments'
];

const mainCategoryList = [
  'Income',
  'Housing',
  'Debt Payments',
  'Transportation',
  'Living Expenses',
  'Lifestyle Expenses',
  'Kids',
  'Giving',
  'Taxes',
  'Other Expenses',
  'Total Expenses',
  'Net Income',
  'Goals/Sinking Funds',
  'Investments',
  'Free Cash',
  'Total Cash Reserves'
];
