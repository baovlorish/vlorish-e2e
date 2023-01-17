import 'package:burgundy_budgeting_app/domain/network/api_client.dart';

class CheckoutRequest {
  final String priceId;
  final bool isSignUp;
  final String cancelUrl = '${ApiClient.ENV_BASE_URL}subscription';
  final String successUrl = '${ApiClient.ENV_BASE_URL}signup_add_card';

  CheckoutRequest({
    required this.priceId,
    this.isSignUp = false,
  });

  Map<String, dynamic>? toJson() {
    return {
      'priceId': priceId,
      'cancelUrl': isSignUp ? '$cancelUrl?type=signup' : cancelUrl,
      'successUrl': successUrl,
    };
  }
}
