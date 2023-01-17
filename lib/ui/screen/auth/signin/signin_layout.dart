import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SigninLayout extends StatefulWidget {
  @override
  State<SigninLayout> createState() => _SigninLayoutState();
}

class _SigninLayoutState extends State<SigninLayout> {
  final _signInFormKey = GlobalKey<FormState>();
  var email = '';
  var password = '';
  String? emailFieldError;
  String? passwordFieldError;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final signInButtonNode = FocusNode();

  @override
  void dispose() {
    passwordNode.dispose();
    signInButtonNode.dispose();
    emailNode.dispose();
    super.dispose();
  }

  void clearErrors() {
    emailFieldError = null;
    passwordFieldError = null;
  }

  late final SigninCubit signinCubit;
  @override
  void initState() {
    signinCubit = BlocProvider.of<SigninCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (BuildContext context, state) {
        if (state is ErrorState) {
          if (state.error ==
              AppLocalizations.of(context)!.noUserWithSuchEmail) {
            emailFieldError = state.error;
          } else if (state.error == 'Incorrect username or password.') {
            passwordFieldError =
                AppLocalizations.of(context)!.passwordIncorrect;
          } else if (state.error == 'Password attempts exceeded') {
            passwordFieldError =
                AppLocalizations.of(context)!.passwordNoMoreAttempts;
          } else {
            clearErrors();
            var dismissible = (state.errorDialogCallBack == null);
            showDialog(
              context: context,
              barrierDismissible: dismissible,
              builder: (context) {
                return ErrorAlertDialog(
                  context,
                  message: state.error,
                  buttonText: state.errorDialogButtonText,
                  onButtonPress: state.errorDialogCallBack,
                  showCloseButton: dismissible,
                );
              },
            );
          }
        }
      },
      builder: (_, state) => AuthScreen(
        title: AppLocalizations.of(context)!.letsSignIn,
        availableIndex: 0,
        centerWidget: ColumnItem(
          children: [
            Label(
              text: AppLocalizations.of(context)!.letsSignIn,
              type: LabelType.Header,
            ),
            SizedBox(
              height: 34.0,
            ),
            Form(
              key: _signInFormKey,
              child: AutofillGroup(
                child: FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Column(
                    children: [
                      FocusTraversalOrder(
                        order: NumericFocusOrder(1),
                        child: InputItem(
                          errorText: emailFieldError,
                          autofocus: true,
                          focusNode: emailNode,
                          onEditingComplete: () {
                            passwordNode.requestFocus();
                          },
                          value: email,
                          onChanged: (String value) {
                            email = value;
                          },
                          labelText: AppLocalizations.of(context)!.yourEmail,
                          autofillHints: [AutofillHints.email],
                          validateFunction:
                              FormValidators.emailValidateFunction,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Stack(
                        children: [
                          FocusTraversalOrder(
                            order: NumericFocusOrder(1),
                            child: InputItem(
                              errorText: passwordFieldError,
                              focusNode: passwordNode,
                              onEditingComplete: () {
                                signInButtonNode.requestFocus();
                              },
                              value: password,
                              onChanged: (String value) {
                                password = value;
                              },
                              labelText: AppLocalizations.of(context)!.password,
                              autofillHints: [AutofillHints.password],
                              isPassword: true,
                              validateFunction:
                                  FormValidators.passwordSigninValidateFunction,
                            ),
                          ),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(3),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: LabelButtonItem(
                                label: Label(
                                  text: AppLocalizations.of(context)!
                                      .forgotPassword,
                                  type: LabelType.Link,
                                ),
                                onPressed: () {
                                  signinCubit
                                      .navigateToPassRecoveryPage(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      FocusTraversalOrder(
                        order: NumericFocusOrder(2),
                        child: ButtonItem(
                          context,
                          focusNode: signInButtonNode,
                          text: AppLocalizations.of(context)!.signIn,
                          buttonType: ButtonType.LargeText,
                          onPressed: () {
                            clearErrors();
                            if (_signInFormKey.currentState!.validate()) {
                              TextInput.finishAutofillContext(shouldSave: true);
                              signinCubit.login(email, password, context);
                            }
                            ;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            // Center(
            //   child: Label(
            //     text: AppLocalizations.of(context)!.or,
            //     type: LabelType.General,
            //   ),
            // ),
            // SizedBox(
            //   height: 15.0,
            // ),
            // TODO: temporarily paused
            // GoogleButtonItem(
            //   context,
            //   text: AppLocalizations.of(context)!.signInWithGoogle,
            //   onPressed: () {
            //     signinCubit.signInWithGoogle();
            //   },
            // ),
          ],
        ),
        topRightWidget: Wrap(
          children: [
            Label(
              text: AppLocalizations.of(context)!.notAMember + ' ',
              type: LabelType.General,
            ),
            LabelButtonItem(
              label: Label(
                text: AppLocalizations.of(context)!.signUp,
                type: LabelType.Link,
              ),
              onPressed: () {
                signinCubit.navigateToSignupLandingPage(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
