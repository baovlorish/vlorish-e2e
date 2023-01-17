import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PassRecoveryLayout extends StatefulWidget {
  @override
  State<PassRecoveryLayout> createState() => _PassRecoveryLayoutState();
}

class _PassRecoveryLayoutState extends State<PassRecoveryLayout> {
  final _emailFormKey = GlobalKey<FormState>();
  var email = '';
  String? emailFieldError;
  final emailNode = FocusNode();
  final nextButtonNode = FocusNode();
  late final PassRecoveryCubit _passRecoveryCubit;

  @override
  void initState() {
    _passRecoveryCubit = BlocProvider.of<PassRecoveryCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PassRecoveryCubit, PassRecoveryState>(
      listener: (BuildContext context, state) {
        if (state is PassRecoveryErrorState) {
          if (state.error ==
              AppLocalizations.of(context)!.noUserWithSuchEmail) {
            emailFieldError = state.error;
          } else {
            emailFieldError = null;
            showDialog(
              context: context,
              builder: (context) {
                return ErrorAlertDialog(
                  context,
                  message: state.error,
                );
              },
            );
          }
        }
      },
      builder: (_, state) => AuthScreen(
        title: AppLocalizations.of(context)!.passwordRecovery,
        availableIndex: 0,
        centerWidget: ColumnItem(
          children: [
            Label(
              text: AppLocalizations.of(context)!.passwordRecovery,
              type: LabelType.Header,
            ),
            SizedBox(
              height: 11,
            ),
            Label(
              text: AppLocalizations.of(context)!.enterYourEmailAndWeDOTheMagic,
              type: LabelType.General,
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: _emailFormKey,
              child: Column(
                children: [
                  InputItem(
                    errorText: emailFieldError,
                    value: email,
                    focusNode: emailNode,
                    autofocus: true,
                    onChanged: (String value) {
                      email = value;
                    },
                    onEditingComplete: () {
                      nextButtonNode.requestFocus();
                    },
                    validateFunction: FormValidators.emailValidateFunction,
                    labelText: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.emailHint,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ButtonItem(
                    context,
                    buttonType: ButtonType.LargeText,
                    text: AppLocalizations.of(context)!.next,
                    focusNode: nextButtonNode,
                    onPressed: () {
                      if (_emailFormKey.currentState!.validate()) {
                        _passRecoveryCubit.checkIfNotExistingUser(
                          email,
                          context,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailNode.dispose();
    nextButtonNode.dispose();
    super.dispose();
  }
}
