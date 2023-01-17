class AddExperienceSignUpRequest {
  String mostUsedBudgetingAppName;
  final int experienceWithBudgetingLevel;

  AddExperienceSignUpRequest({
    required this.mostUsedBudgetingAppName,
    required this.experienceWithBudgetingLevel,
  });

  Map<String, dynamic>? toJson() {
    if(mostUsedBudgetingAppName.isEmpty) {
      mostUsedBudgetingAppName = ' ';
    }
    return {
      'mostUsedBudgetingAppName': mostUsedBudgetingAppName,
      'experienceWithBudgetingLevel': experienceWithBudgetingLevel,
    };
  }
}
