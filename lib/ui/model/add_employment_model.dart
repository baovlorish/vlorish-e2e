class EmploymentModel {
  final int profession;
  final int income;
  final int employmentType;

  EmploymentModel({
    required this.profession,
    required this.income,
    required this.employmentType,
  });

  @override
  String toString() =>
      'profession: $profession, income: $income, employmentType: $employmentType';
}