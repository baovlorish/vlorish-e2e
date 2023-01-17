import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/not_found/not_found_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotFoundPage {
  static const String routeName = '/not_found';

  static Handler initHandler(
    FluroRouter router,
    UserContractor diContractor,
  ) {
    return Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return diContractor.authRepository.sessionExists()
            ? BlocProvider<HomeScreenCubit>(
                create: (_) => HomeScreenCubit(
                  diContractor.authRepository,
                  diContractor.userRepository,
                  diContractor.subscriptionRepository,
                ),
                child: HomeScreen(
                  title: 'Vlorish',
                  bodyWidget: Expanded(
                    child: NotFoundLayout(
                      sessionExist: true,
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: NotFoundLayout(
                  sessionExist: false,
                ),
              );
      },
    );
  }
}
