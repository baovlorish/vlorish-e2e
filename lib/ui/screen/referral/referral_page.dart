import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReferralPage {
  static const String routeName = '/referral';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(handlerFunc:
        (BuildContext? context, Map<String, List<String>> parameters) {
          diContractor.userRepository.stopForeignSession();
      return diContractor.authRepository.sessionExists()
          ? BlocProvider<HomeScreenCubit>(
              create: (_) => HomeScreenCubit(
                diContractor.authRepository,
                diContractor.userRepository,
                diContractor.subscriptionRepository,
              ),
              child: HomePage(
                isPremium: false,
                innerBlocProvider: BlocProvider<ReferralCubit>(
                  lazy: false,
                  create: (_) => ReferralCubit(
                    diContractor.referralRepository,
                  ),
                  child: ReferralLayout(),
                ),
                title: AppLocalizations.of(context!)!.manageUsers,
              ),
            )
          : defaultRoute;
    });
    router.define(routeName, handler: handler);
  }
}
