import 'package:burgundy_budgeting_app/ui/model/debt_category.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/model/debts_page_model.dart';
import 'package:equatable/equatable.dart';

abstract class DebtsState extends Equatable {
  const DebtsState();
}

class DebtsInitial extends DebtsState {
  DebtsInitial();

  @override
  List<Object?> get props => [];
}

class DebtsLoading extends DebtsState {
  DebtsLoading();

  @override
  List<Object?> get props => [];
}

class DebtsLoaded extends DebtsState {
  final bool isAnnual;
  final DebtsPageModel debtsPageModel;
  final DebtStatisticModel statisticModel;
  final List<DebtCategory> selectedCategories;
  final List<DebtCategory> collapsedCategories;

  DebtsLoaded({
    required this.isAnnual,
    required this.debtsPageModel,
    required this.statisticModel,
    required this.selectedCategories,
    required this.collapsedCategories,
  });

  @override
  List<Object?> get props => [
        debtsPageModel,
        statisticModel,
        selectedCategories,
        collapsedCategories,
        isAnnual,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is DebtsLoaded &&
          runtimeType == other.runtimeType &&
          debtsPageModel == other.debtsPageModel &&
          statisticModel == other.statisticModel &&
          selectedCategories == other.selectedCategories;

  @override
  int get hashCode =>
      super.hashCode ^
      debtsPageModel.hashCode ^
      statisticModel.hashCode ^
      selectedCategories.hashCode;
}

class DebtsError extends DebtsState {
  final String error;
  DebtsError(this.error);

  @override
  List<Object?> get props => [error];
}
