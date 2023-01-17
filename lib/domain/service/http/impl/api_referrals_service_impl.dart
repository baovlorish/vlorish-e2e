import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_referral_service.dart';
import 'package:dio/src/response.dart';

class ApiReferralServiceImpl extends ApiReferralService {
  ApiReferralServiceImpl(this.httpManager);
  final HttpManager httpManager;
  final String getReferralsEndpoint = '/referrals';
  final String getReferralsSSOEndpoint = '/referrals/sso';

  @override
  Future<Response> getReferrals() async {
    return await httpManager.dio.get(getReferralsEndpoint);
  }

  @override
  Future<Response> getReferralsSSO() async {
    return await httpManager.dio.get(getReferralsSSOEndpoint);
  }
}
