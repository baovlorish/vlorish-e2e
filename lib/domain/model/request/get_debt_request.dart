class DebtsPageModelRequest {
  DateTime startMonthYear;
  int durationInMonth;

  DebtsPageModelRequest(
      {required this.startMonthYear, required this.durationInMonth});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['startMonthYear'] = startMonthYear.toIso8601String();
    map['durationInMonth'] = durationInMonth;
    return map;
  }
}
