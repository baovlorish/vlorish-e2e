import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiInstitutionAccountService {
  ApiInstitutionAccountService(HttpManager httpManager);

  Future<Response<dynamic>> getPlaidLinkToken(int index);

  Future<Response<dynamic>> getInstitutionAccount();

  Future<Response> getInstitutionAccountByType(int type);

  Future<Response<dynamic>> exchangePublicToken(String publicToken);

  Future<Response<dynamic>> deleteInstitutionAccount(
      String institutionAccountId);

  Future<Response> completeUpdateMode(String institutionAccountId,
      {bool accountsUpdate});

  Future<Response> updateMode(String institutionAccountId,
      {bool accountsUpdate});

  Future<Response> getLinkToken();
}
