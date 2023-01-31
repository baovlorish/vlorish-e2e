import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_investments_service.dart';

abstract class InvestmentsRepository {
  Future<List<RetirementModel>?> getRetirements();

  Future<RetirementModel?> getRetirementById(String id);

  Future<RetirementModel> addRetirement(RetirementModel model);

  Future<void> deleteRetirementById(
      RetirementModel model, DateTime? sellDate, bool removeHistory);

  Future<void> updateRetirementById(RetirementModel model);

  Future<List<InvestmentModel>?> getInvestmentType(
      InvestmentGroup investmentGroup);

  Future<InvestmentModel?> addInvestment(InvestmentModel model);

  Future getInvestmentWithTransactionsById(InvestmentModel model);

  Future<void> deleteInvestmentById(
      InvestmentModel model, DateTime? sellDate, bool removeHistory);

  Future<InvestmentModel?> updateInvestmentById(InvestmentModel model);

  Future<InvestmentsDashboardModel> getInvestmentsDashboardData();
}

class InvestmentsRepositoryImp implements InvestmentsRepository {
  final ApiInvestmentsService _apiInvestmentsService;
  final String generalErrorMessage = 'Sorry, something went wrong';

  InvestmentsRepositoryImp(this._apiInvestmentsService);

  @override
  Future<List<InvestmentModel>?> getInvestmentType(
      InvestmentGroup investmentGroup) async {
    var response = await _apiInvestmentsService.getInvestment(investmentGroup);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <InvestmentModel>[];
      for (var item in response.data) {
        final investment = InvestmentModel.fromJson(item, investmentGroup);
        result.add(investment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<InvestmentModel?> addInvestment(InvestmentModel model) async {
    var response = await _apiInvestmentsService.addInvestment(model);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return InvestmentModel.fromJson(response.data, model.investmentGroup);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<InvestmentModel?> updateInvestmentById(InvestmentModel model) async {
    var response =
        await _apiInvestmentsService.addTransactionsToInvestmentById(model);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return InvestmentModel.fromJson(response.data, model.investmentGroup);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> deleteInvestmentById(
      InvestmentModel model, DateTime? sellDate, bool removeHistory) async {
    var response = await _apiInvestmentsService.deleteInvestmentById(
        model, sellDate, removeHistory);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<InvestmentModel> getInvestmentWithTransactionsById(
      InvestmentModel model) async {
    var response =
        await _apiInvestmentsService.getInvestmentWithTransactions(model);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final indexFund =
          InvestmentModel.fromJson(response.data, model.investmentGroup);
      return indexFund;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<InvestmentsDashboardModel> getInvestmentsDashboardData() async {
    var response = await _apiInvestmentsService.getInvestmentsDashboardData();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return InvestmentsDashboardModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<RetirementModel> addRetirement(RetirementModel model) async {
    var response = await _apiInvestmentsService.addRetirement(model);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return RetirementModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> deleteRetirementById(
      RetirementModel model, DateTime? sellDate, bool removeHistory) async {
    var response = await _apiInvestmentsService.deleteRetirementById(
        model, sellDate, removeHistory);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<RetirementModel>?> getRetirements() async {
    var response = await _apiInvestmentsService.getRetirements();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <RetirementModel>[];
      for (var item in response.data) {
        final investment = RetirementModel.fromJson(item);
        result.add(investment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> updateRetirementById(RetirementModel model) async {
    var response = await _apiInvestmentsService.updateRetirementById(model);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<RetirementModel?> getRetirementById(String id) async {
    var response = await _apiInvestmentsService.getRetirementById(id);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return RetirementModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
