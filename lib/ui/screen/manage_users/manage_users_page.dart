import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_page.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageUsersPage {
  static const String routeName = '/manage_users';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return diContractor.authRepository.sessionExists()
            ? BlocProvider<HomeScreenCubit>(
                create: (_) => HomeScreenCubit(
                  diContractor.authRepository,
                  diContractor.userRepository,
                  diContractor.subscriptionRepository,
                ),
                child: Builder(builder: (context) {
                  return HomePage(
                    isPremium: false,
                    innerBlocProvider: BlocProvider<ManageUsersBloc>(
                      lazy: false,
                      create: (_) => ManageUsersBloc(
                        diContractor.authRepository,
                        diContractor.userRepository,
                        diContractor.manageUsersRepository,
                        isAdvisorSubscription:
                            BlocProvider.of<HomeScreenCubit>(context)
                                .user
                                .subscription!
                                .isAdvisor,
                      ),
                      child: ManageUsersLayout(),
                    ),
                    title: AppLocalizations.of(context)!.manageUsers,
                  );
                }),
              )
            : defaultRoute;
      },
    );

    router.define(routeName, handler: handler);
  }
}
