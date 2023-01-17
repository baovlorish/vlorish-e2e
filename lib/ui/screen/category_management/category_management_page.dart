import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryManagementPage {
  static const String routeName = '/category_management';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        var isPersonal = context?.settings?.arguments as bool?;
        return diContractor.authRepository.sessionExists()
            ? BlocProvider<HomeScreenCubit>(
                create: (_) => HomeScreenCubit(
                  diContractor.authRepository,
                  diContractor.userRepository,
                  diContractor.subscriptionRepository,
                ),
                child: HomePage(
                  innerBlocProvider: BlocProvider<CategoryManagementCubit>(
                    create: (_) => CategoryManagementCubit(
                        isPersonal ?? true, diContractor.categoryRepository),
                    child: CategoryManagementLayout(),
                  ),
                  title: AppLocalizations.of(context!)!.categoriesManagement,
                ),
              )
            : defaultRoute;
      },
    );
    router.define(routeName, handler: handler);
  }
}
