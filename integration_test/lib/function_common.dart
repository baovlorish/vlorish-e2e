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

String getDateNow() {
  var date = DateTime.now();
  print(date.toString());
  print(DateFormat.yMMMd().format(DateTime.now()));
  print(DateFormat.yMMMM());
  print(DateFormat.MMMM());
  return date.toString();
}
