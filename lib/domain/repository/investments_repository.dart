import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/response/index_funds_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/retirements_models.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_investments_service.dart';

abstract class InvestmentsRepository {
  Future<List<RetirementModel>?> getRetirements();

  Future<RetirementModel?> getRetirementById(String id);

  Future<List<AvailableInvestment>?> getAvailableRetirements(int type);

  Future<RetirementModel> addRetirement(RetirementModel model);

  Future<void> availableRetirementAttach(
      List<AttachInvestmentRetirementModel> models, int type);

  Future<void> deleteRetirementById(
      RetirementModel model, DateTime? sellDate, bool removeHistory);

  Future<void> updateRetirementById(RetirementModel model);

  Future<List<InvestmentModel>?> getIndexFunds();

  Future<List<InvestmentModel>?> getStocks();

  Future<List<InvestmentModel>?> getStartUps();

  Future<List<InvestmentModel>?> getCryptocurrencies();

  Future<List<InvestmentModel>?> getOtherInvestments();

  Future<List<InvestmentModel>?> getRealEstate();

  Future<InvestmentModel?> addInvestment(InvestmentModel model);

  Future getInvestmentWithTransactionsById(InvestmentModel model);

  Future<void> deleteInvestmentById(
      InvestmentModel model, DateTime? sellDate, bool removeHistory);

  Future<InvestmentModel?> updateInvestmentById(InvestmentModel model);

  Future<InvestmentsDashboardModel> getInvestmentsDashboardData();

  Future<List<AvailableInvestment>?> getAvailableInvestment(
      InvestmentGroup investmentGroup);

  Future<void> availableInvestmentAttach(InvestmentGroup investmentGroup,
      List<AttachInvestmentRetirementModel> attachModel);
}

class InvestmentsRepositoryImp implements InvestmentsRepository {
  final ApiInvestmentsService _apiInvestmentsService;
  final String generalErrorMessage = 'Sorry, something went wrong';

  InvestmentsRepositoryImp(this._apiInvestmentsService);

  @override
  Future<List<InvestmentModel>?> getIndexFunds() async {
    var response =
        await _apiInvestmentsService.getInvestment(InvestmentGroup.IndexFunds);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <InvestmentModel>[];
      for (var item in response.data) {
        final investment =
            InvestmentModel.fromJson(item, InvestmentGroup.IndexFunds);
        result.add(investment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<InvestmentModel>?> getStocks() async {
    var response =
        await _apiInvestmentsService.getInvestment(InvestmentGroup.Stocks);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <InvestmentModel>[];
      for (var item in response.data) {
        final investment =
            InvestmentModel.fromJson(item, InvestmentGroup.Stocks);
        result.add(investment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<InvestmentModel>?> getStartUps() async {
    var response =
        await _apiInvestmentsService.getInvestment(InvestmentGroup.StartUps);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <InvestmentModel>[];
      for (var item in response.data) {
        final investment =
            InvestmentModel.fromJson(item, InvestmentGroup.StartUps);
        result.add(investment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<InvestmentModel>?> getCryptocurrencies() async {
    var response = await _apiInvestmentsService
        .getInvestment(InvestmentGroup.Cryptocurrencies);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <InvestmentModel>[];
      for (var item in response.data) {
        final investment =
            InvestmentModel.fromJson(item, InvestmentGroup.Cryptocurrencies);
        result.add(investment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<InvestmentModel>?> getOtherInvestments() async {
    var response = await _apiInvestmentsService
        .getInvestment(InvestmentGroup.OtherInvestments);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <InvestmentModel>[];
      for (var item in response.data) {
        final investment =
            InvestmentModel.fromJson(item, InvestmentGroup.OtherInvestments);
        result.add(investment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<InvestmentModel>?> getRealEstate() async {
    var response =
        await _apiInvestmentsService.getInvestment(InvestmentGroup.RealEstate);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <InvestmentModel>[];
      for (var item in response.data) {
        final investment =
            InvestmentModel.fromJson(item, InvestmentGroup.RealEstate);
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
  Future<List<AvailableInvestment>> getAvailableInvestment(
      InvestmentGroup investmentGroup) async {
    var response =
        await _apiInvestmentsService.getAvailableInvestment(investmentGroup);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <AvailableInvestment>[];
      for (var item in response.data) {
        final availableInvestment = AvailableInvestment.fromJson(item);
        result.add(availableInvestment);
      }
      return result;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future availableInvestmentAttach(InvestmentGroup investmentGroup,
      List<AttachInvestmentRetirementModel> attachModel) async {
    var response = await _apiInvestmentsService.availableInvestmentAttach(
        investmentGroup, attachModel);
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
  Future<void> availableRetirementAttach(
      List<AttachInvestmentRetirementModel> models, int type) async {
    var jsonData = <Map<String, dynamic>>[];
    for (var item in models) {
      var json = item.toJson();
      json['retirementType'] = type;
      jsonData.add(json);
    }

    var response =
        await _apiInvestmentsService.availableRetirementAttach(jsonData);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
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
  Future<List<AvailableInvestment>?> getAvailableRetirements(int type) async {
    var response = await _apiInvestmentsService.getAvailableRetirements(type);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <AvailableInvestment>[];
      for (var item in response.data) {
        final availableInvestment = AvailableInvestment.fromJson(item);
        result.add(availableInvestment);
      }
      return result;
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
