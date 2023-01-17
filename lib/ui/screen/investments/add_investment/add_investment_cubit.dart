import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/repository/investments_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddInvestmentCubit extends Cubit<AddInvestmentState> {
  AddInvestmentCubit(
    this.investmentsRepository, {
    required this.currentInvestmentGroup,
  }) : super(AddInvestmentInitial()) {
    getModelsNameList();
  }

  final InvestmentsRepository investmentsRepository;
  final InvestmentGroup currentInvestmentGroup;
  late List<String> listOfInvestmentNames;

  void navigationToInvestmentPage(BuildContext context) {
    NavigatorManager.navigateTo(context, InvestmentsPage.routeName,
        replace: true,
        routeSettings: RouteSettings(
          arguments: {
            'isRetirement': false,
            'investmentTab': currentInvestmentGroup.index
          },
        ));
  }

  Future<void> addInvestment(
    BuildContext context, {
    required String name,
    required DateTime acquisitionDate,
    required double initialCost,
    String? address,
    int? usageType,
    int? exchange,
    required int? brokerage,
    double? currentCost,
    int? otherType,
  }) async {
    try {
      emit(AddInvestmentLoading());
      await investmentsRepository.addInvestment(InvestmentModel(
          name: name,
          isManual: true,
          brokerage: brokerage,
          initialCost: initialCost,
          address: address,
          usageType: usageType,
          exchange: exchange,
          currentCost: currentCost,
          acquisitionDate: acquisitionDate,
          investmentGroup: currentInvestmentGroup,
          otherType: otherType));
      navigationToInvestmentPage(context);
    } catch (e) {
      emit(AddInvestmentError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateInvestment(BuildContext context,
      {required String id,
      required String name,
      required bool isManual,
      required DateTime acquisitionDate,
      required int? brokerage,
      String? address,
      int? usageType,
      int? otherType,
      int? exchange,
      required double initialCost,
      required double currentCost,
      List<InvestmentTransaction>? transactions}) async {
    emit(AddInvestmentLoading());
    try {
      await investmentsRepository.updateInvestmentById(InvestmentModel(
          id: id,
          name: name,
          isManual: isManual,
          initialCost: initialCost,
          currentCost: currentCost,
          exchange: exchange,
          brokerage: brokerage,
          address: address,
          usageType: usageType,
          otherType: otherType,
          acquisitionDate: acquisitionDate,
          investmentGroup: currentInvestmentGroup,
          transactions: transactions));
      navigationToInvestmentPage(context);
    } catch (e) {
      emit(AddInvestmentError(e.toString()));
      rethrow;
    }
  }

  Future<void> getModelsNameList() async {
    List<InvestmentModel>? list;
    switch (currentInvestmentGroup) {
      case InvestmentGroup.Stocks:
        list = await investmentsRepository.getStocks();
        break;
      case InvestmentGroup.IndexFunds:
        list = await investmentsRepository.getIndexFunds();
        break;
      case InvestmentGroup.RealEstate:
        list = await investmentsRepository.getRealEstate();
        break;
      case InvestmentGroup.StartUps:
        list = await investmentsRepository.getStartUps();
        break;
      case InvestmentGroup.Cryptocurrencies:
        list = await investmentsRepository.getCryptocurrencies();
        break;
      case InvestmentGroup.OtherInvestments:
        list = await investmentsRepository.getOtherInvestments();
        break;
    }
    var listString = <String>[];
    list?.forEach((element) {
      listString.add(element.name!);
    });
    listOfInvestmentNames = listString;
  }

  Future<void> deleteInvestment(BuildContext context,
      {required model, DateTime? sellDate, required bool removeHistory}) async {
    emit(AddInvestmentLoading());
    try {
      navigationToInvestmentPage(context);
      if (model is InvestmentModel) {
        await investmentsRepository.deleteInvestmentById(
            model, sellDate, removeHistory);
      } else if (model is RetirementModel) {
        await investmentsRepository.deleteRetirementById(
            model, sellDate, removeHistory);
      }
    } catch (e) {
      emit(AddInvestmentError(e.toString()));
      rethrow;
    }
  }
}
