class NetWorthNodeRequest {
  final String manualAccountId;
  final int amount;
  final DateTime monthYear;

  NetWorthNodeRequest({
    required this.manualAccountId,
    required this.amount,
    required this.monthYear,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['manualAccountId'] = manualAccountId;
    map['amount'] = amount;
    map['monthYear'] = monthYear.toIso8601String();
    return map;
  }
}
