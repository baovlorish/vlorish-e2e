import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/repository/investments_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/add_retirement_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/edit_retirement_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/edit_investment/edit_investment_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'investments_page.dart';
import 'investments_state.dart';

class InvestmentsCubit extends Cubit<InvestmentsState> {
  final Logger logger = getLogger('InvestmentsCubit');
  final InvestmentsRepository investmentRepository;

  InvestmentsCubit(this.investmentRepository,
      {required bool isRetirement, int? investmentTab, int? retirementTab})
      : super(InvestmentsInitial()) {
    logger.i('isRetirement $isRetirement');
    if (isRetirement && retirementTab != null) {
      loadRetirements(retirementTab: retirementTab);
    } else {
      loadInvestments(tab: investmentTab ?? 0);
    }
  }

  Future<void> loadInvestments({int? tab, int? retirementTab}) async {
    var dashboardData =
        await investmentRepository.getInvestmentsDashboardData();
    var investments = await getInvestments(tab ?? 0);

    emit(
      InvestmentsLoaded(
          isRetirement: false,
          investmentsTab: tab ?? 0,
          retirementTab: retirementTab ?? 0,
          dashboardData: dashboardData,
          investments: investments),
    );
  }

  Future<void> loadRetirements({int retirementTab = 1}) async {
    await loadInvestments(retirementTab: retirementTab);
    await changeTopTab(
        isRetirement: true,
        retirementTab: retirementTab);
  }

  Future<void> changeTopTab(
      {required bool isRetirement, int retirementTab = 1}) async {
    if (state is InvestmentsLoaded) {
      var retirements;
      if (isRetirement) {
        retirements = await investmentRepository.getRetirements();
      }
      var page = isRetirement ? RetirementPageModel(models: retirements) : null;
      emit(
        (state as InvestmentsLoaded).copyWith(
          isRetirement: isRetirement,
          investmentsTab: 0,
          retirements: page,
          retirementTab: retirementTab,
          retirementGrowth: page?.availableTypes,
          retirementAllocations: page?.availableTypes,
          chosenRetirementTabs: page?.chosenRetirements ?? [],
        ),
      );
    }
  }

  void changeInvestmentGrowth(int index, bool element) {
    if (state is InvestmentsLoaded) {
      var investmentGrowth = <bool>[];
      for (var i = 0;
          i < (state as InvestmentsLoaded).selectedInvestmentsGrowth.length;
          i++) {
        if (i == index) {
          investmentGrowth.add(element);
        } else {
          investmentGrowth
              .add((state as InvestmentsLoaded).selectedInvestmentsGrowth[i]);
        }
      }
      emit((state as InvestmentsLoaded)
          .copyWith(selectedInvestmentsGrowth: investmentGrowth));
    }
  }

  void changeRetirementGrowth(int index, bool element) {
    if (state is InvestmentsLoaded) {
      var growth = (state as InvestmentsLoaded).retirementGrowth;

      if (element) {
        growth.add(index);
      } else {
        growth.remove(index);
      }
      growth.sort();
      emit((state as InvestmentsLoaded).copyWith(retirementGrowth: growth));
    }
  }

  void changeRetirementAllocations(int index, bool element) {
    if (state is InvestmentsLoaded) {
      var allocations = (state as InvestmentsLoaded).retirementAllocations;

      if (element) {
        allocations.add(index);
      } else {
        allocations.remove(index);
      }
      allocations.sort();
      emit((state as InvestmentsLoaded)
          .copyWith(retirementAllocations: allocations));
    }
  }

  void changeAllocations(int index, bool element) {
    if (state is InvestmentsLoaded) {
      var allocations = <bool>[];
      for (var i = 0;
          i < (state as InvestmentsLoaded).selectedAllocations.length;
          i++) {
        if (i == index) {
          allocations.add(element);
        } else {
          allocations.add((state as InvestmentsLoaded).selectedAllocations[i]);
        }
      }
      emit((state as InvestmentsLoaded)
          .copyWith(selectedAllocations: allocations));
    }
  }

  void selectRetirementTab(int index) {
    emit((state as InvestmentsLoaded)
        .copyWith(retirementTab: index, isRetirement: true));
  }

  void selectChosenRetirementTabs(List<int> newTabs) {
    emit(
      (state as InvestmentsLoaded).copyWith(
          chosenRetirementTabs: newTabs,
          retirementTab: newTabs.isNotEmpty &&
                  newTabs.contains((state as InvestmentsLoaded).retirementTab)
              ? null
              : newTabs.first),
    );
  }

