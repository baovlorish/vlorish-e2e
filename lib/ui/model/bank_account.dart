import 'package:burgundy_budgeting_app/domain/model/response/bank_account_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/exchange_public_token_response.dart';
import 'package:burgundy_budgeting_app/ui/model/account.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/business_account_model.dart';

class BankAccount extends Account {
  @override
  final String id;
  final String currency;
  final String bankName;
  final String lastFourDigits;
  @override
  final bool isMuted;
  @override
  final double balance;
  @override
  final int type;
  @override
  final int kind;
  final String? externalName;

  @override
  final int usageType;
  final String institutionAccountId;

  final String? businessId;
  final BusinessAccountModel? business;
  @override
  final String name;
  final int dataAcquisitionStart;
  final String? businessName;

  BankAccount({
    required this.bankName,
    required this.id,
    required this.currency,
    required this.lastFourDigits,
    required this.isMuted,
    required this.balance,
    required this.type,
    required this.kind,
    required this.usageType,
    required this.businessId,
    required this.business,
    this.externalName,
    this.institutionAccountId = '',
    required this.name,
    this.dataAcquisitionStart = 0,
    this.businessName,
  }) : super(
            id: id,
            name: name,
            usageType: usageType,
            kind: kind,
            type: type,
            balance: balance,
            isMuted: isMuted);

  @override
  BankAccount copyWith({
    String? id,
    String? currency,
    String? bankName,
    String? lastFourDigits,
    bool? isMuted,
    double? balance,
    int? type,
    int? kind,
    int? usageType,
    String? businessId,
    BusinessAccountModel? business,
    String? institutionAccountId,
    String? name,
    String? externalName,
    int? dataAcquisitionStart,
    String? businessName,
  }) {
    return BankAccount(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      isMuted: isMuted ?? this.isMuted,
      balance: balance ?? this.balance,
      bankName: bankName ?? this.bankName,
      usageType: usageType ?? this.usageType,
      type: type ?? this.type,
      kind: kind ?? this.kind,
      externalName: externalName ?? this.externalName,
      institutionAccountId: institutionAccountId ?? this.institutionAccountId,
      name: name ?? this.name,
      dataAcquisitionStart: dataAcquisitionStart ?? this.dataAcquisitionStart,
      businessId: businessId ?? this.businessId,
      business: business ?? this.business,
      businessName: businessName,
    );
  }

  Map<String, dynamic> toMapSetTypeRequest() {
    var mappedType = 0;

    if (usageType == 1) {
      switch (type) {
        case 0: // Bank account(A)
          mappedType = 1;
          break;
        case 1: // Credit card(D)
          mappedType = 2;
          break;
        case 2: // Student loan(D)
          mappedType = 4;
          break;
        case 3: // Investment(A)
          mappedType = 8;
          break;
        case 4: // Mortgage loan(D)
          mappedType = 7;
          break;
        case 5: // Retirement account(A)
          mappedType = 9;
          break;
      }
    } else if (usageType == 2) {
      switch (type) {
        case 0: // Bank account(A)
          mappedType = 1;
          break;
        case 1: // Credit card(D)
          mappedType = 2;
          break;
        case 2: // Business assets(A)
          mappedType = 10;
          break;
      }
    }

    return {
      'name': name.trim(),
      'id': id,
      'type': mappedType,
      'usageType': usageType,
      'dataAcquisitionStart': (dataAcquisitionStart == 0)
          ? 1
          : (dataAcquisitionStart == 1)
              ? 2
              : 0,
      'businessName': businessName?.trim(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currency': currency,
      'bankName': bankName,
      'lastFourDigits': lastFourDigits,
      'isMuted': isMuted,
      'balance': balance,
      'type': type,
      'kind': kind,
      'usageType': usageType,
      'institutionAccountId': institutionAccountId,
    };
  }

  factory BankAccount.fromInstitutionResponse(BankAccountResponse response,
          {required String bankName}) =>
      BankAccount(
        id: response.id,
        name: response.name ?? '',
        currency: response.currency,
        lastFourDigits: response.lastFourDigits,
        isMuted: response.isMuted,
        balance: response.balance,
        bankName: bankName,
        kind: response.kind,
        type: response.type,
        usageType: response.usageType,
        externalName: response.externalName,
        businessId: response.businessId,
        business: response.business,
      );

  factory BankAccount.fromBankAccountsResponseItem(Map<String, dynamic> json) =>
      BankAccount(
        id: json['id'],
        institutionAccountId: json['institutionAccountId'],
        name: json['name'] ?? '',
        currency: json['currency'],
        lastFourDigits: json['lastFourDigits'],
        isMuted: json['isMuted'],
        balance: json['balance'],
        bankName: json['institutionName'],
        kind: json['kind'],
        type: json['type'],
        usageType: json['usageType'],
        externalName: json['externalName'],
        businessId: json['businessId'],
        business: json['business'] != null
            ? BusinessAccountModel.fromJson(json['business'])
            : null,
        businessName: json['businessName'],
      );

  factory BankAccount.fromPlaidAccountsResponse(
          ExchangePublicTokenResponse response) =>
      BankAccount(
        id: response.id,
        name: response.name ?? '',
        currency: response.currency,
        lastFourDigits: response.lastFourDigits,
        isMuted: response.isMuted,
        balance: response.balance,
        bankName: response.institutionName,
        usageType: response.usageType,
        businessId: response.businessId,
        business: response.business,
        type: response.type,
        kind: response.kind,
        externalName: response.externalName,
        institutionAccountId: response.institutionAccountId,
      );

  @override
  String toString() {
    return 'BankAccount id $id institutionAccountId $institutionAccountId name $name currency $currency lastFourDigits $lastFourDigits isMuted  $isMuted balance $balance bankName  $bankName kind  $kind type $type usageType $usageType';
  }
}
