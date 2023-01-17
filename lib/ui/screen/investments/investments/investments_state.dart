import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';

abstract class InvestmentsState {
  const InvestmentsState();
}

class InvestmentsInitial extends InvestmentsState {
  InvestmentsInitial();
}

class InvestmentsLoaded extends InvestmentsState {
  final bool isRetirement;
  final int investmentsTab;
  final List<bool> selectedInvestmentsGrowth;
  final List<bool> selectedAllocations;
  final InvestmentsDashboardModel dashboardData;
  final List<InvestmentModel>? investments;
  final RetirementPageModel? retirements;
  final int retirementTab;
  final List<int> chosenRetirementTabs;
  final List<int> retirementGrowth;
  final List<int> retirementAllocations;

  InvestmentsLoaded({
    required this.isRetirement,
    required this.investmentsTab,
    this.investments,
    this.selectedInvestmentsGrowth = const [
      true,
      true,
      true,
      true,
      true,
      true,
    ],
    this.selectedAllocations = const [
      true,
      true,
      true,
      true,
      true,
      true,
    ],
    required this.dashboardData,
    this.retirements,
    this.retirementTab = 1,
    this.chosenRetirementTabs = const [],
    this.retirementGrowth = const [],
    this.retirementAllocations = const [],
  });

  InvestmentsLoaded copyWith({
    bool? isRetirement,
    int? investmentsTab,
    List<bool>? selectedInvestmentsGrowth,
    List<bool>? selectedAllocations,
    InvestmentsDashboardModel? dashboardData,
    List<InvestmentModel>? investments,
    RetirementPageModel? retirements,
    int? retirementTab,
    List<int>? chosenRetirementTabs,
    List<int>? retirementGrowth,
    List<int>? retirementAllocations,
  }) {
    return InvestmentsLoaded(
        isRetirement: isRetirement ?? this.isRetirement,
        investmentsTab: investmentsTab ?? this.investmentsTab,
        selectedInvestmentsGrowth:
            selectedInvestmentsGrowth ?? this.selectedInvestmentsGrowth,
        selectedAllocations: selectedAllocations ?? this.selectedAllocations,
        dashboardData: dashboardData ?? this.dashboardData,
        investments: investments ?? this.investments,
        retirements: retirements ?? this.retirements,
        chosenRetirementTabs: chosenRetirementTabs ?? this.chosenRetirementTabs,
        retirementTab: retirementTab ?? this.retirementTab,
        retirementGrowth: retirementGrowth ?? this.retirementGrowth,
        retirementAllocations:
            retirementAllocations ?? this.retirementAllocations);
  }

  @override
  String toString() {
    return 'tab: $investmentsTab,\n'
        'isRetirement: $isRetirement,\n'
        'selectedInvestmentsGrowth: $selectedInvestmentsGrowth,\n'
        'selectedAllocations: $selectedAllocations\n'
        'investments: $investments';
  }
}

class InvestmentsError extends InvestmentsState {
  final String message;

  InvestmentsError(this.message);
}

class InvestmentsLoading extends InvestmentsState {
  InvestmentsLoading();
}
