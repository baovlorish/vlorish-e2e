import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/password_validation_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/code/email_sent_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/code/email_sent_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_state.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoveryMailCodeLayout extends StatefulWidget {
  @override
  State<RecoveryMailCodeLayout> createState() => _RecoveryMailCodeLayoutState();
}

class _RecoveryMailCodeLayoutState extends State<RecoveryMailCodeLayout> {
  String code = '';
  String password = '';
  String email = '';
  String confirmPassword = '';
  final _formKey = GlobalKey<FormState>();

  final codeNode = FocusNode();
  final newPassNode = FocusNode();
  final confirmPasswordNode = FocusNode();
  final nextButtonNode = FocusNode();
  late final PassRecoveryCubit _passRecoveryCubit;
  late final RecoveryMailCodeCubit _recoveryMailCodeCubit;
  @override
  void initState() {
    super.initState();
    _passRecoveryCubit = BlocProvider.of<PassRecoveryCubit>(context);
    _recoveryMailCodeCubit = BlocProvider.of<RecoveryMailCodeCubit>(context);
    if (_passRecoveryCubit.state is PassRecoveryStoredState) {
      email = (_passRecoveryCubit.state as PassRecoveryStoredState).email;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recoveryMailCodeCubit.stateNotRestored(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecoveryMailCodeCubit, RecoveryMailCodeState>(
      listener: (BuildContext context, state) {
        if (state is RecoveryMailErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
                onButtonPress: state.callback,
              );
            },
          );
        } else if (state is RecoveryMailSuccessState) {
          showDialog(
            context: context,
            builder: (context) {
              return SuccessAlertDialog(
                context,
                message: state.message,
                onButtonPress: state.callback,
              );
            },
          );
        }
      },
      child: AuthScreen(
        title: AppLocalizations.of(context)!.confirmEmail,
        availableIndex: 0,
        centerWidget: ColumnItem(
          children: [
            Label(
              text: AppLocalizations.of(context)!.confirmEmail,
              type: LabelType.Header,
            ),
            SizedBox(
              height: 15.0,
            ),
            Wrap(
              children: [
                Label(
                  text: AppLocalizations.of(context)!.weSentEmail,
                  type: LabelType.General,
                ),
                Label(
                  text: email,
                  type: LabelType.GeneralBold,
                ),
                Label(
                  text: '. ',
                  type: LabelType.General,
                ),
                Label(
                  text: AppLocalizations.of(context)!.enterCode,
                  type: LabelType.General,
                ),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      InputItem(
                        value: code,
                        autofocus: true,
                        focusNode: codeNode,
                        onEditingComplete: () {
                          newPassNode.requestFocus();
                        },
                        onChanged: (String value) {
                          code = value;
                        },
                        labelText: AppLocalizations.of(context)!.code,
                        validateFunction:
                            FormValidators.mailCodeSignupValidateFunction,
                      ),
                      SizedBox(height: 12.0),
                      LabelButtonItem(
                        label: Label(
                          text: AppLocalizations.of(context)!.resendCode,
                          type: LabelType.LabelBoldPink,
                        ),
                        onPressed: () async {
                          await _recoveryMailCodeCubit.resendCode(
                            email: email,
                            successMessage: AppLocalizations.of(context)!
                                .codeWasSentToYourEmail,
                            errorMessage: AppLocalizations.of(context)!
                                .somethingWentWrongWithCodeResending,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Label(
                    text: AppLocalizations.of(context)!.createNewPassword,
                    type: LabelType.Header2,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Label(
                    text: AppLocalizations.of(context)!.comeUpWithNewPassword,
                    type: LabelType.General,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  PasswordValidationWidget(
                    labelText: AppLocalizations.of(context)!.newPassword,
                    value: password,
                    focusNode: newPassNode,
                    onEditingComplete: () {
                      confirmPasswordNode.requestFocus();
                    },
                    onChanged: (String value) {
                      password = value;
                    },
                    validateFunction:
                        FormValidators.passwordSignupValidateFunction,
                  ),
                  InputItem(
                      labelText:
                          AppLocalizations.of(context)!.confirmNewPassword,
                      value: confirmPassword,
                      focusNode: confirmPasswordNode,
                      onEditingComplete: () {
                        nextButtonNode.requestFocus();
                      },
                      onChanged: (String value) {
                        confirmPassword = value;
                      },
                      isPassword: true,
                      hintText: AppLocalizations.of(context)!.atLeast8Char,
                      validateFunction: (value, context) {
                        if (value!.isNotEmpty && value != password) {
                          return AppLocalizations.of(context)!
                              .passwordDontMatch;
                        } else {
                          return FormValidators
                              .passwordConfirmSignupValidateFunction
                              .call(value, context);
                        }
                      }),
                  SizedBox(
                    height: 40.0,
                  ),
                  ButtonItem(
                    context,
                    text: AppLocalizations.of(context)!.next,
                    buttonType: ButtonType.LargeText,
                    focusNode: nextButtonNode,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _recoveryMailCodeCubit.setNewPass(
                          context,
                          code.removeAllWhitespace(),
                          confirmPassword,
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
    codeNode.dispose();
    newPassNode.dispose();
    confirmPasswordNode.dispose();
    nextButtonNode.dispose();
    super.dispose();
  }
}
