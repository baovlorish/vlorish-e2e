import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupAddCardPage {
  static const String routeName = '/signup_add_card';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        //by url or other way
        //if coach goes to SignupAddCard during see client's budget
        //stop client's session
        //than coach see own SignupAddCard
        diContractor.userRepository.stopForeignSession();
        return diContractor.authRepository.sessionExists()
            ? MultiBlocProvider(
                providers: [
                  BlocProvider<SignupAddCardCubit>(
                    create: (_) => SignupAddCardCubit(
                      diContractor.accountsTransactionsRepository,
                      diContractor.userRepository,
                      diContractor.netWorthRepository,
                    ),
                  ),
                  BlocProvider<HomeScreenCubit>(
                    create: (_) => HomeScreenCubit(
                      diContractor.authRepository,
                      diContractor.userRepository,
                      diContractor.subscriptionRepository,
                    ),
                  ),
                ],
                child: SignupAddCardLayout(),
              )
            : defaultRoute;
      },
    );

    router.define(routeName, handler: handler);
  }
}
