import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/password_validation_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_auth_widget.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/password/signup_password_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'signup_password_cubit.dart';

class SignupPasswordLayout extends StatefulWidget {
  final bool isSuccessLayout;
  final UserRole? pageRole;
  const SignupPasswordLayout({
    this.isSuccessLayout = false,  this.pageRole,
  });

  @override
  State<SignupPasswordLayout> createState() => _SignupPasswordLayoutState();
}

class _SignupPasswordLayoutState extends State<SignupPasswordLayout> with DiProvider {
  var password = '';
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String name = '';

  final passwordNode = FocusNode();
  final confirmPasswordNode = FocusNode();
  final agreeButtonNode = FocusNode();
  late UserRole role;
  int availableIndex = 1;
  String? invitationId;
  late final SignupPasswordCubit? signupPasswordCubit;
  late final SignupLandingCubit? signupLandingCubit;

  @override
  void initState() {
    super.initState();

    if (!widget.isSuccessLayout) {
      signupPasswordCubit = BlocProvider.of<SignupPasswordCubit>(context);
      signupLandingCubit = BlocProvider.of<SignupLandingCubit>(context);

      role = signupPasswordCubit!.role;
      availableIndex = signupPasswordCubit!.availableIndex;
      if (signupLandingCubit!.state is SignupLandingStoredState) {
        email = (signupLandingCubit!.state as SignupLandingStoredState).email;
        invitationId =
            (signupLandingCubit!.state as SignupLandingStoredState).invitationId;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          signupPasswordCubit!.stateNotRestored(context);
        });
      }
    } else {
      role = widget.pageRole!;
    }
  }

  @override
  void dispose() {
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    agreeButtonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: AppLocalizations.of(context)!.signUpPasswordPageHeadLine,
      availableIndex: availableIndex,
      leftSideColumnWidgetIndex: 1,
      role: role,
      showDefaultSignupTopWidget: true,
      centerWidget: widget.isSuccessLayout
          ? SuccessAuthWidget(
        onPressed: () async {
          var isUserConfirmed =
          await authRepository.isUserConfirmed();
          if (isUserConfirmed) {
            NavigatorManager.navigateTo(
                context, SignupMailCodePage.routeName, params: {
              'type': 'returned',
              'role': role.mappedValue.toString()
            });
          } else {
            NavigatorManager.navigateTo(
                context, SignupMailCodePage.routeName,
                params: {'role': role.mappedValue.toString()});
          }
        },
        message: AppLocalizations.of(context)!
            .youHaveAlreadyCreatedAPasswordYouWillBeAbleToChangeItLater,
      )
          :BlocConsumer<SignupPasswordCubit, SignupPasswordState>(
        listener: (_, state) {
          if (state is SignUpPasswordErrorState) {
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
        },
        builder: (_, state) {
          return ColumnItem(
                  children: [
                    Label(
                      text: AppLocalizations.of(context)!.addPassword,
                      type: LabelType.Header,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      children: [
                        Label(
                          text: AppLocalizations.of(context)!.createPassword,
                          type: LabelType.General,
                        ),
                        Label(
                          text: email + ' ',
                          type: LabelType.GeneralBold,
                        ),
                        Label(
                          text: AppLocalizations.of(context)!.changeLater,
                          type: LabelType.General,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          PasswordValidationWidget(
                            labelText: AppLocalizations.of(context)!.password,
                            value: password,
                            autofocus: true,
                            focusNode: passwordNode,
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
                            focusNode: confirmPasswordNode,
                            onEditingComplete: () {
                              agreeButtonNode.requestFocus();
                            },
                            labelText:
                                AppLocalizations.of(context)!.confirmPassword,
                            isPassword: true,
                            hintText:
                                AppLocalizations.of(context)!.atLeast8Char,
                            validateFunction: (value, context) {
                              if (value!.isNotEmpty && value != password) {
                                return AppLocalizations.of(context)!
                                    .passwordDontMatch;
                              } else {
                                return FormValidators
                                    .passwordConfirmSignupValidateFunction
                                    .call(value, context);
                              }
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          ButtonItem(
                            context,
                            focusNode: agreeButtonNode,
                            buttonType: ButtonType.LargeText,
                            text: AppLocalizations.of(context)!.agreeContinue,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signupPasswordCubit!.createCognitoAccount(
                                  email,
                                  password,
                                  context,
                                  invitationId: invitationId,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      children: [
                        Label(
                          text: AppLocalizations.of(context)!.byClickingAgree,
                          type: LabelType.GreyLabel,
                        ),
                        Label(
                          text: AppLocalizations.of(context)!.youAgree,
                          type: LabelType.GreyLabel,
                        ),
                        LabelButtonItem(
                          label: Label(
                            text: AppLocalizations.of(context)!.terms,
                            type: LabelType.Link,
                          ),
                          onPressed: () => signupPasswordCubit!
                              .navigateToTermsAndConditionsLayout(context),
                        ),
                        Label(
                          text: AppLocalizations.of(context)!.youHaveRead,
                          type: LabelType.GreyLabel,
                        ),
                        LabelButtonItem(
                          label: Label(
                            text: AppLocalizations.of(context)!.privacyPolicy,
                            type: LabelType.Link,
                          ),
                          onPressed: () => signupPasswordCubit!
                              .navigateToPrivacyPolicyLayout(context),
                        ),
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}
