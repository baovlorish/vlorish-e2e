import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/request/checkout_request.dart';
import 'package:burgundy_budgeting_app/domain/model/response/plan_response.dart';
import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_subscription_service.dart';
import 'package:burgundy_budgeting_app/ui/model/subscription_plan_model.dart';

abstract class SubscriptionRepository {
  Future<String> getCheckoutSessionId(String priceId, {bool isSignUp = false});

  Future<List<SubscriptionPlanModel>> getPlans();

  Future<String> getCustomerPortalUrl(String returnUrl);
}

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiSubscriptionService _apiSubscriptionService;
  final String generalErrorMessage = 'Sorry, something went wrong';
  final String alreadySubscribedMessage =
      'The subscription is open. Consider redirecting to the Customer Portal to manage the subscription.';
  final String alreadySubscribedErrorMessage = 'You have already subscribed';

  SubscriptionRepositoryImpl(this._apiSubscriptionService);

  @override
  Future<String> getCheckoutSessionId(String priceId,
      {bool isSignUp = false}) async {
    var response = await _apiSubscriptionService.getCheckoutSessionId(
      CheckoutRequest(
        priceId: priceId,
        isSignUp: isSignUp,
      ),
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['checkoutSessionId'];
    } else if (response.data['message'] != null) {
      if (response.data['message'] == alreadySubscribedMessage) {
        throw CustomException(alreadySubscribedErrorMessage);
      } else {
        throw Exception(response.data['message']);
      }
    } else {
      throw Exception(generalErrorMessage);
    }
  }

  @override
  Future<List<SubscriptionPlanModel>> getPlans() async {
    var response = await _apiSubscriptionService.getPlans();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var result = <SubscriptionPlanModel>[];
      for (var item in response.data['plans']) {
        result.add(
          SubscriptionPlanModel.fromResponse(
            PlanResponse.fromJson(item),
          ),
        );
      }
      return result;
    } else {
      throw Exception(generalErrorMessage);
    }
  }

  @override
  Future<String> getCustomerPortalUrl(String routeName) async {
    var returnUrl = ApiClient.ENV_BASE_URL + routeName.replaceFirst('/', '');
    var response =
        await _apiSubscriptionService.getCustomerPortalSessionUrl(returnUrl);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['customerPortalUrl'];
    } else {
      throw Exception(generalErrorMessage);
    }
  }
}
