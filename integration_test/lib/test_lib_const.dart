import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// Passing test in parameters from environment
const String defaultUserName = 'howard@howardthompson.ca';
const String defaultUserPassword = 'justtesting';
const String envUserName =
    String.fromEnvironment('TEST_USER_NAME', defaultValue: defaultUserName);
const String envUserPassword = String.fromEnvironment('TEST_USER_PASSWORD',
    defaultValue: defaultUserPassword);

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
