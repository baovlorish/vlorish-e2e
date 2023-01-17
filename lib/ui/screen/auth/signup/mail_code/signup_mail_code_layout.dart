import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_auth_widget.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_page.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupMailCodeLayout extends StatefulWidget {
  final bool isSuccessLayout;
  final UserRole role;

  const SignupMailCodeLayout(
      {this.isSuccessLayout = false, required this.role});

  @override
  State<SignupMailCodeLayout> createState() => _SignupMailCodeLayoutState();
}

class _SignupMailCodeLayoutState extends State<SignupMailCodeLayout> {
  String code = '';
  String email = '';
  late UserRole role;
  final codeNode = FocusNode();
  final nextButtonNode = FocusNode();
  late final SignupMailCodeCubit? signupMailCodeCubit;
  int? availableIndex;


  @override
  void initState() {
    super.initState();
    role = widget.role;
        if (!widget.isSuccessLayout) {
      signupMailCodeCubit = BlocProvider.of<SignupMailCodeCubit>(context);
      availableIndex = signupMailCodeCubit!.availableIndex;
      if (signupMailCodeCubit!.state is SignupMailCodeInitial) {
        email = (signupMailCodeCubit!.state as SignupMailCodeInitial).email;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          signupMailCodeCubit!.stateNotRestored(context);
        });
      }
    }
  }

  @override
  void dispose() {
    codeNode.dispose();
    nextButtonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return AuthScreen(
      title: AppLocalizations.of(context)!.confirmEmail,
      role: role,
      availableIndex: availableIndex ?? 2,
      showDefaultSignupTopWidget: true,
      leftSideColumnWidgetIndex: 2,
      centerWidget: widget.isSuccessLayout
          ? SuccessAuthWidget(
              onPressed: () {
                NavigatorManager.navigateTo(
                  context,
                  SignupPersonalDataPage.routeName,
                  params: {'role': role.mappedValue.toString()},
                );
              },
              message: AppLocalizations.of(context)!.youHaveConfirmedYourEmail,
            )
          : BlocConsumer<SignupMailCodeCubit, SignupMailCodeState>(
              listener: (BuildContext context, state) {
                if (state is SignupMailCodeErrorState) {
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
                if (state is SignupMailCodeSuccessState) {
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
              builder: (BuildContext context, state) => ColumnItem(
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
                    height: 40.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputItem(
                          value: code,
                          autofocus: true,
                          focusNode: codeNode,
                          onEditingComplete: () {
                            nextButtonNode.requestFocus();
                          },
                          onChanged: (String value) {
                            code = value;
                          },
                          labelText: AppLocalizations.of(context)!.code,
                          validateFunction:
                              FormValidators.mailCodeSignupValidateFunction,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        ButtonItem(
                          context,
                          focusNode: nextButtonNode,
                          text: AppLocalizations.of(context)!.next,
                          buttonType: ButtonType.LargeText,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signupMailCodeCubit!.confirmEmail(
                                code.removeAllWhitespace(),
                                context,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        LabelButtonItem(
                          label: Label(
                            text: AppLocalizations.of(context)!.resendCode,
                            type: LabelType.LabelBoldPink,
                          ),
                          onPressed: () async {
                            await signupMailCodeCubit!.resendCode(
                              successMessage: AppLocalizations.of(context)!
                                  .codeWasSentToYourEmail,
                              errorMessage: AppLocalizations.of(context)!
                                  .somethingWentWrongWithCodeResending,
                            );
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
}
