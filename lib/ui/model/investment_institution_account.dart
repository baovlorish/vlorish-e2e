class InvestmentInstitutionAccount {
  String id;
  String institutionName;
  bool isLoginRequired;

  InvestmentInstitutionAccount({
    required this.id,
    required this.institutionName,
    required this.isLoginRequired,
  });

  factory InvestmentInstitutionAccount.fromJson(Map<String, dynamic> json) =>
      InvestmentInstitutionAccount(
        id: json['id'],
        institutionName: json['institutionName'],
        isLoginRequired: json['isLoginRequired'],
      );

  @override
  String toString() {
    return 'InvestmentInstitutionAccount{id: $id, institutionName: $institutionName, isLoginRequired: $isLoginRequired}';
  }
}
