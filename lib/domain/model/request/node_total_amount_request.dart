class NodeTotalAmountRequest {
  String manualAccountId;
  DateTime monthYear;
  int totalAmount;

  NodeTotalAmountRequest({
    required this.manualAccountId,
    required this.totalAmount,
    required this.monthYear,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['manualAccountId'] = manualAccountId;
    map['totalAmount'] = totalAmount;
    map['monthYear'] = monthYear.toIso8601String();
    return map;
  }
}
