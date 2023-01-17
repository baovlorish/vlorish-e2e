import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordValidationWidget extends StatefulWidget {
  final String? value;
  final String labelText;

  final String? Function(String?, BuildContext context) validateFunction;
  final void Function(String) onChanged;
  final void Function()? onEditingComplete;
  final bool autofocus;
  final FocusNode? focusNode;

  PasswordValidationWidget({
    required this.labelText,
    this.value,
    required this.validateFunction,
    required this.onChanged,
    this.onEditingComplete,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  _PasswordValidationWidgetState createState() =>
      _PasswordValidationWidgetState();
}

class _PasswordValidationWidgetState extends State<PasswordValidationWidget> {
  String currentValue = '';

  final _animationDuration = const Duration(milliseconds: 500);
  final _animationCurve = Curves.easeOutQuint;

  double _size = 0.0;
  bool _passwordRulesShown = false;
  bool isError = false;

  bool firstRule = false;
  bool secondRule = false;
  bool thirdRule = false;

  void _updateRulesState(String currentValue) {
    firstRule = FormValidators.passwordContains8CharactersFunction(
          currentValue,
          context,
        ) ==
        null;
    secondRule =
        FormValidators.passwordContainsBothLowerAndUpperCaseLettersFunction(
              currentValue,
              context,
            ) ==
            null;

    thirdRule = FormValidators.passwordContainsAtLeastOneNumberAndASymbol(
          currentValue,
          context,
        ) ==
        null;

    isError =
        FormValidators.passwordSignupValidateFunction(currentValue, context) !=
                null &&
            currentValue.isNotEmpty;
  }

  void _showPasswordRules(bool show) {
    _passwordRulesShown = show;
    _size = _passwordRulesShown ? 100.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          curve: _animationCurve,
          opacity: _passwordRulesShown ? 1 : 0,
          duration: _animationDuration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                curve: _animationCurve,
                duration: _animationDuration,
                child: SizedBox(height: _size),
              ),
              Label(
                text: AppLocalizations.of(context)!.createAPasswordThat,
                type: LabelType.GeneralBold,
              ),
              SizedBox(height: 4),
              _PasswordValidationRule(
                rule: AppLocalizations.of(context)!.containsAtLeast8Characters,
                isValid: firstRule,
              ),
              _PasswordValidationRule(
                rule: AppLocalizations.of(context)!
                    .containsBothLowerAndUpperCaseLetters,
                isValid: secondRule,
              ),
              _PasswordValidationRule(
                rule: AppLocalizations.of(context)!
                    .containsAtLeastOneNumberAndASymbol,
                isValid: thirdRule,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.transparent,
              ],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
          ),
          child: InputItem(
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            onEditingComplete: widget.onEditingComplete,
            showErrorText: false,
            labelText: widget.labelText,
            value: widget.value,
            maxLines: 2,
            textInputFormatters: [LengthLimitingTextInputFormatter(128)],
            isPassword: true,
            hintText: AppLocalizations.of(context)!.atLeast8Char,
            validateFunction: (value, context) {
              var error =
                  FormValidators.passwordSignupValidateFunction(value, context);
              isError = error != null;
              _showPasswordRules(isError);
              setState(() {});
              return error;
            },
            onChanged: (value) {
              currentValue = value;

              _updateRulesState(currentValue);
              _showPasswordRules(currentValue.isNotEmpty);
              widget.onChanged(currentValue);
              setState(() {});
            },
          ),
        ),
        AnimatedOpacity(
          curve: _animationCurve,
          opacity: isError ? 1 : 0,
          duration: _animationDuration,
          child: Align(
            alignment: Alignment.topRight,
            child: isError
                ? CustomTooltip(
                    color: CustomColorScheme.inputErrorBorder,
                    message: 'That\'s  an invalid password',
                    child: Icon(
                      Icons.info,
                      color: CustomColorScheme.inputErrorBorder,
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ],
    );
  }
}

class _PasswordValidationRule extends StatelessWidget {
  final String rule;
  final bool isValid;

  _PasswordValidationRule({
    required this.rule,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.done_rounded : Icons.close_rounded,
            size: 24.0,
            color: isValid
                ? CustomColorScheme.successPopupButton
                : CustomColorScheme.inputErrorBorder,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Label(
              text: rule,
              type: LabelType.General,
              color: isValid
                  ? CustomColorScheme.successPopupButton
                  : CustomColorScheme.inputErrorBorder,
            ),
          ),
        ],
      ),
    );
  }
}
