import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/text_field_with_suggestion.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/date_picker.dart';
import 'package:burgundy_budgeting_app/ui/model/add_personal_data_model.dart';
import 'package:burgundy_budgeting_app/ui/model/city_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupPersonalDataLayout extends StatefulWidget {
  const SignupPersonalDataLayout();

  @override
  State<SignupPersonalDataLayout> createState() =>
      _SignupPersonalDataLayoutState();
}

class _SignupPersonalDataLayoutState extends State<SignupPersonalDataLayout> {
  var lastName = '';
  var firstName = '';
  var cityController = TextEditingController();
  var birthday = '';

  int? genderValue;

  CityModel? cityModel;

  final nameNode = FocusNode();
  final surnameNode = FocusNode();
  final genderNode = FocusNode();
  final birthdayNode = FocusNode();
  final cityNode = FocusNode();
  final nextButtonNode = FocusNode();

  late final SignupPersonalDataCubit signupPersonalDataCubit;

  @override
  void initState() {
    signupPersonalDataCubit = BlocProvider.of<SignupPersonalDataCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocConsumer<SignupPersonalDataCubit, SignupPersonalDataState>(
        listener: (BuildContext context, state) {
      if (state is ErrorPersonalDataState) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              context,
              message: state.error,
            );
          },
        );
      } else if (state is SignupPersonalDataLoaded) {
        firstName = state.userDetails.firstName ?? firstName;
        lastName = state.userDetails.lastName ?? lastName;
        genderValue = state.userDetails.gender ?? genderValue;
        cityModel = state.userDetails.cityModel ?? cityModel;
        if (state.userDetails.dateOfBirth != null) {
          birthday = state.userDetails.dateOfBirth!;
        }
      }
    }, builder: (context, _) {
      return AuthScreen(
        title: AppLocalizations.of(context)!.signupPersonalDataHeadline,
        availableIndex:
            (signupPersonalDataCubit.state is SignupPersonalDataLoaded)
                ? (signupPersonalDataCubit.state as SignupPersonalDataLoaded)
                    .user
                    .registrationStep
                : 3,
        role: signupPersonalDataCubit.role,
        showDefaultSignupTopWidget: true,
        leftSideColumnWidgetIndex: 3,
        centerWidget: ColumnItem(
          children: [
            Label(
              text: AppLocalizations.of(context)!.signupPersonalDataHeader,
              type: LabelType.Header,
            ),
            SizedBox(
              height: 11,
            ),
            Label(
              text: AppLocalizations.of(context)!.addDetails,
              type: LabelType.General,
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InputItem(
                    key: Key('firstName $firstName'),
                    autofocus: true,
                    focusNode: nameNode,
                    onEditingComplete: () {
                      surnameNode.requestFocus();
                    },
                    labelText: AppLocalizations.of(context)!.firstName,
                    hintText:
                        AppLocalizations.of(context)!.firstNamePlaceholder,
                    validateFunction: FormValidators.firstNameValidateFunction,
                    value: firstName,
                    onChanged: (String value) {
                      firstName = value;
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  InputItem(
                    key: Key('lastName $lastName'),
                    focusNode: surnameNode,
                    onEditingComplete: () {
                      genderNode.requestFocus();
                    },
                    labelText: AppLocalizations.of(context)!.lastName,
                    hintText: AppLocalizations.of(context)!.lastNamePlaceholder,
                    validateFunction: FormValidators.lastNameValidateFunction,
                    value: lastName,
                    onChanged: (String value) {
                      lastName = value;
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownItem<int>(
                          key: Key('genderValue ${genderValue.toString()}'),
                          focusNode: genderNode,
                          initialValue: genderValue,
                          labelText: AppLocalizations.of(context)!.gender,
                          items: [
                            AppLocalizations.of(context)!.genderOptionMale,
                            AppLocalizations.of(context)!.genderOptionFemale,
                            AppLocalizations.of(context)!.genderOptionNeutral,
                            AppLocalizations.of(context)!.genderOptionDecline,
                          ],
                          hintText:
                              AppLocalizations.of(context)!.genderPlaceholder,
                          callback: (value) {
                            genderValue = value;
                            birthdayNode.requestFocus();
                          },
                          validateFunction:
                              FormValidators.genderValidateFunction,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DatePicker(
                          context,
                          focusNode: birthdayNode,
                          onChanged: (value) {
                            birthday = value;
                            cityNode.requestFocus();
                          },
                          value: birthday,
                          lastDate: DateTime.now(),
                          title: AppLocalizations.of(context)!.dateOfBirth,
                          dateFormat: CustomDateFormats.monthAndYearDateFormat,
                          hint: 'MM/YY',
                          validateFunction:
                              FormValidators.dateOfBirthValidateFunction,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextFieldWithSuggestion<CityModel>(
                    key: Key('cityModel ${cityModel.toString()}'),
                    model: cityModel,
                    label: AppLocalizations.of(context)!.city,
                    errorMessageEmpty: AppLocalizations.of(context)!.cityEmpty,
                    errorMessageInvalid:
                        AppLocalizations.of(context)!.invalidCity,
                    hintText: AppLocalizations.of(context)!.cityNamePlaceholder,
                    focusNode: cityNode,
                    search: (value) =>
                        signupPersonalDataCubit.searchCity(value),
                    onSelectedModel: (model) {
                      cityModel = model;
                      nextButtonNode.requestFocus();
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
                        signupPersonalDataCubit.navigateToEmploymentPage(
                            context,
                            model: PersonalDataModel(
                              lastName: lastName,
                              firstName: firstName,
                              gender: genderValue,
                              cityModel: cityModel,
                              dateOfBirth: birthday,
                            ));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    nameNode.dispose();
    surnameNode.dispose();
    genderNode.dispose();
    cityNode.dispose();
    nextButtonNode.dispose();
    cityController.dispose();
    super.dispose();
  }
}
