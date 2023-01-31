import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage {
  static const String routeName = '/signin';

  static void initRoute(FluroRouter router, AuthContractor authContractor,
      UserContractor userContractor) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return BlocProvider<SigninCubit>(
          create: (_) => SigninCubit(
              authContractor.authRepository,
              userContractor.userRepository),
          child: SigninLayout(),
        );
      },
    );
    router.define(routeName, handler: handler);
  }
}
