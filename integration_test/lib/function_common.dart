import 'dart:math';

import 'package:intl/intl.dart';

String getRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

String getRandomNumber(int len) {
  var r = Random();
  const _chars = '1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
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
