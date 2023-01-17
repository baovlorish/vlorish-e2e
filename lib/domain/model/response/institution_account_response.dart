import 'bank_account_response.dart';

class InstitutionAccountsResponse {
  List<InstitutionResponse> institutionAccountResponses;

  InstitutionAccountsResponse(this.institutionAccountResponses);

  factory InstitutionAccountsResponse.fromJsonMap(Map<String, dynamic> json) {
    var _institutionAccounts = <InstitutionResponse>[];
    for (var institutionAccount in json['institutionAccounts']) {
      _institutionAccounts
          .add(InstitutionResponse.fromJsonMap(institutionAccount));
    }

    return InstitutionAccountsResponse(_institutionAccounts);
  }
}

class InstitutionResponse {
  final String id;
  final String name;
  final String institutionName;
  final bool isLoginRequired;
  final String? ownerName;
  final bool isOwnerBudgetUser;
  final List<BankAccountResponse> bankAccounts;
  final bool isInvestment;

  InstitutionResponse({
    required this.id,
    required this.institutionName,
    required this.isLoginRequired,
    this.name = '',
    required this.ownerName,
    required this.isOwnerBudgetUser,
    required this.bankAccounts,
    this.isInvestment = false,
  });

  factory InstitutionResponse.fromJsonMap(Map<String, dynamic> json,
      {bool isInvestment = false}) {
    var _bankAccounts = <BankAccountResponse>[];
    for (var bank in json['bankAccounts']) {
      _bankAccounts.add(BankAccountResponse.fromJson(bank));
    }

    return InstitutionResponse(
      id: json['id'],
      institutionName: json['institutionName'],
      isLoginRequired: json['isLoginRequired'],
      bankAccounts: _bankAccounts,
      isOwnerBudgetUser: json['isOwnerBudgetUser'] ?? true,
      ownerName: json['ownerName'],
      isInvestment: isInvestment,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['institutionName'] = institutionName;
    data['isLoginRequired'] = isLoginRequired;
    data['bankAccounts'] = bankAccounts;
    return data;
  }
}
