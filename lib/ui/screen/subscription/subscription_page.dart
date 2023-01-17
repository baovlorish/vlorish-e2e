import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionPage {
  static const String routeName = '/subscription';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      //by url or other way
      //if coach goes to SignupAddCard during see client's budget
      //stop client's session
      //than coach see own SignupAddCard
      diContractor.userRepository.stopForeignSession();
      var isSignUp =
          params['type']?[0] == 'signup' || params['type']?[0] == 'returned';
      return diContractor.authRepository.sessionExists()
          ? MultiBlocProvider(
              providers: [
                BlocProvider<SubscriptionCubit>(
                  create: (_) => SubscriptionCubit(
                      diContractor.subscriptionRepository,
                      diContractor.userRepository,
                      isSignUp: isSignUp),
                ),
                BlocProvider<HomeScreenCubit>(
                  create: (_) => HomeScreenCubit(
                    diContractor.authRepository,
                    diContractor.userRepository,
                    diContractor.subscriptionRepository,
                  ),
                ),
              ],
              child: SubscriptionLayout(),
            )
          : defaultRoute;
    });

    router.define(routeName, handler: handler);
  }
}
