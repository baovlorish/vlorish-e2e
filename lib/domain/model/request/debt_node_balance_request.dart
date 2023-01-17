class NodeBalanceRequest {
  String manualAccountId;
  DateTime monthYear;
  int amount;

  NodeBalanceRequest({
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
