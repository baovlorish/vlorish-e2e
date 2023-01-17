import 'package:intl/intl.dart';

class CustomDateFormats {
  static DateFormat get defaultDateFormat => DateFormat('MM/dd/yyyy');
  static DateFormat get defaultDateFormatWithTime => DateFormat('MM/dd/yyyy hh:mm a');
  static DateFormat get onlyTime => DateFormat('hh:mm a');
  static DateFormat get monthAndYearDateFormat => DateFormat('MM/yyyy');

  static String timeAndDay(DateTime dateTime) {
    var now = DateTime.now().toUtc();
    var today = DateTime(now.year, now.month, now.day);
    var yesterday = today.subtract(Duration(days: 1));
    if(dateTime.isBefore(today)) {
      if(dateTime.isBefore(yesterday)) {
        // full
        return defaultDateFormatWithTime.format(dateTime);
      } else {
        //yesterday
        return 'Yesterday ${onlyTime.format(dateTime)}';
      }
    } else {
      // today
      return 'Today ${onlyTime.format(dateTime)}';
    }
  }
}
