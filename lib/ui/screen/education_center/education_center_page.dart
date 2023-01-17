import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationCenterPage {
  static const String routeName = '/help';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          diContractor.userRepository.stopForeignSession();
      var currentTab = int.tryParse(params['tab']?[0] ?? '0') ?? 0;
      return diContractor.authRepository.sessionExists()
          ? BlocProvider<HomeScreenCubit>(
              create: (_) => HomeScreenCubit(
                diContractor.authRepository,
                diContractor.userRepository,
                diContractor.subscriptionRepository,
              ),
              child: HomePage(
                innerBlocProvider: BlocProvider<EducationCenterCubit>(
                  create: (_) => EducationCenterCubit(currentTab: currentTab),
                  child: EducationCenterLayout(),
                ),
                title: AppLocalizations.of(context!)!.educationCenter,
                isPremium: false,
              ),
            )
          : defaultRoute;
    });
    router.define(routeName, handler: handler);
  }
}
