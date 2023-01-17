import 'dart:async';
import 'dart:js';
import 'package:burgundy_budgeting_app/domain/service/plaid/plaid_js.dart';

/// Entry point to the Plaid Link.
///
/// For up-to-date and more detailed documentation, see the Plaid docs:
/// https://plaid.com/docs/#integrating-with-link
class PlaidLink {
  /// Starts the Plaid Link interface.
  /// Returns a future which resolves once the call is complete.
  /// Callbacks may be passed in to respond to various events.
  static Future<void> open(
    PlaidLinkOptions options, {
    PlaidSuccessCallback? onSuccess,
    PlaidEventCallback? onEvent,
    PlaidExitCallback? onExit,
  }) async {
    var linkToken = options.linkToken!;

    PlaidJs.create(PlaidJsOptions(
      token: linkToken,
      onLoad: allowInterop(() {}),
      onEvent: allowInterop((event, metadata) {
        onEvent?.call(event, metadata);
      }),
      onSuccess: allowInterop((publicToken, metadata) {
        onSuccess?.call(publicToken, metadata);
      }),
      onExit: allowInterop((error, metadata) {
        onExit?.call(error, metadata);
      }),
    )).open();
  }
}

/// Plaid open options
///
/// For up-to-date and more detailed documentation, see the Plaid docs:
/// https://plaid.com/docs/#integrating-with-link
class PlaidLinkOptions {
  const PlaidLinkOptions({
    this.clientName,
    this.env,
    this.products,
    this.linkToken,
    this.publicKey,
    this.webhook,
    this.accountSubtypes,
    this.linkCustomizationName,
    this.language,
    this.countryCodes,
  });

  /// Plaid client name.
  final String? clientName;

  /// The environment to use.
  final PlaidEnv? env;

  /// LinkToken
  final String? linkToken;

  /// The public key for your Plaid account.
  final String? publicKey;

  /// The webhook to use for receiving item/transaction updates from Plaid.
  final String? webhook;

  /// Plaid products to use for this link.
  final List<PlaidProduct>? products;

  /// Account subtypes to filter to.
  final List<PlaidAccountSubtype>? accountSubtypes;

  /// Name of a custom link customization.
  final String? linkCustomizationName;

  /// The language to use (may be required on some platforms).
  final String? language;

  /// List of country codes (may change behavior of the link).
  final List<String>? countryCodes;
}

/// Plaid environments.
enum PlaidEnv {
  sandbox,
  development,
  production,
}

/// Plaid product types.
enum PlaidProduct {
  auth,
  transactions,
  identity,
  income,
  assets,
  investments,
  liabilities,
  payment_initiation,
}

/// Plaid account subtypes (prefixed by the account type).
enum PlaidAccountSubtype {
  credit_credit_card,
  credit_paypal,
  depository_cash_management,
  depository_cd,
  depository_checking,
  depository_hsa,
  depository_savings,
  depository_money_market,
  depository_paypal,
  depository_prepaid,
  loan_auto,
  loan_commercial,
  loan_construction,
  loan_consumer,
  loan_home_equity,
  loan_loan,
  loan_mortgage,
  loan_overdraft,
  loan_line_of_credit,
  loan_student,
  other_other,
}

/// Callback used for handling success.
typedef PlaidSuccessCallback = void Function(
    String publicToken, PlaidJsSuccessMetadata metadata);

/// Metadata related to the success.
class PlaidSuccessMetadata {
  PlaidSuccessMetadata._({
    this.linkSessionId,
    this.institution,
    this.accounts,
  });

  factory PlaidSuccessMetadata.fromMap(Map<dynamic, dynamic> map) {
    return PlaidSuccessMetadata._(
      linkSessionId: map['linkSessionId'],
      institution: map['institution'] == null
          ? null
          : PlaidInstitution.fromMap(map['institution']),
      accounts: PlaidAccount.fromMaps(map['accounts']),
    );
  }

  final String? linkSessionId;
  final PlaidInstitution? institution;
  final List<PlaidAccount>? accounts;
}

/// Data that identifies an institution.
class PlaidInstitution {
  PlaidInstitution._({
    this.name,
    this.id,
  });

  factory PlaidInstitution.fromMap(Map<dynamic, dynamic> map) {
    return PlaidInstitution._(
      name: map['name'],
      id: map['id'],
    );
  }

  /// The institution name.
  final String? name;

  /// The institution id.
  final String? id;
}

/// An account returned from the Plaid SDK.
class PlaidAccount {
  PlaidAccount._({
    this.id,
    this.name,
    this.mask,
    this.type,
    this.subtype,
    this.verificationStatus,
  });

