import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_date_formats.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/inform_hint.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_flexible_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/city_field_with_suggestion.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/editable_table_body_cell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/success_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/date_picker.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/pick_avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/city_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_details/profile_details_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_details/profile_details_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

const _placeHolderAsset = 'assets/images/imageplaceholder.png';

class ProfileDetailsLayout extends StatefulWidget {
  ProfileDetailsLayout({Key? key}) : super(key: key);

  @override
  _ProfileDetailsLayoutState createState() => _ProfileDetailsLayoutState();
}

class _ProfileDetailsLayoutState extends State<ProfileDetailsLayout> {
  var shortFieldWidth;
  var longFieldWidth;

  String? _image;

  final _birthdayController = TextEditingController();

  var firstName = '';
  var lastName = '';
  int? gender;
  var birthday = '';
  int? relationshipStatus;
  int? dependents;
  var city = '';
  var stateCode = '';
  int? currency;
  int? education;
  int? employmentType;
  int? profession;
  var income = '';

  final firstNameNode = FocusNode();
  final lastNameNode = FocusNode();
  final genderNode = FocusNode();
  final birthdayNode = FocusNode();
  final relationshipStatusNode = FocusNode();
  final dependentsNode = FocusNode();
  final cityNode = FocusNode();
  final stateCodeNode = FocusNode();
  final currencyNode = FocusNode();
  final educationNode = FocusNode();
  final employmentTypeNode = FocusNode();
  final professionNode = FocusNode();
  final incomeNode = FocusNode();
  final updateButtonNode = FocusNode();

  final GlobalKey<FormState> _key = GlobalKey();

  bool isSmall = false;

  CityModel? _cityModel;

