import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/auth_service.dart';
import 'package:burgundy_budgeting_app/domain/service/foreign_session_service.dart';
import 'package:burgundy_budgeting_app/domain/service/session_manager.dart';
import 'package:burgundy_budgeting_app/domain/storage/session_storage.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:sentry/sentry.dart';
import 'package:url_launcher/url_launcher.dart';

class CognitoAuthService extends AuthService implements SessionManager {
  final SessionStorage _storage;
  final ForeignSessionService _foreignSessionService;
  SessionDetails? sessionDetails;

  @override
  SessionManager get sessionManager => this;
  final userPoolId = ApiClient.ENV_COGNITO_CREDENTIALS['userPoolId']!;
  final clientId = ApiClient.ENV_COGNITO_CREDENTIALS['clientId']!;
  final redirectURL = ApiClient.ENV_COGNITO_CREDENTIALS['redirectURL']!;
  final cognitoPoolUrl = ApiClient.ENV_COGNITO_CREDENTIALS['cognitoPoolUrl']!;

  late final CognitoUserPool userPool;
  final Logger logger = getLogger('CognitoAuthService');
  CognitoUser? cognitoUser;
  CognitoUserSession? session;
  AuthenticationDetails? authenticationDetails;

  var generalErrorMessage = 'Network error occurred';

  CognitoAuthService(this._storage, this._foreignSessionService)
      : super(_storage) {
    userPool = CognitoUserPool(userPoolId, clientId);
    sessionDetails = _storage.getSessionDetails();
    if (sessionDetails != null) {
      init();
    }
  }

  Future<void> init() async {
    await sessionManager.createSession(sessionDetails!);
  }

  @override
  bool sessionExists() {
    return session != null;
  }

  @override
  Future<bool> login(String login, String password) async {
    cognitoUser = CognitoUser(login, userPool);
    authenticationDetails =
        AuthenticationDetails(username: login, password: password);
    session = await cognitoUser?.authenticateUser(authenticationDetails!);
    if (session != null) {
      await sessionManager.createSession(
        SessionDetails(
            username: login,
            idToken: session!.getIdToken().getJwtToken()!,
            accessToken: session!.getAccessToken().getJwtToken()!,
            refreshToken: session!.getRefreshToken()!.token!,
            clockDrift: session!.clockDrift),
      );
      return true;
    } else {
      return false;
    }
  }

  /// registration moved to backend, and this method currently creates [authenticationDetails] and [cognitoUser]
  @override
  void register(String email, String pass) async {
/*    final userAttributes = [
      AttributeArg(name: 'email', value: email),
    ];
    var data = await userPool.signUp(
      email,
      pass,
      userAttributes: userAttributes,
    );*/
    authenticationDetails =
        AuthenticationDetails(username: email, password: pass);
    cognitoUser = CognitoUser(email, userPool);
  }

  @override
  Future<bool> confirmEmail(String code) async {
    var isSuccessful = true;
    if (cognitoUser != null) {
      // isSuccessful = await cognitoUser!.confirmRegistration(code);
      if (/*isSuccessful &&*/
          cognitoUser != null &&
          authenticationDetails != null &&
          authenticationDetails!.username != null) {
        session = await cognitoUser!.authenticateUser(authenticationDetails!);
        if (session != null) {
          await sessionManager.createSession(
            SessionDetails(
                username: authenticationDetails!.username!,
                idToken: session!.getIdToken().getJwtToken()!,
                accessToken: session!.getAccessToken().getJwtToken()!,
                refreshToken: session!.getRefreshToken()!.token!,
                clockDrift: session!.clockDrift),
          );
        }
        logger.i('session created: ${session != null}');
      } else {
        isSuccessful = false;
      }
    }
    return isSuccessful;
  }

  @override
  Future<void> forgotPassword(String email) async {
    cognitoUser = CognitoUser(email, userPool);
    var data = await cognitoUser!.forgotPassword();
    logger.i('Code sent to $data');
  }

  @override
  Future<bool> confirmPassword(String code, String newPass) async {
    if (cognitoUser != null) {
      return await cognitoUser!.confirmPassword(code, newPass);
    } else {
      return false;
    }
  }

  @override
  Future<bool> changePassword(
      String oldUserPassword, String newUserPassword) async {
    if (cognitoUser != null && sessionDetails != null && session!.isValid()) {
      // always create auth details trying to change password
      // because otherwise it has password from previous attempts
      authenticationDetails = AuthenticationDetails(
        username: sessionDetails!.username,
        password: oldUserPassword,
      );
      session = await cognitoUser!.authenticateUser(authenticationDetails!);
      return await cognitoUser!.changePassword(
        oldUserPassword,
        newUserPassword,
      );
    } else {
      return false;
    }
  }

  @override
  void openGoogleSignInUrl() async {
    var url =
        'https://bargundy-dev.auth.eu-central-1.amazoncognito.com/login?response_type=code&client_id=449h2j5lkeodck7p345eikg825&redirect_uri=' +
            redirectURL;

    await canLaunch(url)
        ? await launch(
            url,
            enableJavaScript: true,
            forceSafariVC: true,
            forceWebView: true,
            webOnlyWindowName: '_self',
          )
        : throw 'Could not launch $url';
  }

