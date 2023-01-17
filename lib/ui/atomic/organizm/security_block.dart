import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/maybe_flexible_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/password_validation_widget.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_state.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SecurityBlock extends StatefulWidget {
  final bool isSmall;

  const SecurityBlock({Key? key, required this.isSmall}) : super(key: key);

  @override
  _SecurityBlockState createState() => _SecurityBlockState();
}

class _SecurityBlockState extends State<SecurityBlock> {
  var _oldPass = '';

  var _newPass = '';

  final _formKey = GlobalKey<FormState>();

  late final ProfileOverviewCubit profileOverviewCubit;

  @override
  void initState() {
    profileOverviewCubit = BlocProvider.of<ProfileOverviewCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColorScheme.blockBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(AppLocalizations.of(context)!.security,
                  style: CustomTextStyle.HeaderTextStyle(context)
                      .copyWith(fontSize: 24)),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Flex(
                direction: widget.isSmall ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaybeFlexibleWidget(
                    flexibleWhen: !widget.isSmall,
                    child: InputItem(
                      labelText: AppLocalizations.of(context)!.currentPassword,
                      hintText: AppLocalizations.of(context)!
                          .enterYourCurrentPassword,
                      validateFunction: FormValidators
                          .changePasswordCurrentPasswordValidateFunction,
                      value: _oldPass,
                      onChanged: (String value) {
                        _oldPass = value;
                      },
                      isPassword: true,
                    ),
                  ),
                  SizedBox(width: 32, height: 20),
                  MaybeFlexibleWidget(
                    flexibleWhen: !widget.isSmall,
                    child: PasswordValidationWidget(
                      labelText: AppLocalizations.of(context)!.newPassword,
                      validateFunction:
                          FormValidators.passwordSignupValidateFunction,
                      value: _newPass,
                      onChanged: (String value) {
                        _newPass = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 200,
                child: ((profileOverviewCubit.state is ProfileOverviewLoaded) &&
                        (profileOverviewCubit.state as ProfileOverviewLoaded)
                            .isPasswordLoading)
                    ? CustomLoadingIndicator(isExpanded: false)
                    : ButtonItem(
                        context,
                        text: AppLocalizations.of(context)!.updatePassword,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            profileOverviewCubit.changePassword(
                                _oldPass, _newPass);
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
