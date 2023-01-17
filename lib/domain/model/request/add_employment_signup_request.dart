class AddEmploymentSignUpRequest {
  final int profession;
  final int income;
  final int employmentType;

  AddEmploymentSignUpRequest({
    required this.profession,
    required this.income,
    required this.employmentType,
  });

  Map<String, dynamic>? toJson() {
    return {
      'profession': profession,
      'income': income,
      'employmentType': employmentType,
    };
  }
}
