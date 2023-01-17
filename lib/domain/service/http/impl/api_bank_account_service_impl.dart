import 'package:burgundy_budgeting_app/domain/model/request/add_manual_account_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/change_bank_account_mute_mode_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/change_manual_account_mute_mode_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_bank_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/set_manual_account_name_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/setup_bank_type_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_bank_account_service.dart';
import 'package:dio/src/response.dart';

class ApiBankAccountServiceImpl extends ApiBankAccountService {
  final withoutUsageTypeEndpoint = '/bank-account/without-usage-type';
  final bankAccountEndpoint = '/bank-account';
  final manualAccountEndpoint = '/manual-account';
  final changeBankAccountMuteModeEndpoint = '/bank-account/mute-mode';
  final changeManualAccountMuteModeEndpoint = '/manual-account/mute-mode';
  final setBankAccountNameEndpoint = '/bank-account/name';
  final setManualAccountNameEndpoint = '/manual-account/name';

  final HttpManager httpManager;

  ApiBankAccountServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> getWithoutUsageType() async {
    return await httpManager.dio.get(withoutUsageTypeEndpoint);
  }

  @override
  Future<Response> postBankAccount(SetupBankTypeRequest request) async {
    return await httpManager.dio.post(
      bankAccountEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> getBankAccount() async {
    return await httpManager.dio.get(
      bankAccountEndpoint,
    );
  }

  @override
  Future<Response> addManualAccount(AddManualAccountRequest account) async {
    return await httpManager.dio.post(
      manualAccountEndpoint,
      data: account.toJson(),
    );
  }

  @override
  Future<Response> changeBankAccountMuteMode(
      ChangeBankAccountMuteModeRequest request) async {
    return await httpManager.dio.post(
      changeBankAccountMuteModeEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> changeManualAccountMuteMode(
      ChangeManualAccountMuteModeRequest request) async {
    return await httpManager.dio.post(
      changeManualAccountMuteModeEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> deleteManualAccount(String id) async {
    return await httpManager.dio.delete(
      manualAccountEndpoint,
      data: {'id': id},
    );
  }

  @override
  Future<Response> setBankAccountName(SetBankAccountNameRequest request) async {
    return await httpManager.dio.post(
      setBankAccountNameEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> setManualAccountName(
      SetManualAccountNameRequest request) async {
    return await httpManager.dio.post(
      setManualAccountNameEndpoint,
      data: request.toJson(),
    );
  }
}
