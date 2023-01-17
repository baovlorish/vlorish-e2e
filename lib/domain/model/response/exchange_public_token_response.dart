import 'package:burgundy_budgeting_app/ui/model/budget/business_account_model.dart';

class ExchangePublicTokenResponse {
  final String id;
  final String? name;
  final String? externalName;
  final String currency;
  final String institutionName;
  final String lastFourDigits;
  final bool isMuted;
  final double balance;
  final int type;
  final int kind;
  final int usageType;
  final String institutionAccountId;

  final String? businessId;
  final BusinessAccountModel? business;

  ExchangePublicTokenResponse(
      {required this.id,
      required this.name,
      required this.externalName,
      required this.currency,
      required this.lastFourDigits,
      required this.isMuted,
      required this.balance,
      required this.institutionName,
      required this.type,
      required this.kind,
      required this.usageType,
      this.businessId,
      this.business,
      required this.institutionAccountId});

  factory ExchangePublicTokenResponse.fromJson(Map<String, dynamic> json) =>
      ExchangePublicTokenResponse(
        id: json['id'],
        name: json['name'],
        externalName: json['externalName'],
        currency: json['currency'],
        lastFourDigits: json['lastFourDigits'].toString(),
        isMuted: json['isMuted'],
        balance: json['balance'],
        institutionName: json['institutionName'],
        usageType: json['usageType'] ?? 0,
        businessId: json['businessId'],
        business: json['business'] != null
            ? BusinessAccountModel.fromJson(json['business'])
            : null,
        type: json['type'] ?? 0,
        kind: json['kind'] ?? 0,
        institutionAccountId: json['institutionAccountId'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['currency'] = currency;
    data['lastFourDigits'] = lastFourDigits;
    data['isMuted'] = isMuted;
    data['balance'] = balance;
    data['bankName'] = institutionName;
    data['usageType'] = usageType;
    data['businessId'] = businessId;
    data['business'] = business;
    data['type'] = type;
    data['kind'] = kind;
    data['institutionAccountId'] = institutionAccountId;
    return data;
  }
}
