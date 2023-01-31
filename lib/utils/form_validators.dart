import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormValidators {
  static String? Function(String?, BuildContext context)
      passwordContains8CharactersFunction =
      (String? value, BuildContext context) {
    if (!RegExp(r'^.{8,128}$').hasMatch(value!)) {
      return '';
    }
  };
  static String? Function(String?, BuildContext context)
      passwordContainsBothLowerAndUpperCaseLettersFunction =
      (String? value, BuildContext context) {
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).+$').hasMatch(value!)) {
      return '';
    }
  };
  static String? Function(String?, BuildContext context)
      passwordContainsAtLeastOneNumberAndASymbol =
      (String? value, BuildContext context) {
    if (!RegExp(r'^(?=.*\d)(?=.*?[#?!@$%^&*_-]).+$').hasMatch(value!)) {
      return '';
    }
  };

  static String? Function(String?, BuildContext context)
      passwordSigninValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.passwordEmpty;
    } else if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*_-]).{8,128}$')
            .stringMatch(value) !=
        value) {
      return AppLocalizations.of(context)!.passwordMoreCharacters;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context) emailValidateFunction =
      (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.emptyEmail;
    } else if (RegExp(
                r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.)*[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.[a-zA-Z0-9]{2,}$")
            .stringMatch(value.toLowerCase()) !=
        value.toLowerCase()) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    //else if ( ) {
    //  return AppLocalizations.of(context)!.noUserWithSuchEmail;
    // }
    else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      passwordSignupValidateFunction = (String? value, BuildContext context) {
    var firstRule = passwordContains8CharactersFunction(value, context);
    var secondRule =
        passwordContainsBothLowerAndUpperCaseLettersFunction(value, context);
    var thirdRule = passwordContainsAtLeastOneNumberAndASymbol(value, context);

    if (firstRule != null || secondRule != null || thirdRule != null) {
      return '';
    }
  };

  static String? Function(String?, BuildContext context)
      passwordConfirmSignupValidateFunction =
      (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.confirmPasswordEmpty;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      firstNameValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.firstNameEmpty;
    } else if (RegExp(r"^[A-Za-z\d\s\!@#$%^&*()_+=-`~\\\]\[{}|';:/.,?><]*$")
            .stringMatch(value) !=
        value) {
      return AppLocalizations.of(context)!.invalidFirstName;
    } else if (value.length > 32) {
      return AppLocalizations.of(context)!.firstShouldBeUpTo32Characters;
    } else {
      return null;
    }
  };
  static String? Function(String?, BuildContext context)
      lastNameValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.lastNameEmpty;
    } else if (RegExp(r"^[A-Za-z\d\s\!@#$%^&*()_+=-`~\\\]\[{}|';:/.,?><]*$")
            .stringMatch(value) !=
        value) {
      return AppLocalizations.of(context)!.invalidLastName;
    } else if (value.length > 32) {
      return AppLocalizations.of(context)!.lastShouldBeUpTo32Characters;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context) cityValidateFunction =
      (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.cityEmpty;
    } else if (/*RegExp(r'^[a-zA-Z]+$').stringMatch(value) != value ||*/
        value.length > 50) {
      return AppLocalizations.of(context)!.invalidCity;
    } else {
      return null;
    }
  };
  static String? Function<T>(T?, BuildContext context) genderValidateFunction =
      <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.genderEmpty;
    } else {
      return null;
    }
  };
  static String? Function<T>(T?, BuildContext context)
      incomeSourceValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.employmentTypeEmpty;
    } else {
      return null;
    }
  };
  static String? Function<T>(T?, BuildContext context)
      professionValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.businessAreaEmpty;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      budgetingValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.experienceEmpty;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      budgetingToolValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return null;
    } else if (RegExp(r'^[a-zA-Z0-9]+$').stringMatch(value) != value ||
        value.length > 128) {
      return AppLocalizations.of(context)!.toolInvalid;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      incomeValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.incomeEmpty;
    } else if (value.length > 17) {
      return AppLocalizations.of(context)!.incomeInvalid;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      changePasswordCurrentPasswordValidateFunction =
      (String? currentPass, BuildContext context) {
    if (currentPass!.isEmpty) {
      return AppLocalizations.of(context)!.currentPasswordEmpty;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      changePasswordNewPasswordValidateFunction =
      (String? newPass, BuildContext context) {
    if (newPass!.isEmpty) {
      return AppLocalizations.of(context)!.newPasswordEmptySecurity;
    } else if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*_-]).{8,128}$')
            .stringMatch(newPass) !=
        newPass) {
      return AppLocalizations.of(context)!.passwordMoreCharacters;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      mailCodeSignupValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.codeValidationErrorEmpty;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      dateOfBirthValidateFunction = (String? value, BuildContext context) {
    var dateValue = value?.split('/');
    var now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.birthdayEmpty;
    } else if (dateValue != null &&
        dateValue.isNotEmpty &&
        DateTime(int.parse(dateValue[1]), int.parse(dateValue[0]))
            .isAfter(eighteenYearsAgo)) {
      return AppLocalizations.of(context)!.youMustBeOlder;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      employmentValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.employmentTypeEmpty;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      numberOfChildrenValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.numberOfDependentsEmpty;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context) stateValidateFunction =
      (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.stateEmpty;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      educationValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.educationEmpty;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      positionValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.positionEmpty;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      relationshipValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.relationshipEmpty;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      currencyValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.currencyEmpty;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      creditScoreValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.creditScoreEmpty;
    } else if (RegExp(r'^[0-9]+$').stringMatch(value) != value ||
        int.parse(value) < 300 ||
        int.parse(value) > 850) {
      return AppLocalizations.of(context)!.creditScoreInvalid;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      accountCategoryValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.accountCategoryEmpty;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      accountDataPeriodValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.accountDataPeriodEmpty;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      accountNameValidateFunction =
      (String? currentPass, BuildContext context) {
    if (currentPass!.isEmpty) {
      return AppLocalizations.of(context)!.accountNameEmpty;
    } else if (currentPass.length > 20){
      return 'Please, fill Account Name field with 20 or less characters';
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      goalNameValidateFunction = (String? goalName, BuildContext context) {
    if (goalName!.isEmpty) {
      return AppLocalizations.of(context)!.thisFieldIsRequired;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      totalAmountValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty || 0 == int.parse(value)) {
      return AppLocalizations.of(context)!.thisFieldIsRequired;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      fundedAmountValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.thisFieldIsRequired;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      targetDateValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.thisFieldIsRequired;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      calculationValidateFunction = (String? value, BuildContext context) {
    if (value!.isEmpty) {
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context) brokerageValidate =
      <T>(T? value, BuildContext context) {
    if (value == null || value as int < 0 || value > 8) {
      return AppLocalizations.of(context)!.brokerageErrorMessage;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context) otherTypeValidate =
      <T>(T? value, BuildContext context) {
    if (value == null || value as int < 0 || value > 7) {
      return AppLocalizations.of(context)!.otherTypeErrorMessage;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context) costTypeValidate =
      <T>(T? value, BuildContext context) {
    if (value == null || value as int <= 0 || value > 2) {
      return AppLocalizations.of(context)!.costTypeErrorMessage;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context)
      investmentCostValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null ||
        (value as String).isEmpty ||
        double.parse(value) <= 0) {
      return AppLocalizations.of(context)!.investmentInitialCostError;
    } else {
      return null;
    }
  };
  static String? Function<T>(T?, BuildContext context)
      newInvestmentCostValidateFunction = <T>(T? value, BuildContext context) {
    if (value == null ||
        (value as String).isEmpty ||
        double.parse(value) <= 0) {
      return AppLocalizations.of(context)!.investmentInitialCostError;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context)
      investmentDateValidation = (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.acquisitionDateErrorMessage;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context) optionalPhone =
      (String? value, BuildContext context) {
    if (value!.isNotEmpty && value.length < 10) {
      return AppLocalizations.of(context)!.invalidPhoneNumber;
    } else {
      return null;
    }
  };

  static String? Function(String?, BuildContext context) contactMessage =
      (String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.enterYourMessageError;
    } else if (value.length < 10) {
      return AppLocalizations.of(context)!.invalidContactMessage;
    } else {
      return null;
    }
  };

  static String? Function<T>(T?, BuildContext context) reasonOfContact =
      <T>(T? value, BuildContext context) {
    if (value == null) {
      return AppLocalizations.of(context)!.selectReasonOfContactError;
    } else {
      return null;
    }
  };
}
