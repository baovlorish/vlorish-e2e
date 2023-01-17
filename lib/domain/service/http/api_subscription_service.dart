import 'package:burgundy_budgeting_app/domain/model/request/checkout_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiSubscriptionService {
  ApiSubscriptionService(HttpManager httpManager);

  Future<Response<dynamic>> getPlans();

  Future<Response<dynamic>> getCheckoutSessionId(CheckoutRequest query);

  Future<Response<dynamic>> getCustomerPortalSessionUrl(String returnUrl);
}
