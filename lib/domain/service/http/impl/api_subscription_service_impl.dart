import 'package:burgundy_budgeting_app/domain/model/request/checkout_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_subscription_service.dart';
import 'package:dio/src/response.dart';

class ApiSubscriptionServiceImpl extends ApiSubscriptionService {
  final String getPlansEndpoint = '/subscription/plans';
  final String getCheckoutSessionIdEndpoint = '/subscription/checkout-session';
  final String getCustomerPortalEndpoint =
      '/subscription/customer-portal-session';

  final HttpManager httpManager;

  ApiSubscriptionServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> getCheckoutSessionId(CheckoutRequest query) async {
    return await httpManager.dio.post(
      getCheckoutSessionIdEndpoint,
      data: query.toJson(),
    );
  }

  @override
  Future<Response> getPlans() async {
    return await httpManager.dio.get(
      getPlansEndpoint,
    );
  }

  @override
  Future<Response> getCustomerPortalSessionUrl(String returnUrl) async {
    return await httpManager.dio.post(
      getCustomerPortalEndpoint,
      data: {'returnUrl': returnUrl},
    );
  }
}
