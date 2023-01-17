import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_google_code/signin_google_code_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_google_code/signin_google_code_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SigninGoogleCodeLayout extends StatefulWidget {
  @override
  State<SigninGoogleCodeLayout> createState() => _SigninGoogleCodeLayoutState();
}

class _SigninGoogleCodeLayoutState extends State<SigninGoogleCodeLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninGoogleCodeCubit, SigninGoogleCodeState>(
      listener: (BuildContext context, state) {
        if (state is ErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(context, message: state.error);
            },
          );
        }
      },
      child: AuthScreen(
        title: AppLocalizations.of(context)!.letsSignIn,
        availableIndex: 0,
        centerWidget: CustomLoadingIndicator(),
      ),
    );
  }
}
