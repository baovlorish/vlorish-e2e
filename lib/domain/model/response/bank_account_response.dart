import 'package:burgundy_budgeting_app/ui/model/budget/business_account_model.dart';

class BankAccountResponse {
  final String id;
  final String? name;
  final String? externalName;
  final String currency;
  final String lastFourDigits;
  final bool isMuted;
  final double balance;
  final int type;
  final int kind;
  final int usageType;

  final String? businessId;
  final BusinessAccountModel? business;

  BankAccountResponse({
    required this.id,
    required this.name,
    required this.externalName,
    required this.currency,
    required this.lastFourDigits,
    required this.isMuted,
    required this.balance,
    required this.type,
    required this.kind,
    required this.usageType,
    this.businessId,
    this.business,
  });

  factory BankAccountResponse.fromJson(Map<String, dynamic> json) =>
      BankAccountResponse(
        id: json['id'],
        name: json['name'],
        currency: json['currency'],
        lastFourDigits: json['lastFourDigits'],
        isMuted: json['isMuted'],
        balance: json['balance'],
        kind: json['kind'],
        type: json['type'],
        externalName: json['externalName'],
        usageType: json['usageType'],
        businessId: json['businessId'],
        business: json['business'] != null
            ? BusinessAccountModel.fromJson(json['business'])
            : null,
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['currency'] = currency;
    data['lastFourDigits'] = lastFourDigits;
    data['isMuted'] = isMuted;
    data['balance'] = balance;
    data['kind'] = kind;
    data['type'] = type;
    data['usageType'] = usageType;
    data['businessId'] = businessId;
    data['business'] = business;
    return data;
  }
}
