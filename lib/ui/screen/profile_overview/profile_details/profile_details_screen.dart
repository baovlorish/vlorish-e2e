import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_details/profile_details_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_details/profile_details_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileDetailsPage {
  static const String routeName = '/profile_details';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        //by url or other way
        //if coach goes to ProfileDetails during see client's budget
        //stop client's session
        //than coach see own ProfileDetails
        diContractor.userRepository.stopForeignSession();
        return diContractor.authRepository.sessionExists()
            ? BlocProvider<HomeScreenCubit>(
                create: (_) => HomeScreenCubit(
                  diContractor.authRepository,
                  diContractor.userRepository,
                  diContractor.subscriptionRepository,
                ),
                child: HomePage(
                  innerBlocProvider: BlocProvider<ProfileDetailsCubit>(
                    create: (_) =>
                        ProfileDetailsCubit(diContractor.userRepository),
                    child: ProfileDetailsLayout(),
                  ),
                  title: AppLocalizations.of(context!)!.profileDetails,
                ),
              )
            : defaultRoute;
      },
    );

    router.define(routeName, handler: handler);
  }
}
