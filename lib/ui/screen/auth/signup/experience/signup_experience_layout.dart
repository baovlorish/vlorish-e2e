import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/model/add_experience_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupExperienceLayout extends StatefulWidget {
  const SignupExperienceLayout();

  @override
  State<SignupExperienceLayout> createState() => _SignupExperienceLayoutState();
}

class _SignupExperienceLayoutState extends State<SignupExperienceLayout> {
  var tool = '';
  var experienceWithBudgetingLevel;

  final experienceNode = FocusNode();
  final toolsNameNode = FocusNode();
  final nextButtonNode = FocusNode();

  @override
  void dispose() {
    experienceNode.dispose();
    toolsNameNode.dispose();
    nextButtonNode.dispose();
    super.dispose();
  }

  late final SignupExperienceCubit _signupExperienceCubit;
  @override
  void initState() {
    _signupExperienceCubit = BlocProvider.of<SignupExperienceCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocConsumer<SignupExperienceCubit, SignupExperienceState>(
      listener: (BuildContext context, state) {
        if (state is ErrorExperienceState) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
              );
            },
          );
        } else if (state is SignupExperienceLoaded) {
          experienceWithBudgetingLevel =
              state.userDetails.experienceWithBudgetingLevel;
          if (state.userDetails.mostUsedBudgetingAppName != null) {
            tool = state.userDetails.mostUsedBudgetingAppName!;
          }
        }
      },
      builder: (context, _) => AuthScreen(
        title: AppLocalizations.of(context)!.signupExperienceHeadline,
        availableIndex: (_signupExperienceCubit.state is SignupExperienceLoaded)
            ? (_signupExperienceCubit.state as SignupExperienceLoaded)
            .user
            .registrationStep
            : 5,
        showDefaultSignupTopWidget: true,
        role: _signupExperienceCubit.role,
        leftSideColumnWidgetIndex: 5,
        centerWidget: ColumnItem(
          children: [
            Label(
              text: AppLocalizations.of(context)!.budgetingHeader,
              type: LabelType.Header,
            ),
            SizedBox(
              height: 11,
            ),
            Label(
              text: AppLocalizations.of(context)!.howExperienced,
              type: LabelType.General,
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownItem(
                      key: Key('experience $experienceWithBudgetingLevel'),
                      autofocus: true,
                      initialValue: experienceWithBudgetingLevel,
                      focusNode: experienceNode,
                      callback: (value) {
                        experienceWithBudgetingLevel = value;
                        toolsNameNode.requestFocus();
                      },
                      hintText:
                          AppLocalizations.of(context)!.pickOnePlaceHolder,
                      labelText:
                          AppLocalizations.of(context)!.experienceWithTools,
                      items: [
                        AppLocalizations.of(context)!
                            .experienceWithToolsOption1,
                        AppLocalizations.of(context)!
                            .experienceWithToolsOption2,
                        AppLocalizations.of(context)!
                            .experienceWithToolsOption3,
                        AppLocalizations.of(context)!
                            .experienceWithToolsOption4,
                      ],
                      validateFunction:
                          FormValidators.budgetingValidateFunction),
                  SizedBox(
                    height: 32,
                  ),
                  InputItem(
                      key: Key('tool $tool'),
                      value: tool,
                      focusNode: toolsNameNode,
                      onEditingComplete: () {
                        nextButtonNode.requestFocus();
                      },
                      onChanged: (String value) {
                        tool = value;
                      },
                      labelText: AppLocalizations.of(context)!.nameTools,
                      hintText: AppLocalizations.of(context)!.enterName,
                      validateFunction:
                          FormValidators.budgetingToolValidateFunction),
                  SizedBox(
                    height: 32,
                  ),
                  ButtonItem(
                    context,
                    focusNode: nextButtonNode,
                    buttonType: ButtonType.LargeText,
                    text: AppLocalizations.of(context)!.next,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signupExperienceCubit.submitAndNavigateToNextPage(
                          context,
                          model: ExperienceModel(
                            mostUsedBudgetingAppName: tool,
                            experienceWithBudgetingLevel:
                                experienceWithBudgetingLevel,
                          ),
                        );
                      }
                    },
                  ),
/*                  SizedBox(
                    height: 25,
                  ),
                  LabelButtonItem(
                    label: Label(
                        text: AppLocalizations.of(context)!.skip,
                        type: LabelType.Link),
                    onPressed: () =>
                        _signupExperienceCubit.navigateToNextPage(context),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
