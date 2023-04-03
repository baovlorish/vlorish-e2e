import 'package:get_it/get_it.dart';

enum Environment { DEVELOP, STAGE, PROD }

class ApiClient {
  static final String DEVELOP = 'https://dev-2-api.vlorish.com';
  static final String STAGE = 'https://stage-api.vlorish.com';
  static final String PROD = 'https://api.vlorish.com';

  static final String BASE_URL = _getBaseUrl(GetIt.instance<Environment>());

  static final String ENV_BASE_URL =
      _getEnvBaseUrl(GetIt.instance<Environment>());

  static final Map<String, String> ENV_COGNITO_CREDENTIALS =
      _getEnvCognitoCredentials(GetIt.instance<Environment>());

  static final Map<String, String> ENV_GEO_CREDENTIALS =
      _getEnvGeoCredentials(GetIt.instance<Environment>());

  static final Map<String, String> ENV_PUBNUB_CREDENTIALS =
      _getEnvPubNubCredentials(GetIt.instance<Environment>());

  static final String ENV_STRIPE_API_KEY =
      _getEnvStripeApiKey(GetIt.instance<Environment>());

  static final String ENV_SENTRY = _getEnvSentry(GetIt.instance<Environment>());

  static final String ENV_SENTRY_DNS =
      'https://f269524152ad4ec1973fdeff431d7b44@o1043329.ingest.sentry.io/6034275';

  static String _getBaseUrl(Environment buildEnvironment) {
    switch (buildEnvironment) {
      case Environment.DEVELOP:
        return DEVELOP;
      case Environment.STAGE:
        return STAGE;
      case Environment.PROD:
        return PROD;
      default:
        return PROD;
    }
  }

  static String _getEnvBaseUrl(Environment buildEnvironment) {
    switch (buildEnvironment) {
      case Environment.DEVELOP:
        return 'https://dev-2.vlorish.com/#/';
      case Environment.STAGE:
        return 'https://stage-vlorish.itomy.ch/#/';
      case Environment.PROD:
        return 'https://my.vlorish.com/#/';
      default:
        return PROD;
    }
  }

  static Map<String, String> _getEnvCognitoCredentials(
      Environment buildEnvironment) {
    switch (buildEnvironment) {
      case Environment.DEVELOP:
        return {
          'userPoolId': 'us-west-2_FRlc2aV8i',
          'clientId': '3u6eumumtl3rlrcksde6mtnu7g',
          'redirectURL': 'https://dev-2-api.vlorish.com/signin_google_code',
          'cognitoPoolUrl': 'https://dev-2.auth.ap-south-1.amazoncognito.com',
        };
      case Environment.STAGE:
        return {
          'userPoolId': 'us-east-2_kfNSQx9dz',
          'clientId': '2pf5tbba30o37s093qgfutip94',
          // TODO: setup proper url when google sign unfreezes
          'redirectURL': 'https://stage-vlorish.itomy.ch/signin_google_code',
          'cognitoPoolUrl':
              'https://bargundy-stage.auth.us-east-2.amazoncognito.com',
        };
      case Environment.PROD:
        return {
          'userPoolId': 'us-east-1_fiAZPBrBk',
          'clientId': '5o5euhb0aug89mbrinpi52d8oh',
          'redirectURL': 'https://my.vlorish.com/signin_google_code',
          'cognitoPoolUrl':
              'https://bargundy-production.auth.us-east-1.amazoncognito.com',
        };
      default:
        return {};
    }
  }

  static String _getEnvStripeApiKey(Environment buildEnvironment) {
    switch (buildEnvironment) {
      case Environment.STAGE:
        return 'pk_test_51IgcvgCJRO5yQGHaMqOJqGlsmBIiWQIO5g7XFovkON7zKJ2uvm2pvkgkcsNOTnf7TzcuUyNov7PVXKBc76JEPmDx00unY1ikhZ';
      case Environment.DEVELOP:
        return 'pk_test_51IgcvgCJRO5yQGHaMqOJqGlsmBIiWQIO5g7XFovkON7zKJ2uvm2pvkgkcsNOTnf7TzcuUyNov7PVXKBc76JEPmDx00unY1ikhZ';
      case Environment.PROD:
        return 'pk_live_51IgcvgCJRO5yQGHajxVsyzKlqspHeIjbHKZGTj6FCGAgWsm6Lyq39WIUrJdBsYMbTjdeFQRIL5LFteWxRlFWJvUh00XM4nA8QH';
    }
  }

  static String _getEnvSentry(Environment environment) {
    switch (environment) {
      case Environment.DEVELOP:
        return 'development';
      case Environment.STAGE:
        return 'stage';
      case Environment.PROD:
        return 'production';
      default:
        return 'production';
    }
  }

  static Map<String, String> _getEnvPubNubCredentials(Environment environment) {
    switch (environment) {
      case Environment.PROD:
        return {
          'publish_key': 'pub-c-73d12fc6-af2c-4ea5-b528-81b8af155fe4',
          'sub_key': 'sub-c-fcae2f77-1de9-4a8a-aa7f-6f2756661c02',
        };
      case Environment.STAGE:
        return {
          'publish_key': 'pub-c-f1cbb849-b4d2-438f-a7fa-1589db1c3261',
          'sub_key': 'sub-c-fcae2f77-1de9-4a8a-aa7f-6f2756661c02',
        };
      case Environment.DEVELOP:
        return {
          'publish_key': 'pub-c-88376f9c-4ad9-4232-b73d-f81167f3d93f',
          'sub_key': 'sub-c-b462c336-68f7-11ec-8750-065127b61789',
        };
    }
  }

  static Map<String, String> _getEnvGeoCredentials(Environment environment) {
    switch (environment) {
      case Environment.PROD:
        return {
          'ApiUrl': 'https://autocomplete.geocoder.ls.hereapi.com/6.2',
          'ApiKey': '-o39MNGzKmNbuzeraEAUXR8e06ZcPnfZvN1G2IRyTcM',
          'CountryCode': 'USA'
        };
      default:
        return {
          'ApiUrl': 'https://autocomplete.geocoder.ls.hereapi.com/6.2',
          'ApiKey': 'toatFClM3d-eTrG9oRa-DBlqSOEF3tVuCKsptWEl5ac',
          'CountryCode': 'USA'
        };
    }
  }
}
