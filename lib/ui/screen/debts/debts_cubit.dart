import 'dart:async';

import 'package:burgundy_budgeting_app/domain/repository/debt_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_category.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_category_ui_model.dart';
import 'package:burgundy_budgeting_app/ui/model/debt_statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/debts/debts_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class DebtsCubit extends Cubit<DebtsState> {
  final Logger logger = getLogger('DebtsCubit');

  final DebtsRepository repository;

  DebtsCubit(this.repository) : super(DebtsInitial()) {
    logger.i('Debts Page');
    emit(DebtsLoading());
    fetchDebts(DateTime(DateTime.now().year), 12);
  }

  Future<void> fetchDebts(DateTime startMonthYear, int durationInMonth) async {
    DebtsLoaded? loadedState;
    if (state is DebtsLoaded) {
      loadedState = state as DebtsLoaded;
    }

    try {
      var debtsModel = await repository.fetchDebts(
        startMonthYear: startMonthYear,
        durationInMonth: durationInMonth,
      );

      emit(DebtsLoaded(
        isAnnual: durationInMonth == 12,
        debtsPageModel: debtsModel,
        statisticModel: mapDebtsToStatsModel(
          loadedState != null
              ? debtsModel.allCategories
                  .where((element) =>
                      loadedState!.selectedCategories.contains(element))
                  .toList()
              : debtsModel.allCategories,
        ),
        selectedCategories: loadedState != null
            ? loadedState.selectedCategories
            : debtsModel.allCategories,
        collapsedCategories:
            loadedState != null ? loadedState.collapsedCategories : [],
      ));
    } catch (e) {
      emit(DebtsError(e.toString()));
      rethrow;
    }
  }

  DebtStatisticModel mapDebtsToStatsModel(List<DebtCategory> debtCategories) {
    var sumOfAllDebts = 0.0;
    var totalPayments = 0;
    var interestPaid = 0;
    var debtPaid = 0;

    var debtsStatisticsModels = <StatisticModel>[];
    var number = 0;
    var uiModels = <DebtCategoryUiModel>[];
    debtCategories.forEach((debtCategory) {
      number = debtCategories.indexOf(debtCategory);
      var uiModel = DebtCategoryUiModel.fromDebtCategory(
        debtCategory,
        number: number,
      );
      totalPayments += uiModel.total;
      interestPaid += uiModel.interest;
      debtPaid += uiModel.debtPaid;
      sumOfAllDebts += uiModel.sum.toDouble();
      uiModels.add(uiModel);
    });

    uniteCategoriesWithSameName(uiModels, number);

    uiModels.forEach((model) {
      debtsStatisticsModels.add(StatisticModel.fromDebtCategory(
        model,
        sumOfAllDebts,
      ));
    });

    debtsStatisticsModels.sort();

    return DebtStatisticModel(
      statisticModels: debtsStatisticsModels,
      totalPayments: totalPayments,
      interestPaid: interestPaid,
      debtPaid: debtPaid,
    );
  }

  Future<void> setNodeInterestAmount({
    required String manualAccountId,
    required DateTime monthYear,
    required int interestAmount,
    required bool isPersonal,
  }) async {
    if (state is DebtsLoaded) {
      var loadedState = state as DebtsLoaded;
      try {
        await repository.setNodeInterestAmount(
          manualAccountId: manualAccountId,
          monthYear: monthYear,
          interestAmount: interestAmount,
        );

        var updatedDebts = (state as DebtsLoaded)
            .debtsPageModel
            .copyWithNodeOrAccountName(
                isPersonal: isPersonal,
                accountId: manualAccountId,
                monthYear: monthYear,
                interestAmount: interestAmount);
        emit(
          DebtsLoaded(
            isAnnual: loadedState.isAnnual,
            debtsPageModel: updatedDebts,
            statisticModel: mapDebtsToStatsModel(updatedDebts.allCategories
                .where((element) =>
                    loadedState.selectedCategories.contains(element))
                .toList()),
            selectedCategories: (state as DebtsLoaded).selectedCategories,
            collapsedCategories: (state as DebtsLoaded).collapsedCategories,
          ),
        );
      } catch (e) {
        emit(DebtsError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }

  Future<void> setNodeTotalAmount({
    required bool isPersonal,
    required String manualAccountId,
    required DateTime monthYear,
    required int totalAmount,
  }) async {
    if (state is DebtsLoaded) {
      var loadedState = state as DebtsLoaded;
      try {
        await repository.setNodeTotalAmount(
          manualAccountId: manualAccountId,
          monthYear: monthYear,
          totalAmount: totalAmount,
        );

        var updatedDebts = (state as DebtsLoaded)
            .debtsPageModel
            .copyWithNodeOrAccountName(
                isPersonal: isPersonal,
                accountId: manualAccountId,
                monthYear: monthYear,
                totalAmount: totalAmount);
        emit(DebtsLoaded(
            isAnnual: loadedState.isAnnual,
            debtsPageModel: updatedDebts,
            statisticModel: mapDebtsToStatsModel(updatedDebts.allCategories
                .where((element) =>
                    loadedState.selectedCategories.contains(element))
                .toList()),
            selectedCategories: (state as DebtsLoaded).selectedCategories,
            collapsedCategories: (state as DebtsLoaded).collapsedCategories));
      } catch (e) {
        emit(DebtsError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }

  Future<void> setAccountName({
    required String id,
    required String name,
    required bool isManual,
    required bool isPersonal,
  }) async {
    if (state is DebtsLoaded) {
      var loadedState = state as DebtsLoaded;
      try {
        if (isManual) {
          await repository.setManualAccountName(
            manualAccountId: id,
            name: name,
          );
        } else {
          await repository.setBankAccountName(
            bankAccountId: id,
            name: name,
          );
        }
        var updatedModel = loadedState.debtsPageModel.copyWithNodeOrAccountName(
            accountId: id, name: name, isPersonal: isPersonal);
        emit(DebtsLoaded(
            isAnnual: loadedState.isAnnual,
            debtsPageModel: updatedModel,
            statisticModel: loadedState.statisticModel,
            selectedCategories: loadedState.selectedCategories,
            collapsedCategories: loadedState.collapsedCategories));
      } catch (e) {
        emit(DebtsError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }

  void hideCategoryFromStatistics(DebtCategory debtCategory) {
    if (state is DebtsLoaded) {
      var loadedState = state as DebtsLoaded;

      loadedState.selectedCategories.removeWhere(
        (category) => category == debtCategory,
      );

      if (!loadedState.selectedCategories.contains(debtCategory)) {
        emit(DebtsLoaded(
            isAnnual: loadedState.isAnnual,
            debtsPageModel: loadedState.debtsPageModel,
            statisticModel: mapDebtsToStatsModel(
              loadedState.debtsPageModel.allCategories
                  .where((element) =>
                      loadedState.selectedCategories.contains(element))
                  .toList(),
            ),
            selectedCategories: loadedState.selectedCategories,
            collapsedCategories: loadedState.collapsedCategories));
      }
    }
  }

  void showCategoryInStatistics(DebtCategory debtCategory) {
    if (state is DebtsLoaded) {
      var loadedState = state as DebtsLoaded;

      loadedState.selectedCategories.add(debtCategory);

      emit(DebtsLoaded(
        isAnnual: loadedState.isAnnual,
        debtsPageModel: loadedState.debtsPageModel,
        statisticModel: mapDebtsToStatsModel(
          loadedState.debtsPageModel.allCategories
              .where(
                  (element) => loadedState.selectedCategories.contains(element))
              .toList(),
        ),
        selectedCategories: loadedState.selectedCategories,
        collapsedCategories: loadedState.collapsedCategories,
      ));
    } else {
      return;
    }
  }

  void toggleExpanded(DebtCategory category, bool isExpanded) {
    if (state is DebtsLoaded) {
      var collapsedCategories = (state as DebtsLoaded).collapsedCategories;
      if (isExpanded) {
        collapsedCategories.remove(category);
      } else {
        collapsedCategories.add(category);
      }
      emit(DebtsLoaded(
          isAnnual: (state as DebtsLoaded).isAnnual,
          debtsPageModel: (state as DebtsLoaded).debtsPageModel,
          statisticModel: (state as DebtsLoaded).statisticModel,
          selectedCategories: (state as DebtsLoaded).selectedCategories,
          collapsedCategories: collapsedCategories));
    }
  }

  void uniteCategoriesWithSameName(
    List<DebtCategoryUiModel> uiModels,
    int number,
  ) {
    var autoLoans =
        uiModels.where((model) => model.categoryName == 'Auto Loan').toList();

    if (autoLoans.length == 2) {
      uiModels.removeWhere(
        (model) => model.categoryName == autoLoans.first.categoryName,
      );

      uiModels.add(
        DebtCategoryUiModel(
          id: autoLoans.first.id,
          categoryName: autoLoans.first.categoryName,
          debtAccounts:
              autoLoans.first.debtAccounts + autoLoans.last.debtAccounts,
          number: number += 1,
        ),
      );
    }

    var creditCards = uiModels
        .where((model) => model.categoryName == 'Credit Cards')
        .toList();

    if (creditCards.length == 2) {
      uiModels.removeWhere(
        (model) => model.categoryName == creditCards.first.categoryName,
      );

      uiModels.add(
        DebtCategoryUiModel(
          id: creditCards.first.id,
          categoryName: creditCards.first.categoryName,
          debtAccounts:
              creditCards.first.debtAccounts + creditCards.last.debtAccounts,
          number: number += 1,
        ),
      );
    }
  }
}
