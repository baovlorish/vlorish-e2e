import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/password/signup_password_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/password/signup_password_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPasswordPage {
  static const String routeName = '/signup_password';

  static void initRoute(FluroRouter router, UserContractor diContractor) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        //by url or other way
        //if coach goes to SignupAddCard during see client's budget
        //stop client's session
        //than coach see own SignupAddCard
        diContractor.userRepository.stopForeignSession();
        var role = params['role']?[0] != null
            ? UserRole.fromMapped(int.parse(params['role']![0]))
            : UserRole.primary();
        return params['type']?[0] == 'returned'
            ? SignupPasswordLayout(
                isSuccessLayout: true,
                pageRole: role,
              )
            : MultiBlocProvider(
                providers: [
                  BlocProvider<SignupPasswordCubit>(
                    create: (_) => SignupPasswordCubit(
                        diContractor.authRepository,
                        role: role),
                  ),
                  BlocProvider<SignupLandingCubit>(
                    create: (_) =>
                        SignupLandingCubit(diContractor.authRepository),
                  ),
                ],
                child: SignupPasswordLayout(),
              );
      },
    );
    router.define(routeName, handler: handler);
  }
}
