class Period {
  final DateTime startDate;
  final int durationInMonths;

  Period(this.startDate, this.durationInMonths);

  factory Period.fromNow({int durationInMonths = 12}) =>
      Period(DateTime.now(), durationInMonths);

  List<DateTime> get months {
    var months = <DateTime>[];
    var year = startDate.year;
    var month = startDate.month;
    for (var index = 0; index < durationInMonths; index++) {
      if (month >= 12) {
        year++;
        month = 0;
      }
      months.add(DateTime(year, month));
      month++;
    }
    return months;
  }

  List<int> get years => List.generate(
      months.last.year - startDate.year + 1, (index) => startDate.year + index);

  String monthString(int month) {
    var monthStringMapper = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };
    return monthStringMapper[month] ?? '';
  }

  factory Period.year(int year) => Period(DateTime(year), 12);

  @override
  String toString() =>
      '${startDate.year} ${startDate.month} - ${months.last.year} ${months.last.month}';
}
