import 'dart:async';

import 'package:burgundy_budgeting_app/ui/atomic/atom/colored_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/form_decoration.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/transparent_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

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

  String? codeErrorMessage;
  String? codeErrorTitle;
  String? codeErrorDetails;

  final codeNode = FocusNode();
  final newPassNode = FocusNode();
  final confirmPasswordNode = FocusNode();
  final nextButtonNode = FocusNode();
  late final PassRecoveryCubit _passRecoveryCubit;
  late final RecoveryMailCodeCubit _recoveryMailCodeCubit;

  final clipboardStream = StreamController<String>.broadcast();
  late final Timer clipboardCheckTimer;
  final codeController = OtpFieldController();

  static const _codeLength = 6;

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

  bool get codeHasError => codeErrorMessage != null;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecoveryMailCodeCubit, RecoveryMailCodeState>(
      listener: (BuildContext context, state) {
        if (state is RecoveryMailErrorState) {
          if (state.error == AppLocalizations.of(context)!.invalidVerificationCodeMessage) {
            codeErrorTitle = AppLocalizations.of(context)!.codeIsIncorrect;
            codeErrorDetails = AppLocalizations.of(context)!.pleaseReenterOrHaveNewCode;
          } else {
            codeErrorTitle = null;
            codeErrorDetails = null;
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
          }
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
      builder: (context, state) => AuthScreen(
        title: AppLocalizations.of(context)!.confirmEmail,
        availableIndex: 0,
        centerWidget: ColumnItem(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              text: AppLocalizations.of(context)!.recoveryCode,
              type: LabelType.Header,
              color: VersionTwoColorScheme.White,
            ),
            SizedBox(
              height: 15.0,
            ),
            Label(
              text: AppLocalizations.of(context)!.enterSixDigitCodeSentToEmail,
              type: LabelType.General,
              color: VersionTwoColorScheme.Grey,
            ),
            SizedBox(
              height: 25.0,
            ),
            FormDecoration(
              /// error for password
              errorTitle: '',
              errorDetail: '',
              isErrorState: false,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FormDecoration(
                      /// error for confirmation code
                      paddingAll: 0,
                      bottomFormPadding: 10,
                      errorTitle: codeErrorTitle ?? '',
                      errorDetail: codeErrorDetails ?? '',
                      isErrorState: codeErrorTitle != null && codeErrorTitle!.isNotEmpty,
                      child: Column(
                        children: [
                          ConfirmationCode(
                            controller: codeController,
                            onChangedCallback: (String value) {
                              if (value.length < _codeLength) {
                                _recoveryMailCodeCubit.changeIsReadyForVerification(false);
                              }
                              code = value;
                            },
                            onCompletedCallback: (String value) {
                              _recoveryMailCodeCubit.changeIsReadyForVerification(true);
                              code = value;
                            },
                            codeLength: _codeLength,
                          ),
                          if (codeHasError) SizedBox(height: 10),
                          if (codeHasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  codeErrorMessage!,
                                  style: TextStyle(fontSize: 14, color: VersionTwoColorScheme.Red),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ResendCodeWidget(recoveryMailCodeCubit: _recoveryMailCodeCubit, email: email),
                    SizedBox(height: 16),
                    ColumnItem(
                      children: [
                        PasswordValidationWidget(
                          labelText: AppLocalizations.of(context)!.newPassword,
                          value: password,
                          focusNode: newPassNode,
                          onEditingComplete: () => confirmPasswordNode.requestFocus(),
                          onChanged: (String value) => password = value,
                          validateFunction: FormValidators.passwordSignupValidateFunction,
                        ),
                        InputItem(
                            labelText: AppLocalizations.of(context)!.confirmNewPassword,
                            value: confirmPassword,
                            focusNode: confirmPasswordNode,
                            onEditingComplete: () => nextButtonNode.requestFocus(),
                            onChanged: (String value) => confirmPassword = value,
                            isPassword: true,
                            hintText: AppLocalizations.of(context)!.atLeast8Char,
                            validateFunction: (value, context) => value!.isNotEmpty && value != password
                                ? AppLocalizations.of(context)!.passwordDontMatch
                                : FormValidators.passwordConfirmSignupValidateFunction.call(value, context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buttonsWidget()
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
    clipboardStream.close();
    super.dispose();
  }

  String? codeValidation(String? value, BuildContext context) {
    if (value == null || value.isEmpty || value.length != _codeLength) {
      return AppLocalizations.of(context)!.codeValidationErrorEmpty;
    }
  }

  Widget _buttonsWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TransparentButton(
            onPressed: () => _recoveryMailCodeCubit.navigateToPassRecovery(context, email),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 15,
                ),
                Label(
                  text: AppLocalizations.of(context)!.back,
                  type: LabelType.General,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ],
            ),
          ),
          ColoredButton(
            buttonStyle: ColoredButtonStyle.Green,
            focusNode: nextButtonNode,
            onPressed: () async {
              setState(() {
                codeErrorMessage = codeValidation(code, context);
                codeErrorTitle = null;
                codeErrorDetails = null;
              });
              if (_formKey.currentState!.validate() && codeErrorMessage == null) {
                await _recoveryMailCodeCubit.setNewPass(
                  context,
                  code.removeAllWhitespace(),
                  confirmPassword,
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.saveMyNewPassword,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      );
}

class ResendCodeWidget extends StatelessWidget {
  const ResendCodeWidget({Key? key, required this.recoveryMailCodeCubit, required this.email}) : super(key: key);

  final RecoveryMailCodeCubit recoveryMailCodeCubit;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(children: [
        Label(text: '${AppLocalizations.of(context)!.didNotGetCode} ', fontSize: 12, type: LabelType.Hint),
        InkWell(
          child: Text(
            AppLocalizations.of(context)!.resend,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, decoration: TextDecoration.underline),
          ),
          onTap: () => recoveryMailCodeCubit.resendCode(
            email: email,
            successMessage: AppLocalizations.of(context)!.codeWasSentToYourEmail,
            errorMessage: AppLocalizations.of(context)!.somethingWentWrongWithCodeResending,
          ),
        ),
      ]),
    );
  }
}

class ConfirmationCode extends StatelessWidget {
  const ConfirmationCode(
      {Key? key,
      required this.controller,
      required this.onChangedCallback,
      required this.onCompletedCallback,
      required this.codeLength})
      : super(key: key);
  final OtpFieldController controller;

  final void Function(String value) onChangedCallback;
  final void Function(String value) onCompletedCallback;
  final int codeLength;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleKeyPress,
      child: OTPTextField(
        length: codeLength,
        fieldWidth: 60,
        spaceBetween: 15,
        keyboardType: TextInputType.number,
        controller: controller,
        onChanged: onChangedCallback,
        onCompleted: onCompletedCallback,
        otpFieldStyle: OtpFieldStyle(
          focusBorderColor: VersionTwoColorScheme.PrimaryColor,
        ),
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        width: double.infinity,
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        fieldStyle: FieldStyle.box,
        outlineBorderRadius: 5.0,
      ),
    );
  }

  void _handleKeyPress(RawKeyEvent event) async {
    if (event.isControlPressed && event.character == 'v' || event.isMetaPressed && event.character == 'v') {
      var data = await Clipboard.getData(Clipboard.kTextPlain);
      var text = data?.text;
      if (text != null && text.length == codeLength) {
        controller.set(text.split(''));
        controller.setFocus(7);
      } else {
        controller.clear();
      }
    }
  }
}
