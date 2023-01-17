class SetManualAccountNameRequest {
  String manualAccountId;
  String name;

  SetManualAccountNameRequest({
    required this.manualAccountId,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['manualAccountId'] = manualAccountId;
    map['name'] = name;
    return map;
  }
}
