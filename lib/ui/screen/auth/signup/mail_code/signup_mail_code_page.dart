import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupMailCodePage {
  static const String routeName = '/signup_mail_code';

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
      if (params['type']?[0] == 'returned') {
        return SignupMailCodeLayout(
          isSuccessLayout: true,
          role: role,
        );
      } else if (context != null) {
        var args = context.settings?.arguments as Map<String, dynamic>?;
        var email = args?['email'];
        var role = params['role']?[0] != null
            ? UserRole.fromMapped(int.parse(params['role']![0]))
            : UserRole.primary();
        return BlocProvider<SignupMailCodeCubit>(
          create: (_) => SignupMailCodeCubit(
            diContractor.authRepository,
            diContractor.userRepository,
            email: email,
            role: role,
          ),
          child: SignupMailCodeLayout( role: role,),
        );
      } else {
        return BlocProvider<SigninCubit>(
            create: (_) => SigninCubit(diContractor.authRepository,
                diContractor.userRepository),
            child: SigninLayout());
      }
    });
    router.define(routeName, handler: handler);
  }
}
