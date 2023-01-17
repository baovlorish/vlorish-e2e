class NodeInterestAmountRequest {
  String manualAccountId;
  DateTime monthYear;
  int interestAmount;

  NodeInterestAmountRequest({
    required this.manualAccountId,
    required this.monthYear,
    required this.interestAmount,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['manualAccountId'] = manualAccountId;
    map['monthYear'] = monthYear.toIso8601String();
    ;
    map['interestAmount'] = interestAmount;
    return map;
  }
}
