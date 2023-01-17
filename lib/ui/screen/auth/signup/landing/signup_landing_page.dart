import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupLandingPage {
  static const String routeName = '/signup_landing';

  static void initRoute(FluroRouter router, AuthContractor contractor) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return BlocProvider<SignupLandingCubit>(
        create: (_) => SignupLandingCubit(contractor.authRepository,
            invitationId: params['invitationId']?[0]),
        child: SignupLandingLayout(),
      );
    });
    router.define(routeName, handler: handler);
  }
}
