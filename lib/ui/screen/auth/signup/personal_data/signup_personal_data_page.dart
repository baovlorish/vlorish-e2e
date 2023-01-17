import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPersonalDataPage {
  static const String routeName = '/signup_personal_data';

  static void initRoute(FluroRouter router, UserContractor diContractor,
      {required Widget defaultRoute}) {
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
        return diContractor.authRepository.sessionExists()
            ? BlocProvider<SignupPersonalDataCubit>(
                create: (_) => SignupPersonalDataCubit(
                    diContractor.userRepository,
                    role: role),
                child: SignupPersonalDataLayout(),
              )
            : defaultRoute;
      },
    );

    router.define(routeName, handler: handler);
  }
}
