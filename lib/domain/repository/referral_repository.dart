import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/response/referral_response.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_referral_service.dart';

abstract class ReferralRepository {
  Future<ReferralResponse> getReferrals();

  Future<ReferralSSOResponse> getReferralsSSO();
}

class ReferralRepositoryImpl implements ReferralRepository {
  final ApiReferralService referralService;

  ReferralRepositoryImpl(this.referralService);

  final String generalErrorMessage = 'Sorry, something went wrong';

  @override
  Future<ReferralResponse> getReferrals() async {
    var response = await referralService.getReferrals();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return ReferralResponse.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<ReferralSSOResponse> getReferralsSSO() async {
    var response = await referralService.getReferralsSSO();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return ReferralSSOResponse.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
