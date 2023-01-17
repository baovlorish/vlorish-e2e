import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/code/email_sent_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_cubit.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'email_sent_cubit.dart';

class RecoveryMailCodePage {
  static const String routeName = '/email_sent';

  static void initRoute(FluroRouter router, AuthContractor authContractor) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<RecoveryMailCodeCubit>(
              create: (_) =>
                  RecoveryMailCodeCubit(authContractor.authRepository),
            ),
            BlocProvider<PassRecoveryCubit>(
              create: (_) => PassRecoveryCubit(authContractor.authRepository),
            ),
          ],
          child: RecoveryMailCodeLayout(),
        );
      },
    );
    router.define(routeName, handler: handler);
  }
}
