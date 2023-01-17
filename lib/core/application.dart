import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/lost_connection_screen/lost_connection_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:burgundy_budgeting_app/utils/helpers/connection_listener.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@immutable
class Application extends StatefulWidget {
  final NavigatorManager customRoute = NavigatorManager();

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with DiProvider {
  bool restoreSession = false;
  ProfileOverviewModel? user;

  @override
  void initState() {
    super.initState();
    restoreSession = authRepository.sessionExists();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      child: StreamBuilder<CustomConnectionState>(
        stream: ConnectionListener().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data == CustomConnectionState.none) {
            return MaterialApp(
              key: Key('disconnected'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                primarySwatch: createMaterialColor(
                  CustomColorScheme.button,
                ),
              ),
              home: LostConnectionScreen(),
            );
          }
          return MaterialApp(
            key: Key('connected'),
            scrollBehavior: CustomScrollBehavior(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              dividerColor: Colors.transparent,
              primarySwatch: createMaterialColor(CustomColorScheme.button),
              radioTheme: RadioThemeData(splashRadius: 0),
            ),
            initialRoute: restoreSession
                ? BudgetPersonalPage.routeName
                : SigninPage.routeName,
            onGenerateRoute: NavigatorManager.router.generator,
          );
        },
      ),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  var strengths = [0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
  var swatch = <int, Color>{};
  strengths.forEach((strength) {
    var ds = 0.5 - strength;
    swatch[(strength * 1000).toInt()] = Color.fromRGBO(
      color.red + ((ds < 0 ? color.red : (255 - color.red)) * ds).round(),
      color.green + ((ds < 0 ? color.green : (255 - color.green)) * ds).round(),
      color.blue + ((ds < 0 ? color.blue : (255 - color.blue)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
