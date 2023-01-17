class SetBankAccountNameRequest {
  String bankAccountId;
  String name;

  SetBankAccountNameRequest({required this.bankAccountId, required this.name});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['bankAccountId'] = bankAccountId;
    map['name'] = name;
    return map;
  }
}
