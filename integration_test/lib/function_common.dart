import 'dart:math';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

final monthNames = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

String getRandomString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

String getRandomCharacter(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

String getRandomNumber(int len) {
  var r = Random();
  const _chars = '1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

String getRandomSymbolString(int length) {
  final random = Random();
  const symbols = r'!@#\$%^&*(),.?":{}|<>';
  return String.fromCharCodes(
      Iterable.generate(length, (_) => symbols.codeUnitAt(random.nextInt(symbols.length))));
}

int getDateNow() {
  var date = DateTime.now();
  print(date.toString());
  print(DateFormat.yMMM().format(DateTime.now()));
  print(DateFormat.yMMMd().format(DateTime.now()));
  print(DateFormat.MMM().format(DateTime.now()));
  print(DateFormat.MMMM().format(DateTime.now()));
  print(DateFormat.MMMM().format(DateTime.now()));
  print(DateFormat.yM().format(DateTime.now()));
  return date.year;
}

int getCurrentYear() {
  final now = DateTime.now();
  return now.year;
}

int getPreviousYear() {
  final now = DateTime.now();
  final previousYear = (now.subtract(const Duration(days: 365))).year;
  return previousYear;
}

int getNextYear() {
  final now = DateTime.now();
  final nextYear = (now.add(const Duration(days: 365))).year;
  return nextYear;
}

String getCurentMonthYear(DateTime date) {
  final monthIndex = date.month;
  final year = date.year;

  final currentMonthYear = '${monthNames[monthIndex]} $year';

  return '$currentMonthYear';
}

String getPreviousMonthYear(DateTime date) {
  final previousMonth = DateTime(date.year, date.month - 1, date.day).month;
  final previousYear = previousMonth == 12 ? date.year - 1 : date.year;
  final previousMonthYear = '${monthNames[previousMonth]} $previousYear';

  return '$previousMonthYear';
}

String getNextMonthYear(DateTime date) {
  final nextMonth = DateTime(date.year, date.month + 1, date.day).month;
  final nextYear = nextMonth == 1 ? date.year + 1 : date.year;
  final nextMonthYear = '${monthNames[nextMonth]} $nextYear';

  return '$nextMonthYear';
}

int randomInt(int toNumber) {
  final random = Random();
  final number = random.nextInt(toNumber);
  return number;
}

String formatNumberToValue(int number) {
  final formatted = NumberFormat('#,##0').format(number);
  return formatted;
}

int formatValueToNumber(String stringValue) {
  final intValue = int.parse(stringValue.replaceAll(RegExp(r','), ''));
  return intValue;
}

int currencyStringToNumber(String currencyString) {
  return int.parse(currencyString.replaceAll(',', '').replaceAll('\$', ''));
}

int totalSpentSum(
    String housingValue,
    String debtPaymentsValue,
    String transportationValue,
    String livingExpensesValue,
    String lifestyleExpensesValue,
    String kidsValue,
    String givingValue,
    String taxesValue,
    String otherExpensesValue) {
  final list = [
    currencyStringToNumber(housingValue),
    currencyStringToNumber(debtPaymentsValue),
    currencyStringToNumber(transportationValue),
    currencyStringToNumber(livingExpensesValue),
    currencyStringToNumber(lifestyleExpensesValue),
    currencyStringToNumber(kidsValue),
    currencyStringToNumber(givingValue),
    currencyStringToNumber(taxesValue),
    currencyStringToNumber(otherExpensesValue)
  ];

  final sumTotalSpent = list.sum;
  return sumTotalSpent;
}

String getMonthAtYear(int month) {
  switch (month) {
    case 0:
      return 'CATEGORY';
    case 1:
      return 'JAN';
    case 2:
      return 'FEB';
    case 3:
      return 'MAR';
    case 4:
      return 'APR';
    case 5:
      return 'MAY';
    case 6:
      return 'JUN';
    case 7:
      return 'JUL';
    case 8:
      return 'AUG';
    case 9:
      return 'SEP';
    case 10:
      return 'OCT';
    case 11:
      return 'NOV';
    case 12:
      return 'DEC';
    default:
      throw Exception('Invalid month: $month');
  }
}
