import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/terms_popup.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupLandingLayout extends StatefulWidget {
  @override
  State<SignupLandingLayout> createState() => _SignupLandingLayoutState();
}

class _SignupLandingLayoutState extends State<SignupLandingLayout> {
  final _emailFormKey = GlobalKey<FormState>();
  var email = '';
  String? emailFieldError;

  final emailNode = FocusNode();
  final nextButtonNode = FocusNode();

  bool byInvitation = false;

  bool confirmedAgreement = false;

  late final SignupLandingCubit signupLandingCubit;
  @override
  void dispose() {
    emailNode.dispose();
    nextButtonNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    signupLandingCubit = BlocProvider.of<SignupLandingCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupLandingCubit, SignupLandingState>(
        listener: (BuildContext context, state) {
      if (state is SignupLandingErrorState) {
        if (state.error == AppLocalizations.of(context)!.existingEmail) {
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
      } else if (state is SignupLandingStoredState) {
        if (state.invitationId != null) {
          byInvitation = true;
          email = state.email;
          setState(() {});
        }
      }
    }, builder: (_, state) {
      if (state is SignupLandingStoredState &&
          signupLandingCubit.invitationId != null &&
          state.role.isPartner &&
          !confirmedAgreement) {
        showAgreementDialog();
      }
      return AuthScreen(
        title: AppLocalizations.of(context)!.signupLandingHeadline,
        availableIndex: 0,
        centerWidget: (state is LoadingLandingState)
            ? CustomLoadingIndicator(
                isExpanded: false,
              )
            : ColumnItem(
                children: [
                  Label(
                    text: AppLocalizations.of(context)!.welcomeTo,
                    type: LabelType.Header,
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  if (!byInvitation)
                    Label(
                      text: AppLocalizations.of(context)!
                          .enterEmailToCreateAccount,
                      type: LabelType.General,
                    ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Form(
                    key: _emailFormKey,
                    child: Column(
                      children: [
                        if (!byInvitation)
                          InputItem(
                            errorText: emailFieldError,
                            autofocus: true,
                            focusNode: emailNode,
                            onEditingComplete: () {
                              nextButtonNode.requestFocus();
                            },
                            value: email,
                            onChanged: (String value) {
                              email = value;
                            },
                            labelText: AppLocalizations.of(context)!.email,
                            validateFunction:
                                FormValidators.emailValidateFunction,
                            hintText: AppLocalizations.of(context)!.emailHint,
                          ),
                        if (byInvitation)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Label(
                                text: AppLocalizations.of(context)!.email + ':',
                                type: LabelType.General,
                              ),
                            ),
                          ),
                        if (byInvitation)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Label(
                              text: email,
                              type: LabelType.GeneralBold,
                              fontSize: 20,
                            ),
                          ),
                        SizedBox(
                          height: byInvitation ? 54 : 40.0,
                        ),
                        ButtonItem(
                          context,
                          buttonType: ButtonType.LargeText,
                          text: AppLocalizations.of(context)!.next,
                          focusNode: nextButtonNode,
                          onPressed: () {
                            if (byInvitation) {
                              if (state is SignupLandingStoredState &&
                                  state.role.isPartner &&
                                  !confirmedAgreement) {
                                showAgreementDialog();
                              } else {
                                signupLandingCubit.checkInvitationId().then(
                                    (value) => signupLandingCubit
                                            .checkIfNotExistingUser(
                                          context,
                                          email,
                                        ));
                              }
                            } else if (_emailFormKey.currentState!.validate()) {
                              signupLandingCubit.checkIfNotExistingUser(
                                context,
                                email,
                                userRole: UserRole.primary(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
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
                  //   text: AppLocalizations.of(context)!.signUpWithGoogle,
                  //   onPressed: () {
                  //     signupLandingCubit.signUpWithGoogle();
                  //   },
                  // ),
                ],
              ),
        showDefaultSignupTopWidget: true,
      );
    });
  }

  void showAgreementDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return TermsPopup(
            onMainButtonPressed: () {
              confirmedAgreement = true;
            },
          );
        },
      );
    });
  }
}
