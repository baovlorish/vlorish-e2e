import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/request/debt_node_balance_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/net_worth_node_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_bank_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_manual_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/model/response/net_worth_model.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_bank_account_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_debt_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_net_worth_service.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';

abstract class NetWorthRepository {
  NetWorthRepository(ApiNetWorthService netWorthService,
      ApiBankAccountService bankAccountService, ApiDebtsService debtsService);

  Future<NetWorthModel> fetchNetWorth(
    int year,
  );

  Future<void> setNode(
    String manualAccountId,
    int amount,
    DateTime monthYear,
    bool isAsset,
  );

  Future<void> setBankAccountName({
    required String bankAccountId,
    required String name,
  });

  Future<void> setManualAccountName({
    required String manualAccountId,
    required String name,
  });
}

class NetWorthRepositoryImpl implements NetWorthRepository {
  final String generalErrorMessage = 'Sorry, something went wrong';

  final ApiNetWorthService _netWorthService;
  final ApiBankAccountService _bankAccountService;
  final ApiDebtsService _debtsService;

  NetWorthRepositoryImpl(
      this._netWorthService, this._bankAccountService, this._debtsService);

  @override
  Future<NetWorthModel> fetchNetWorth(int year) async {
    var response = await _netWorthService.fetchNetWorth(
      year,
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return NetWorthModel.fromJson(
          response.data, Period.year(year));
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setNode(String manualAccountId, int amount, DateTime monthYear,
      bool isAsset) async {
    var response = isAsset
        ? await _netWorthService.node(NetWorthNodeRequest(
            manualAccountId: manualAccountId,
            amount: amount,
            monthYear: monthYear,
          ))
        : await _debtsService.nodeBalance(NodeBalanceRequest(
            manualAccountId: manualAccountId,
            amount: amount,
            monthYear: monthYear,
          ));

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setBankAccountName(
      {required String bankAccountId, required String name}) async {
    var response =
        await _bankAccountService.setBankAccountName(SetBankAccountNameRequest(
      bankAccountId: bankAccountId,
      name: name,
    ));
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setManualAccountName(
      {required String manualAccountId, required String name}) async {
    var response = await _bankAccountService
        .setManualAccountName(SetManualAccountNameRequest(
      manualAccountId: manualAccountId,
      name: name,
    ));
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
