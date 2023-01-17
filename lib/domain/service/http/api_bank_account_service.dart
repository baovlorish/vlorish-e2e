import 'package:burgundy_budgeting_app/domain/model/request/add_manual_account_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/change_bank_account_mute_mode_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/change_manual_account_mute_mode_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_bank_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_manual_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/setup_bank_type_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiBankAccountService {
  ApiBankAccountService(HttpManager httpManager);

  Future<Response<dynamic>> getWithoutUsageType();

  Future<Response<dynamic>> postBankAccount(SetupBankTypeRequest request);

  Future<Response<dynamic>> getBankAccount();

  Future<Response<dynamic>> addManualAccount(AddManualAccountRequest account);

  Future<Response<dynamic>> changeBankAccountMuteMode(
      ChangeBankAccountMuteModeRequest request);

  Future<Response<dynamic>> changeManualAccountMuteMode(
      ChangeManualAccountMuteModeRequest request);

  Future<Response<dynamic>> deleteManualAccount(String id);

  Future<Response<dynamic>> setBankAccountName(
      SetBankAccountNameRequest request);

  Future<Response<dynamic>> setManualAccountName(
      SetManualAccountNameRequest request);
}
