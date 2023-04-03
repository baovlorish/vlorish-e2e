import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassRecoveryPage {
  static const String routeName = '/pass_recovery';

  static void initRoute(FluroRouter router, AuthContractor authContractor) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        var email = params['email']?[0];
        return BlocProvider<PassRecoveryCubit>(
          create: (_) => PassRecoveryCubit(authContractor.authRepository, email: email),
          child: PassRecoveryLayout(),
        );
      },
    );
    router.define(routeName, handler: handler);
  }
}
