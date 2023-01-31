import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/repository/investments_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/add_retirement_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRetirementCubit extends Cubit<AddRetirementState> {
  final InvestmentsRepository investmentsRepository;

  AddRetirementCubit(
    this.investmentsRepository, {
    this.retirement,
    required this.retirementType,
  }) : super(AddRetirementInitial()) {
    getModelsNameList();
  }

  final RetirementModel? retirement;
  final int retirementType;
  late List<String> listOfInvestmentNames;

  void navigationToInvestmentPage(BuildContext context) {
    NavigatorManager.navigateTo(context, InvestmentsPage.routeName,
        replace: true,
        routeSettings: RouteSettings(
          arguments: {'isRetirement': true, 'retirementTab': retirementType},
        ));
  }

  Future<void> addRetirement(
    BuildContext context, {
    required String name,
    required DateTime acquisitionDate,
    required double initialCost,
    int? investType,
    double? currentCost,
    String? custodian,
  }) async {
    try {
      emit(AddRetirementLoading());
      await investmentsRepository.addRetirement(RetirementModel(
        name: name,
        isManual: true,
        initialCost: initialCost,
        currentCost: currentCost,
        acquisitionDate: acquisitionDate,
        custodian: custodian,
        retirementType: retirementType,
        investType: investType,
      ));
      navigationToInvestmentPage(context);
    } catch (e) {
      emit(AddRetirementError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateRetirement(BuildContext context,
      {required String id,
      required String name,
      required bool isManual,
      required DateTime acquisitionDate,
      int? investType,
        String? custodian,
      required double initialCost,
      required double currentCost,
      List<InvestmentTransaction>? transactions}) async {
    emit(AddRetirementLoading());
    try {
      await investmentsRepository.updateRetirementById(RetirementModel(
          id: id,
          name: name,
          isManual: isManual,
          initialCost: initialCost,
          currentCost: currentCost,
          investType: investType,
          acquisitionDate: acquisitionDate,
          retirementType: retirementType,
          custodian: custodian,
          transactions: transactions));
      navigationToInvestmentPage(context);
    } catch (e) {
      emit(AddRetirementError(e.toString()));
      rethrow;
    }
  }

  Future<void> getModelsNameList() async {
    var list = await investmentsRepository.getRetirements();
    var listString = <String>[];
    list?.forEach((element) {
      listString.add(element.name!);
    });
    listOfInvestmentNames = listString;
  }

  Future<void> deleteRetirement(BuildContext context,
      {required RetirementModel model,
      DateTime? sellDate,
      required bool removeHistory}) async {
    emit(AddRetirementLoading());
    try {
      navigationToInvestmentPage(context);
      await investmentsRepository.deleteRetirementById(
          model, sellDate, removeHistory);
    } catch (e) {
      emit(AddRetirementError(e.toString()));
      rethrow;
    }
  }
}
