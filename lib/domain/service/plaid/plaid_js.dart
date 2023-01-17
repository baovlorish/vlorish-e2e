@JS()
library _plaid_js;

import 'package:js/js.dart';

@JS('Plaid')
class PlaidJs {
  external static PlaidJs create(PlaidJsOptions options);

  external void open();

  external void exit();

  external void destroy();
}

@JS()
@anonymous
class PlaidJsOptions {
  external String get clientName;

  external List<dynamic> get countryCodes;

  external String get env;

  external String get key;

  external String get token;

  external List<dynamic> get product;

  external PlaidJsAccountSubtypeOptions get accountSubtypes;

  external String get webhook;

  external String get language;

  external String get linkCustomizationName;

  external String get oauthNonce;

  external String get oauthRedirectUri;

  external String get oauthStateId;

  external String get paymentToken;

  external void Function() get onLoad;

  external void Function(String publicToken, dynamic metadata) get onSuccess;

  external void Function(dynamic error, dynamic metadata) get onExit;

  external void Function(String eventName, dynamic metadata) get onEvent;

  external factory PlaidJsOptions({
    String clientName,
    List<String>? countryCodes,
    String key,
    String token,
    String env,
    List<String>? product,
    PlaidJsAccountSubtypeOptions? accountSubtypes,
    String webhook,
    String language,
    String linkCustomizationName,
    String oauthNonce,
    String oauthRedirectUri,
    String oauthStateId,
    String paymentToken,
    void Function() onLoad,
    void Function(String publicToken, PlaidJsSuccessMetadata metadata)
        onSuccess,
    void Function(PlaidJsError? error, PlaidJsExitMetadata metadata) onExit,
    void Function(String eventName, PlaidJsEventMetadata metadata) onEvent,
  });
}

@JS()
@anonymous
class PlaidJsAccountSubtypeOptions {
  external List<String> get investment;

  external set investment(List<String> set);

  external List<String> get credit;

  external set credit(List<String> set);

  external List<String> get depository;

  external set depository(List<String> set);

  external List<String> get loan;

  external set loan(List<String> set);

  external List<String> get other;

  external set other(List<String> set);

  external factory PlaidJsAccountSubtypeOptions({
    List<String> investment,
    List<String> credit,
    List<String> depository,
    List<String> loan,
    List<String> other,
  });
}

@JS()
@anonymous
class PlaidJsEventMetadata {
  external String get error_code;

  external String get errorMessage;

  external String get errorType;

  external String get exit_status;

  external String get institution_id;

  external String get institution_name;

  external String get institution_search_query;

  external String get link_session_id;

  external String get mfa_type;

  external String get request_id;

  external String get timestamp;

  external String get view_name;

  external factory PlaidJsEventMetadata({
    String error_code,
    String error_message,
    String error_type,
    String exit_status,
    String institution_id,
    String institution_name,
    String institution_search_query,
    String link_session_id,
    String mfa_type,
    String request_id,
    String timestamp,
    String view_name,
  });
}

@JS()
@anonymous
class PlaidJsSuccessMetadata {
  external String get link_session_id;

  external PlaidJsInstitution get institution;

  external List<PlaidJsAccount> get accounts;

  external factory PlaidJsSuccessMetadata({
    String link_session_id,
    PlaidJsInstitution institution,
    List<PlaidJsAccount> accounts,
  });
}

@JS()
@anonymous
class PlaidJsExitMetadata {
  external String get link_session_id;

  external String get request_id;

  external PlaidJsInstitution get institution;

  external String get status;

  external factory PlaidJsExitMetadata({
    String name,
    String request_id,
    PlaidJsInstitution institution,
    String status,
  });
}

@JS()
@anonymous
class PlaidJsInstitution {
  external String get name;

  external String get institution_id;

  external factory PlaidJsInstitution({
    String name,
    String institution_id,
  });
}

@JS()
@anonymous
class PlaidJsAccount {
  external String get id;

  external String get name;

  external String get mask;

  external String get type;

  external String get subtype;

  external String get verificationStatus;

  external factory PlaidJsAccount({
    String id,
    String name,
    String mask,
    String type,
    String subtype,
    String verificationStatus,
  });
}

@JS()
@anonymous
class PlaidJsError {
  external String get displayMessage;

  external String get errorCode;

  external String get errorMessage;

  external String get errorType;

  external factory PlaidJsError({
    String displayMessage,
    String errorCode,
    String errorMessage,
    String errorType,
  });
}