  Future<void> selectTab(int index,
      {InvestmentsDashboardModel? dashboardData}) async {
    var prevState = state as InvestmentsLoaded;

    List<InvestmentModel>? investments;
    try {
      investments = await getInvestments(index);
      emit((state as InvestmentsLoaded).copyWith(
          investmentsTab: index,
          investments: investments,
          dashboardData: dashboardData));
    } catch (e) {
      emit(InvestmentsError(e.toString()));
      emit(prevState);
    }
  }

  Future<void> deleteInvestmentOrRetirement(BuildContext context,
      {required model, DateTime? sellDate, required bool removeHistory}) async {
    var prevState = state as InvestmentsLoaded;
    try {
      if (model is InvestmentModel) {
        await investmentRepository.deleteInvestmentById(model, sellDate, removeHistory);
        var dashboardData = await investmentRepository.getInvestmentsDashboardData();
        await selectTab(
          (state as InvestmentsLoaded).investmentsTab,
          dashboardData: dashboardData,
        );
      } else if (model is RetirementModel) {
        await investmentRepository.deleteRetirementById(model, sellDate, removeHistory);
        var newRetirements = await investmentRepository.getRetirements();
        var retirementPage = RetirementPageModel(models: newRetirements ?? []);
        emit(prevState.copyWith(retirements: retirementPage));
      }
    } catch (e) {
      emit(InvestmentsError(e.toString()));
      emit(prevState);
    }
  }

  Future<List<AvailableInvestment>?> getAvailableInvestment(
      InvestmentGroup investmentGroup) async {
    var availableInvestments =
        await investmentRepository.getAvailableInvestment(investmentGroup);
    return availableInvestments;
  }

  Future<List<AvailableInvestment>?> getAvailableRetirements() async {
    var availableRetirements = await investmentRepository
        .getAvailableRetirements((state as InvestmentsLoaded).retirementTab);
    return availableRetirements;
  }

  Future<void> availableInvestmentAttach(
      List<AttachInvestmentRetirementModel> chosenAvailableInvestments,
      InvestmentGroup investmentGroup) async {
    await investmentRepository.availableInvestmentAttach(
        investmentGroup, chosenAvailableInvestments);
  }

  Future<void> availableRetirementAttach(
      List<AttachInvestmentRetirementModel> chosenAvailableInvestments,
      int type) async {
    var prevState = state;
    try {
      await investmentRepository.availableRetirementAttach(
          chosenAvailableInvestments, type);
    } catch (e) {
      emit(InvestmentsError(e.toString()));
      emit(prevState);
    }

    var retirements = await investmentRepository.getRetirements();
    emit((prevState as InvestmentsLoaded)
        .copyWith(retirements: RetirementPageModel(models: retirements ?? [])));
  }

  Future<List<InvestmentModel>?> getInvestments(int investIndex) async {
    switch (investIndex) {
      case 0:
        return await investmentRepository.getStocks();
      case 1:
        return await investmentRepository.getIndexFunds();
      case 2:
        return await investmentRepository.getCryptocurrencies();
      case 3:
        return await investmentRepository.getRealEstate();
      case 4:
        return await investmentRepository.getStartUps();
      case 5:
        return await investmentRepository.getOtherInvestments();
    }
  }

  void navigateToAddInvestmentPage(BuildContext context,
      {required InvestmentGroup investmentGroup}) async {
    NavigatorManager.navigateTo(context, AddInvestmentPage.routeName,
        routeSettings: RouteSettings(arguments: investmentGroup));
  }

  void navigateToAddRetirementPage(BuildContext context,
      {required int retirementType}) async {
    NavigatorManager.navigateTo(context, AddRetirementPage.routeName,
        routeSettings: RouteSettings(arguments: retirementType));
  }

  void navigateToEditInvestmentPage(BuildContext context,
      {required InvestmentModel investment}) {
    NavigatorManager.navigateTo(
      context,
      EditInvestmentPage.routeName,
      routeSettings: RouteSettings(arguments: investment),
    );
  }

  void navigateToEditRetirementPage(BuildContext context,
      {required RetirementModel model}) {
    NavigatorManager.navigateTo(
      context,
      EditRetirementPage.routeName,
      routeSettings: RouteSettings(arguments: model),
    );
  }

  void navigationToInvestmentPage(BuildContext context) {
    NavigatorManager.navigateTo(context, InvestmentsPage.routeName,
        replace: true,
        routeSettings: RouteSettings(
          arguments: {'isRetirement': true, 'retirementTab': 0},
        ));
  }
}
