class BudgetRequest {
  final String startMonthYear;
  final int durationInMonths;

  BudgetRequest({
    required this.startMonthYear,
    required this.durationInMonths,
  });

  Map<String, dynamic>? toJson() {
    return {
      'startMonthYear': startMonthYear,
      'durationInMonth': durationInMonths,
    };
  }
}