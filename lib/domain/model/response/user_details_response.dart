class UserDetailsResponse {
  final String? firstName;
  final String? lastName;
  final int gender;
  final String? dateOfBirth;
  final int relationshipStatus;
  final int dependents;

  final String? city;
  final String? stateCode;
  final String? currency;

  final int education;
  final int employmentType;
  final int profession;
  final int? creditScore;
  final String? imageUrl;
  final int? income;
  final String? mostUsedBudgetingAppName;
  final int experienceWithBudgetingLevel;

  final int? role;

  UserDetailsResponse({
    this.firstName,
    this.lastName,
    required this.gender,
    this.dateOfBirth,
    required this.relationshipStatus,
    required this.dependents,
    this.city,
    this.stateCode,
    this.currency,
    required this.education,
    required this.employmentType,
    required this.profession,
    this.creditScore,
    this.imageUrl,
    this.income,
    this.mostUsedBudgetingAppName,
    required this.experienceWithBudgetingLevel,
    this.role,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      UserDetailsResponse(
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'],
        relationshipStatus: json['relationshipStatus'],
        dependents: json['dependents'],
        city: json['city'],
        stateCode: json['stateCode'],
        currency: '0',
        education: json['education'],
        employmentType: json['employmentType'],
        profession: json['profession'],
        creditScore: json['creditScore'],
        imageUrl: json['imageUrl'],
        income: json['income'],
        experienceWithBudgetingLevel: json['experienceWithBudgetingLevel'],
        mostUsedBudgetingAppName: json['mostUsedBudgetingAppName'],
        role: json['role'],
      );
}
