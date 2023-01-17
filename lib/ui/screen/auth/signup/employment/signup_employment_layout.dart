import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/model/add_employment_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_state.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupEmploymentLayout extends StatefulWidget {
  const SignupEmploymentLayout();

  @override
  State<SignupEmploymentLayout> createState() => _SignupEmploymentLayoutState();
}

class _SignupEmploymentLayoutState extends State<SignupEmploymentLayout> {
  var employmentType;
  var profession;
  var income = '';

  final employmentTypeNode = FocusNode();
  final professionNode = FocusNode();
  final incomeNode = FocusNode();
  final nextButtonNode = FocusNode();
  late final SignupEmploymentCubit _signupEmploymentCubit;
  @override
  void initState() {
    _signupEmploymentCubit = BlocProvider.of<SignupEmploymentCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    employmentTypeNode.dispose();
    professionNode.dispose();
    incomeNode.dispose();
    nextButtonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocConsumer<SignupEmploymentCubit, SignupEmploymentState>(
      listener: (BuildContext context, state) {
        if (state is ErrorEmploymentState) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
              );
            },
          );
        } else if (state is SignupEmploymentLoaded) {
          employmentType = state.userDetails.employmentType;
          profession = state.userDetails.profession;
          if (state.userDetails.income != null &&
              state.userDetails.income != 0) {
            income = state.userDetails.income!.numericFormattedString();
          }
        }
      },
      builder: (context, _) => AuthScreen(
        title: AppLocalizations.of(context)!.signupEmploymentHeadline,
        showDefaultSignupTopWidget: true,
        role: _signupEmploymentCubit.role,
        leftSideColumnWidgetIndex: 4,
        availableIndex: (_signupEmploymentCubit.state is SignupEmploymentLoaded)
            ? (_signupEmploymentCubit.state as SignupEmploymentLoaded)
            .user
            .registrationStep
            : 4,
        centerWidget: ColumnItem(
          children: [
            Label(
              text: AppLocalizations.of(context)!.employmentHeader,
              type: LabelType.Header,
            ),
            SizedBox(
              height: 11,
            ),
            Label(
              text: AppLocalizations.of(context)!.whatYouDo,
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
                      key: Key('employmentType $employmentType'),
                      autofocus: true,
                      callback: (value) {
                        employmentType = value;
                        professionNode.requestFocus();
                      },
                      initialValue: employmentType,
                      focusNode: employmentTypeNode,
                      labelText: AppLocalizations.of(context)!.employmentType,
                      items: [
                        AppLocalizations.of(context)!.employmentTypeOption1,
                        AppLocalizations.of(context)!.employmentTypeOption2,
                        AppLocalizations.of(context)!.employmentTypeOption3,
                        AppLocalizations.of(context)!.employmentTypeOption4,
                        AppLocalizations.of(context)!.employmentTypeOption5,
                        AppLocalizations.of(context)!.employmentTypeOption6,
                        AppLocalizations.of(context)!.employmentTypeOption7,
                        AppLocalizations.of(context)!.employmentTypeOption8,
                        AppLocalizations.of(context)!.employmentTypeOption9,
                        AppLocalizations.of(context)!.employmentTypeOption10,
                      ],
                      hintText:
                          AppLocalizations.of(context)!.pickOnePlaceHolder,
                      validateFunction:
                          FormValidators.incomeSourceValidateFunction),
                  SizedBox(
                    height: 32,
                  ),
                  DropdownItem(
                      key: Key('profession $profession'),
                      callback: (value) {
                        profession = value;
                        incomeNode.requestFocus();
                      },
                      initialValue: profession,
                      focusNode: professionNode,
                      labelText: AppLocalizations.of(context)!.profession,
                      items: [
                        AppLocalizations.of(context)!.professionOption1,
                        AppLocalizations.of(context)!.professionOption2,
                        AppLocalizations.of(context)!.professionOption3,
                        AppLocalizations.of(context)!.professionOption4,
                        AppLocalizations.of(context)!.professionOption5,
                        AppLocalizations.of(context)!.professionOption6,
                        AppLocalizations.of(context)!.professionOption7,
                        AppLocalizations.of(context)!.professionOption8,
                        AppLocalizations.of(context)!.professionOption9,
                        AppLocalizations.of(context)!.professionOption10,
                        AppLocalizations.of(context)!.professionOption11,
                        AppLocalizations.of(context)!.professionOption12,
                        AppLocalizations.of(context)!.professionOption13,
                        AppLocalizations.of(context)!.professionOption14,
                        AppLocalizations.of(context)!.professionOption15,
                        AppLocalizations.of(context)!.professionOption16,
                        AppLocalizations.of(context)!.professionOption17,
                        AppLocalizations.of(context)!.professionOption18,
                        AppLocalizations.of(context)!.professionOption19,
                        AppLocalizations.of(context)!.professionOption20,
                        AppLocalizations.of(context)!.professionOption21,
                        AppLocalizations.of(context)!.professionOption22,
                        AppLocalizations.of(context)!.professionOption23,
                        AppLocalizations.of(context)!.professionOption24,
                        AppLocalizations.of(context)!.professionOption25,
                        AppLocalizations.of(context)!.professionOption26,
                        AppLocalizations.of(context)!.professionOption27,
                        AppLocalizations.of(context)!.professionOption28,
                        AppLocalizations.of(context)!.professionOption29,
                        AppLocalizations.of(context)!.professionOption30,
                        AppLocalizations.of(context)!.professionOption31,
                        AppLocalizations.of(context)!.professionOption32,
                        AppLocalizations.of(context)!.professionOption33,
                        AppLocalizations.of(context)!.professionOption34,
                        AppLocalizations.of(context)!.professionOption35,
                      ],
                      hintText:
                          AppLocalizations.of(context)!.pickOnePlaceHolder,
                      validateFunction:
                          FormValidators.professionValidateFunction),
                  SizedBox(
                    height: 32,
                  ),
                  InputItem(
                    key: Key('income $income'),
                    value: income,
                    prefix: '\$ ',
                    focusNode: incomeNode,
                    onEditingComplete: () {
                      nextButtonNode.requestFocus();
                    },
                    labelText: AppLocalizations.of(context)!.income,
                    hintText: AppLocalizations.of(context)!.enterNumber,
                    validateFunction: FormValidators.incomeValidateFunction,
                    textInputFormatters: [
                      LengthLimitingTextInputFormatter(17),
                      FilteringTextInputFormatter.digitsOnly,
                      NumericTextFormatter(),
                    ],
                    onChanged: (String value) {
                      income = value;
                    },
                  ),
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
                        _signupEmploymentCubit.navigateToExperiencePage(
                          context,
                          model: EmploymentModel(
                            profession: profession,
                            income: int.parse(income.replaceAll(',', '')),
                            employmentType: employmentType,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 25,
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
