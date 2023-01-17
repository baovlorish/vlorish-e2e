class ExperienceModel {
  final String mostUsedBudgetingAppName;
  final int experienceWithBudgetingLevel;

  ExperienceModel({
    required this.mostUsedBudgetingAppName,
    required this.experienceWithBudgetingLevel,
  });

  @override
  String toString() =>
      'mostUsedBudgetingAppName: $mostUsedBudgetingAppName, experienceWithBudgetingLevel: $experienceWithBudgetingLevel';
}