  late final ProfileDetailsCubit _profileDetailsCubit;
  @override
  void initState() {
    _profileDetailsCubit = BlocProvider.of<ProfileDetailsCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSmall = MediaQuery.of(context).size.width < 970;

    return BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
      listener: (BuildContext context, state) {
        if (state is ProfileDetailsErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(
                context,
                message: state.error,
              );
            },
          );
        } else if (state is ProfileDetailsSuccessState) {
          showDialog(
            context: context,
            builder: (context) {
              return SuccessAlertDialog(context);
            },
          );
        } else if (state is ProfileDetailsLoadedUserDataState) {
          if (state.userDetailsModel.dateOfBirth != null) {
            _birthdayController.text =
                CustomDateFormats.defaultDateFormat.format(
              DateTime.parse(state.userDetailsModel.dateOfBirth ?? ''),
            );
            birthday = state.userDetailsModel.dateOfBirth!;
          }

          if (state.userDetailsModel.imageUrl != null) {
            _image = state.userDetailsModel.imageUrl!;
          } else {
            _image = null;
          }

          firstName = state.userDetailsModel.firstName ?? '';
          lastName = state.userDetailsModel.lastName ?? '';
          gender = state.userDetailsModel.gender;
          relationshipStatus = state.userDetailsModel.relationshipStatus;
          dependents = state.userDetailsModel.dependents;
          currency = 0;
          _cityModel = state.userDetailsModel.cityModel;
          education = state.userDetailsModel.education;
          employmentType = state.userDetailsModel.employmentType;
          profession = state.userDetailsModel.profession;
          income = state.userDetailsModel.income != null
              ? NumberFormat('#,###').format(state.userDetailsModel.income)
              : '';
        }
      },
      builder: (context, state) => HomeScreen(
        title: AppLocalizations.of(context)!.profileDetails,
        headerWidget: _buildHeaderPage(context),
        bodyWidget: Expanded(
          child: Container(
            color: CustomColorScheme.homeBodyWidgetBackground,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _key,
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColorScheme.blockBackground,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: CustomColorScheme.tableBorder,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    primary: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PersonalDetails(
                          firstName: firstName,
                          birthday: birthday,
                          dependents: dependents,
                          relationshipStatus: relationshipStatus,
                          lastName: lastName,
                          isSmall: isSmall,
                          gender: gender,
                          image: _image,
                          firstNameNode: firstNameNode,
                          lastNameNode: lastNameNode,
                          genderNode: genderNode,
                          birthdayNode: birthdayNode,
                          relationshipStatusNode: relationshipStatusNode,
                          dependentsNode: dependentsNode,
                          cityNode: cityNode,
                          profileDetailsCubit: _profileDetailsCubit,
                          onChanged: ({
                            String? birthday,
                            int? dependents,
                            String? firstName,
                            int? gender,
                            String? image,
                            String? lastName,
                            int? relationshipStatus,
                          }) {
                            this.birthday = birthday ?? this.birthday;

                            this.dependents = dependents ?? this.dependents;

                            this.firstName = firstName ?? this.firstName;

                            this.gender = gender ?? this.gender;

                            _image = image ?? _image;

                            this.lastName = lastName ?? this.lastName;

                            this.relationshipStatus =
                                relationshipStatus ?? this.relationshipStatus;
                          },
                        ),
                        CustomDivider(),
                        locationInfo(context),
                        CustomDivider(),
                        educationAndWorkInfo(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget locationInfo(BuildContext context) {
    var locationInfoFields = [
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 300,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          child: TextFieldWithSuggestion<CityModel>(
            focusNode: cityNode,
            label: AppLocalizations.of(context)!.city,
            errorMessageEmpty: AppLocalizations.of(context)!.cityEmpty,
            errorMessageInvalid: AppLocalizations.of(context)!.invalidCity,
            hintText: AppLocalizations.of(context)!.cityNamePlaceholder,
            key: UniqueKey(),
            model: _cityModel,
            search: (value) => _profileDetailsCubit.searchCity(value),
            onSelectedModel: (model) {
              _cityModel = model;
              educationNode.requestFocus();
            },
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 300,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          width: shortFieldWidth,
          child: DropdownItem<int>(
            enabled: false,
            focusNode: currencyNode,
            initialValue: currency,
            callback: (value) {
              currency = value;
              educationNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.currency,
            items: [
              AppLocalizations.of(context)!.currencyUSD,
              AppLocalizations.of(context)!.currencyEUR,
              AppLocalizations.of(context)!.currencyGBP,
              AppLocalizations.of(context)!.currencyAUD,
              AppLocalizations.of(context)!.currencyNZD,
            ],
            hintText: AppLocalizations.of(context)!.pickTheCurrency,
            validateFunction: FormValidators.currencyValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 300,
        expand: true,
        child: Container(),
      ),
      SizedBox(width: 10, height: 20),
    ];
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(AppLocalizations.of(context)!.locationDetails,
                  style: CustomTextStyle.HeaderTextStyle(context)
                      .copyWith(fontSize: 24)),
              InformHint(
                  message: AppLocalizations.of(context)!.locationDetails),
            ],
          ),
          SizedBox(height: 10),
          isSmall
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: locationInfoFields,
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: locationInfoFields),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget educationAndWorkInfo(BuildContext context) {
    var educationAndWorkFields = <Widget>[
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 200,
        expand: true,
        child: Container(
          child: DropdownItem<int>(
            initialValue: education,
            focusNode: educationNode,
            callback: (value) {
              education = value;
              employmentTypeNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.education,
            items: [
              AppLocalizations.of(context)!.educationHighSchool,
              AppLocalizations.of(context)!.educationCollege,
              AppLocalizations.of(context)!.educationBachelorsDegree,
              AppLocalizations.of(context)!.educationMastersDegree,
              AppLocalizations.of(context)!.educationPhD,
            ],
            hintText: AppLocalizations.of(context)!.select,
            validateFunction: FormValidators.educationValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 200,
        expand: true,
        child: Container(
          child: DropdownItem<int>(
            focusNode: employmentTypeNode,
            initialValue: employmentType,
            callback: (value) {
              employmentType = value;
              professionNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.employment,
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
            hintText: AppLocalizations.of(context)!.select,
            validateFunction: FormValidators.employmentValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 200,
        expand: true,
        child: Container(
          child: DropdownItem<int>(
            initialValue: profession,
            focusNode: professionNode,
            callback: (value) {
              profession = value;
              incomeNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.occupation,
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
            hintText: AppLocalizations.of(context)!.select,
            validateFunction: FormValidators.professionValidateFunction,
          ),
        ),
      ),
      SizedBox(
        width: 10,
        height: 20,
      ),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 200,
        expand: true,
        child: Container(
          child: InputItem(
            key: UniqueKey(),
            value: income,
            prefix: '\$ ',
            focusNode: incomeNode,
            onChanged: (String value) {
              income = value;
            },
            onEditingComplete: () {
              updateButtonNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.income,
            hintText: AppLocalizations.of(context)!.enterNumber,
            validateFunction: FormValidators.incomeValidateFunction,
            textInputFormatters: [
              LengthLimitingTextInputFormatter(17),
              FilteringTextInputFormatter.digitsOnly,
              NumericTextFormatter(),
            ],
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
    ];

    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(AppLocalizations.of(context)!.employmentAndOtherInfo,
                  style: CustomTextStyle.HeaderTextStyle(context)
                      .copyWith(fontSize: 24)),
              InformHint(
                  message:
                      AppLocalizations.of(context)!.employmentAndOtherInfo),
            ],
          ),
          SizedBox(height: 10),
          isSmall
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: educationAndWorkFields)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: educationAndWorkFields),
        ],
      ),
    );
  }

  Widget _buildHeaderPage(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomBackButton(
              onPressed: () {
                _profileDetailsCubit.navigateBackToProfileOverviewPage(context);
              },
            ),
            Text(
              AppLocalizations.of(context)!.profileDetails,
              style: CustomTextStyle.HeaderBoldTextStyle(context).copyWith(
                fontSize: 36.0,
              ),
            ),
          ],
        ),
        ButtonItem(
          context,
          text: AppLocalizations.of(context)!.update,
          focusNode: updateButtonNode,
          onPressed: () {
            if (_key.currentState!.validate()) {
              _profileDetailsCubit.saveUserDataToBackend(
                context,
                firstName: firstName,
                lastName: lastName,
                gender: gender,
                dateOfBirth: birthday,
                relationshipStatus: relationshipStatus,
                dependents: dependents,
                cityModel: _cityModel,
                currency: 'usd',
                education: education,
                employmentType: employmentType,
                profession: profession,
                income: int.parse(income.replaceAll(',', '')),
                imageUrl: (_image != _placeHolderAsset) ? _image : null,
              );
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    firstNameNode.dispose();
    lastNameNode.dispose();
    genderNode.dispose();
    birthdayNode.dispose();
    relationshipStatusNode.dispose();
    dependentsNode.dispose();
    cityNode.dispose();
    stateCodeNode.dispose();
    currencyNode.dispose();
    educationNode.dispose();
    employmentTypeNode.dispose();
    professionNode.dispose();
    incomeNode.dispose();
    updateButtonNode.dispose();
    super.dispose();
  }
}

class _PersonalDetails extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final int? gender;
  final String? birthday;
  final int? relationshipStatus;
  final int? dependents;
  final bool isSmall;
  final String? image;

  final FocusNode firstNameNode;
  final FocusNode lastNameNode;
  final FocusNode genderNode;
  final FocusNode birthdayNode;
  final FocusNode relationshipStatusNode;
  final FocusNode dependentsNode;
  final FocusNode cityNode;
  final ProfileDetailsCubit profileDetailsCubit;

  final void Function({
    String? firstName,
    String? lastName,
    int? gender,
    String? birthday,
    int? relationshipStatus,
    int? dependents,
    String? image,
  }) onChanged;

  _PersonalDetails({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthday,
    required this.relationshipStatus,
    required this.dependents,
    required this.image,
    required this.isSmall,
    required this.onChanged,
    required this.firstNameNode,
    required this.lastNameNode,
    required this.genderNode,
    required this.birthdayNode,
    required this.relationshipStatusNode,
    required this.dependentsNode,
    required this.cityNode,
    required this.profileDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    var moveAvatarOnTop = MediaQuery.of(context).size.width < 1120;
    var homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    var personalFieldsFirstRow = <Widget>[
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 300,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          child: InputItem(
            key: UniqueKey(),
            focusNode: firstNameNode,
            value: firstName,
            onChanged: (String value) {
              onChanged(firstName: value);
            },
            onEditingComplete: () {
              lastNameNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.firstName,
            hintText: AppLocalizations.of(context)!.enterYourFirstName,
            validateFunction: FormValidators.firstNameValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 300,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          child: InputItem(
            key: UniqueKey(),
            focusNode: lastNameNode,
            value: lastName,
            onChanged: (String value) {
              onChanged(lastName: value);
            },
            onEditingComplete: () {
              genderNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.lastName,
            hintText: AppLocalizations.of(context)!.enterYourLastName,
            validateFunction: FormValidators.lastNameValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 250,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          child: DropdownItem<int>(
            initialValue: gender,
            focusNode: genderNode,
            callback: (value) {
              onChanged(gender: value);
              birthdayNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.gender,
            items: [
              AppLocalizations.of(context)!.genderOptionMale,
              AppLocalizations.of(context)!.genderOptionFemale,
              AppLocalizations.of(context)!.genderOptionNeutral,
              AppLocalizations.of(context)!.genderOptionDecline,
            ],
            hintText: AppLocalizations.of(context)!.select,
            validateFunction: FormValidators.genderValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
    ];

    var personalFieldsSecondRow = <Widget>[
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 250,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          child: DatePicker(
            context,
            focusNode: birthdayNode,
            onChanged: (value) {
              onChanged(birthday: value);
              relationshipStatusNode.requestFocus();
            },
            value: birthday,
            lastDate: DateTime.now(),
            title: AppLocalizations.of(context)!.dateOfBirth,
            dateFormat: CustomDateFormats.monthAndYearDateFormat,
            hint: 'MM/YY',
            validateFunction: FormValidators.dateOfBirthValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 250,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          child: DropdownItem<int>(
            focusNode: relationshipStatusNode,
            initialValue: relationshipStatus,
            callback: (value) {
              onChanged(relationshipStatus: value);
              dependentsNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.relationshipStatus,
            items: [
              AppLocalizations.of(context)!.relationshipStatusSingle,
              AppLocalizations.of(context)!.relationshipStatusMarried,
              AppLocalizations.of(context)!.relationshipStatusDivorced,
              AppLocalizations.of(context)!.relationshipStatusOther,
            ],
            hintText: AppLocalizations.of(context)!.select,
            validateFunction: FormValidators.relationshipValidateFunction,
          ),
        ),
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 250,
        expand: true,
        child: Container(
          constraints: BoxConstraints(minWidth: 150),
          child: DropdownItem<int>(
            initialValue: dependents,
            focusNode: dependentsNode,
            callback: (value) {
              onChanged(dependents: value);
              cityNode.requestFocus();
            },
            labelText: AppLocalizations.of(context)!.dependents,
            items: [
              AppLocalizations.of(context)!.dependentsNoDependents,
              1.toString(),
              2.toString(),
              3.toString(),
              4.toString(),
              5.toString(),
              AppLocalizations.of(context)!.childrenOptionMoreThan5Dependents,
            ],
            hintText: AppLocalizations.of(context)!.select,
            validateFunction: FormValidators.numberOfChildrenValidateFunction,
          ),
        ),
      ),
      MaybeFlexibleWidget(
        flexibleWhen: !isSmall,
        flex: 200,
        expand: true,
        child: Container(),
      ),
      SizedBox(width: 10, height: 20),
    ];

    var personalInfoWidgets = [
      PickAvatarWidget(
        key: UniqueKey(),
        image: image,
        assetImage: _placeHolderAsset,
        onImageSet: (pickedFile) async {
          onChanged(image: pickedFile.path);
          await profileDetailsCubit.setUserPhoto(pickedFile);
          await homeScreenCubit.getUserData();
        },
        onImageValidationError: () {
          profileDetailsCubit.emit(
            ProfileDetailsErrorState(
                AppLocalizations.of(context)!.invalidImageError),
          );
          profileDetailsCubit.emit(
            ProfileDetailsLoading(),
          );
        },
      ),
      SizedBox(width: 10, height: 20),
      MaybeFlexibleWidget(
        flexibleWhen: !moveAvatarOnTop,
        flex: 20,
        expand: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSmall
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: personalFieldsFirstRow)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: personalFieldsFirstRow),
            SizedBox(height: 10),
            isSmall
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: personalFieldsSecondRow)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: personalFieldsSecondRow),
          ],
        ),
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context)!.personalDetails,
              style: CustomTextStyle.HeaderTextStyle(context)
                  .copyWith(fontSize: 24)),
          SizedBox(height: 10),
          moveAvatarOnTop
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: personalInfoWidgets,
                )
              : Row(children: personalInfoWidgets),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