  @override
  Future<void> signInWithGoogle(String code) async {
    final userPool = CognitoUserPool(userPoolId, clientId);

    var endpoint = cognitoPoolUrl +
        '/oauth2/token?grant_type=authorization_code&client_id='
            '$clientId&code=' +
        code +
        '&redirect_uri=' +
        redirectURL;
// when implementing google auth flow, this method should be refactored
// to call AuthService which implements HttpManager, so GetIt can be removed
    final response = await GetIt.instance<HttpManager>().dio.post(
          endpoint,
          options: Options(
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          ),
        );

    if (response.statusCode != 200) {
      throw Exception('Received bad status code from Cognito for auth code:' +
          response.statusCode.toString() +
          '; body: ' +
          response.data);
    } else {
      final idToken = CognitoIdToken(response.data['id_token']);
      final accessToken = CognitoAccessToken(response.data['access_token']);
      final refreshToken = CognitoRefreshToken(response.data['refresh_token']);
      final session =
          CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);
      final user = CognitoUser(null, userPool, signInUserSession: session);

      // NOTE: in order to get the email from the list of user attributes, make sure you select email in the list of
      // attributes in Cognito and map it to the email field in the identity provider.
      // final attributes = await user.getUserAttributes();
      // for (var attribute in attributes!) {
      //   if (attribute.getName() == 'email') {
      //     user.username = attribute.getValue();
      //     break;
      //   }
      // }

      cognitoUser = user;
    }
  }

  @override
  Future<void> createSession(SessionDetails details) async {
    sessionDetails = details;
    cognitoUser = CognitoUser(details.username, userPool);
    session = CognitoUserSession(CognitoIdToken(details.idToken),
        CognitoAccessToken(details.accessToken),
        refreshToken: CognitoRefreshToken(details.refreshToken),
        clockDrift: details.clockDrift);
    if (session != null && !session!.isValid()) {
      await refreshSession();
    }
    if (session != null && session!.isValid()) {
      await _storage.saveSessionDetails(details);
      logger.i('Session created');
    }

    if (kReleaseMode) {
      Sentry.configureScope(
        (scope) => scope.user = SentryUser(
          id: cognitoUser!.username,
          email: cognitoUser!.username,
        ),
      );
    }
  }

  @override
  void logout() {
    _clearAuthData();
    _storage.deleteSessionDetails();
  }

  void _clearAuthData() {
    session = null;
    sessionDetails = null;
    authenticationDetails = null;
    cognitoUser = null;
    Sentry.configureScope((scope) => scope.user = null);
  }

  @override
  Future<String?> get idToken async {
    if (session != null) {
      if (!isSessionValid()) {
        await refreshSession();
      }
      logger.i('Obtained token from session manager');
      return session!.getIdToken().jwtToken;
    } else {
      logger.i('Failed to get token');
      return null;
    }
  }

  @override
  bool isSessionValid() {
    if (session != null) {
      return session!.isValid();
    } else {
      return false;
    }
  }

  @override
  Future<bool> refreshSession() async {
    if (session != null &&
        cognitoUser != null &&
        session?.getRefreshToken() != null) {
      try {
        var refreshedSession =
            await cognitoUser!.refreshSession(session!.getRefreshToken()!);
        if (refreshedSession != null) {
          session = refreshedSession;
          if (isSessionValid()) {
            logger.i('Refresh session succeeded');
            return true;
          } else {
            logger.i('Refresh session failed');
            logout();
            return false;
          }
        } else {
          logger.i('Refresh session failed');
          logout();
          return false;
        }
      } catch (e) {
        logger.i('Refresh session failed');
        logout();
        return false;
      }
    } else {
      logger.i('Refresh session failed');
      logout();
      return false;
    }
  }

  @override
  void onError(DioError e, ErrorInterceptorHandler handler) async {
    if (e.error.toString() == 'XMLHttpRequest error.') {
      handler.resolve(Response(
          data: {'message': generalErrorMessage},
          requestOptions: RequestOptions(path: ''),
          statusCode: 418));
    } else {
      if (e.response != null) {
        handler.resolve(e.response!);
      } else {
        handler.next(e);
      }
    }
    await Sentry.captureException(
      e,
      stackTrace: e.stackTrace,
    );
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await idToken;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer ' + token;
    }
    var foreignId = _foreignSessionService.currentForeignSession()?.id;
    if (foreignId != null &&
        !_foreignSessionService.forbidden.contains(options.path)) {
      options.headers['Budget-User-Id'] = foreignId;
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<bool> reSendCode() async {
    if (cognitoUser != null) {
      var response = await cognitoUser!.resendConfirmationCode();
      // got this response in successful scenario
      // {CodeDeliveryDetails:
      //    {AttributeName: email,
      //    DeliveryMedium: EMAIL,
      //    Destination: a***@i***.ch,
      // }}
      if (response['CodeDeliveryDetails'] != null &&
          response['CodeDeliveryDetails']['AttributeName'] != null &&
          response['CodeDeliveryDetails']['DeliveryMedium'] != null &&
          response['CodeDeliveryDetails']['Destination'] != null &&
          response['CodeDeliveryDetails']['AttributeName'] == 'email' &&
          response['CodeDeliveryDetails']['DeliveryMedium'] == 'EMAIL') {
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> isUserConfirmed() async {
    if (sessionDetails != null) {
      await init();
      return true;
    }

    if (cognitoUser != null &&
        authenticationDetails != null &&
        authenticationDetails!.username != null) {
      try {
        session = await cognitoUser!.authenticateUser(authenticationDetails!);
      } catch (e) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }
}
