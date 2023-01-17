@JS()
library stripe;

import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:js/js.dart';

void redirectToCheckout(String sessionId) async {
  final key = ApiClient.ENV_STRIPE_API_KEY;

  final stripe = Stripe(key);
  stripe.redirectToCheckout(
    CheckoutOptions(
      sessionId: sessionId,
    ),
  );
}

@JS()
class Stripe {
  external Stripe(String key);

  external void redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
