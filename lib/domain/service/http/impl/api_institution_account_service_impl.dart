import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_institution_account_service.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';

class ApiInstitutionAccountServiceImpl extends ApiInstitutionAccountService {
  final getLinkTokenEndpoint = '/institution-account/link-token';
  final completeUpdateModeEndpoint =
      '/institution-account/complete-update-mode';
  final updateModeEndpoint = '/institution-account/update-mode';
  final exchangePublicTokenEndpoint =
      '/institution-account/exchange-public-token';
  final institutionAccountEndpoint = '/institution-account';
  final HttpManager httpManager;

  final accountsUpdateModeEndpoint =
      '/institution-account/update-account-selection';

  final accountsCompleteUpdateModeEndpoint =
      '/institution-account/complete-update-account-selection';

  ApiInstitutionAccountServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> getPlaidLinkToken(int index) async {
    return await httpManager.dio.post(
      getLinkTokenEndpoint,
      data: {'type': index},
    );
  }

  @override
  Future<Response> exchangePublicToken(String publicToken) async {
    return await httpManager.dio.post(
      exchangePublicTokenEndpoint,
      data: {'publicToken': publicToken},
    );
  }

  @override
  Future<Response> getInstitutionAccount() async {
    return await httpManager.dio.get(institutionAccountEndpoint);
  }

  @override
  Future<Response> deleteInstitutionAccount(String institutionAccountId) async {
    return await httpManager.dio.delete(
      institutionAccountEndpoint,
      data: {'institutionAccountId': institutionAccountId},
    );
  }

  @override
  Future<Response> completeUpdateMode(String institutionAccountId,
      {bool accountsUpdate = false}) async {
    return await httpManager.dio.post(
      accountsUpdate
          ? accountsCompleteUpdateModeEndpoint
          : completeUpdateModeEndpoint,
      data: {'institutionAccountId': institutionAccountId},
    );
  }

  @override
  Future<Response> getLinkToken() async {
    return await httpManager.dio.post(
      getLinkTokenEndpoint,
    );
  }

  @override
  Future<Response> updateMode(String institutionAccountId,
      {bool accountsUpdate = false}) async {
    return await httpManager.dio.post(
      accountsUpdate ? accountsUpdateModeEndpoint : updateModeEndpoint,
      data: {'institutionAccountId': institutionAccountId},
    );
  }
}
