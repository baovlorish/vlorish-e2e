class GetNetWorthRequest {
  DateTime startMonthYear;
  int durationInMonth;

  GetNetWorthRequest({
    required this.startMonthYear,
    required this.durationInMonth,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['startMonthYear'] = startMonthYear.toIso8601String();
    map['durationInMonth'] = durationInMonth;
    return map;
  }
}
