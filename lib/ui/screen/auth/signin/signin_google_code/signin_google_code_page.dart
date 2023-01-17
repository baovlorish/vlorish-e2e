import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_google_code/signin_google_code_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_google_code/signin_google_code_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninGoogleCodePage {
  static const String routeName = '/signin_google_code';

  static void initRoute(FluroRouter router, AuthContractor repository) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        var code = params['code']?[0] ?? '';
        return BlocProvider<SigninGoogleCodeCubit>(
          create: (_) =>
              SigninGoogleCodeCubit(context!, repository.authRepository, code),
          child: SigninGoogleCodeLayout(),
        );
      },
    );
    router.define(routeName, handler: handler);
  }
}