  factory PlaidAccount.fromMap(Map<dynamic, dynamic> map) {
    return PlaidAccount._(
      id: map['id'],
      name: map['name'],
      mask: map['mask'],
      type: map['type'],
      subtype: map['subtype'],
      verificationStatus: map['verificationStatus'],
    );
  }

  static List<PlaidAccount> fromMaps(List<dynamic> list) {
    return list.map((e) => PlaidAccount.fromMap(e)).toList();
  }

  /// The account id.
  final String? id;

  /// The account name.
  final String? name;

  /// The account number (masked).
  final String? mask;

  /// The account type.
  final String? type;

  /// The account subtype.
  final String? subtype;

  /// The accounts verification status.
  final String? verificationStatus;
}

/// Callback used for handling exiting.
/// The [error] may be null in the case there was no error which caused the exit.
typedef PlaidExitCallback = void Function(
    PlaidJsError? error, PlaidJsExitMetadata metadata);

/// An error returned from the Plaid SDK.
class PlaidError {
  PlaidError._({
    this.errorCode,
    this.errorMessage,
    this.errorType,
    this.displayMessage,
  });

  factory PlaidError.fromMap(Map<dynamic, dynamic> map) {
    return PlaidError._(
      errorCode: map['errorCode'],
      errorMessage: map['errorMessage'],
      errorType: map['errorType'],
      displayMessage: map['displayMessage'],
    );
  }

  /// The error code.
  final String? errorCode;

  /// The error message.
  final String? errorMessage;

  /// The error type.
  final String? errorType;

  /// The display message.
  final String? displayMessage;
}

/// Data related to exiting the Plaid interface.
class PlaidExitMetadata {
  PlaidExitMetadata._({
    this.exitStatus,
    this.institution,
    this.linkSessionId,
    this.requestId,
    this.status,
  });

  factory PlaidExitMetadata.fromMap(Map<dynamic, dynamic> map) {
    return PlaidExitMetadata._(
      exitStatus: map['exitStatus'],
      institution: map['institution'] == null
          ? null
          : PlaidInstitution.fromMap(map['institution']),
      linkSessionId: map['linkSessionId'],
      requestId: map['requestId'],
      status: map['status'],
    );
  }

  /// The exit status.
  final String? exitStatus;

  /// The institution.
  final PlaidInstitution? institution;

  /// The link session id.
  final String? linkSessionId;

  /// The request id.
  final String? requestId;

  /// The "status"... Plaid does not make it clear.
  final String? status;
}

/// Callback used for handling events.
typedef PlaidEventCallback = void Function(
    String event, PlaidJsEventMetadata metadata);

/// The name of a Plaid event.
enum PlaidEventName {
  error,
  exit,
  handoff,
  open,
  open_my_plaid,
  other,
  search_institution,
  select_institution,
  submit_credentials,
  submit_mfa,
  transition_view
}

/// Data related to an event from Plaid.
class PlaidEventMetadata {
  PlaidEventMetadata._({
    this.errorCode,
    this.errorMessage,
    this.errorType,
    this.exitStatus,
    this.institution,
    this.institutionSearchQuery,
    this.linkSessionId,
    this.mfaType,
    this.requestId,
    this.timestamp,
    this.viewName,
  });

  factory PlaidEventMetadata.fromMap(Map<dynamic, dynamic> map) {
    return PlaidEventMetadata._(
      errorCode: map['errorCode'],
      errorMessage: map['errorMessage'],
      errorType: map['errorType'],
      exitStatus: map['exitStatus'],
      institution: map['institution'] == null
          ? null
          : PlaidInstitution.fromMap(map['institution']),
      institutionSearchQuery: map['institutionSearchQuery'],
      linkSessionId: map['linkSessionId'],
      mfaType: map['mfaType'],
      requestId: map['requestId'],
      timestamp: map['timestamp'],
      viewName: map['viewName'],
    );
  }

  /// The error code.
  final String? errorCode;

  /// The error message.
  final String? errorMessage;

  /// The error type.
  final String? errorType;

  /// The exit status.
  final String? exitStatus;

  /// The institution associated with the event.
  final PlaidInstitution? institution;

  /// The institution search query.
  final String? institutionSearchQuery;

  /// The link session id.
  final String? linkSessionId;

  /// The mfa type.
  final String? mfaType;

  /// The request id.
  final String? requestId;

  /// The timestamp of the event.
  final String? timestamp;

  /// The view for the event.
  final String? viewName;
}
