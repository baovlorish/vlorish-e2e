import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/request/get_debt_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/node_interest_amount_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/node_total_amount_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_bank_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_manual_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_bank_account_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_debt_service.dart';
import 'package:burgundy_budgeting_app/ui/model/debts_page_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';

abstract class DebtsRepository {
  DebtsRepository(
    ApiDebtsService debtService,
    ApiBankAccountService bankAccountService,
  );

  Future<DebtsPageModel> fetchDebts({
    required DateTime startMonthYear,
    required int durationInMonth,
  });

  Future<void> setNodeInterestAmount({
    required String manualAccountId,
    required DateTime monthYear,
    required int interestAmount,
  });

  Future<void> setNodeTotalAmount({
    required String manualAccountId,
    required DateTime monthYear,
    required int totalAmount,
  });

  Future<void> setBankAccountName({
    required String bankAccountId,
    required String name,
  });

  Future<void> setManualAccountName({
    required String manualAccountId,
    required String name,
  });
}

class DebtsRepositoryImpl implements DebtsRepository {
  ApiDebtsService debtService;
  ApiBankAccountService bankAccountService;

  final String generalErrorMessage = 'Sorry, something went wrong';

  DebtsRepositoryImpl(this.debtService, this.bankAccountService);

  @override
  Future<DebtsPageModel> fetchDebts({
    required DateTime startMonthYear,
    required int durationInMonth,
  }) async {
    var response = await debtService.getDebts(DebtsPageModelRequest(
      startMonthYear: startMonthYear,
      durationInMonth: durationInMonth,
    ));

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return DebtsPageModel.fromJson(
          response.data, Period(startMonthYear, durationInMonth));
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setNodeInterestAmount({
    required String manualAccountId,
    required DateTime monthYear,
    required int interestAmount,
  }) async {
    var response = await debtService.nodeInterestAmount(
      NodeInterestAmountRequest(
        manualAccountId: manualAccountId,
        monthYear: monthYear,
        interestAmount: interestAmount,
      ),
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setNodeTotalAmount({
    required String manualAccountId,
    required DateTime monthYear,
    required int totalAmount,
  }) async {
    var response = await debtService.nodeTotalAmount(NodeTotalAmountRequest(
      manualAccountId: manualAccountId,
      totalAmount: totalAmount,
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
  Future<void> setBankAccountName({
    required String bankAccountId,
    required String name,
  }) async {
    var response =
        await bankAccountService.setBankAccountName(SetBankAccountNameRequest(
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
  Future<void> setManualAccountName({
    required String manualAccountId,
    required String name,
  }) async {
    var response = await bankAccountService
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
