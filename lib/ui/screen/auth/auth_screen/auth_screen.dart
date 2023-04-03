import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/password/signup_password_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthScreen extends StatelessWidget with DiProvider {
  final Image logo = Image.asset(
    'assets/images/2.0x/logo_word_white_full.png',
    height: 40,
    fit: BoxFit.fitHeight,
  );

  final Image leftArt = Image.asset('assets/images/background_popart_left.png');

  final Image rightArt = Image.asset('assets/images/background_popart_right_bottom.png');

  final String title;
  final Widget centerWidget;
  final Widget? topRightWidget;
  final int leftSideColumnWidgetIndex;
  final bool showDefaultSignupTopWidget;
  final bool isLeftSideColumnButtonsActive;
  final int availableIndex;
  late final UserRole role;

  AuthScreen(
      {required this.centerWidget,
      this.topRightWidget,
      required this.title,
      required this.availableIndex,
      this.leftSideColumnWidgetIndex = 0,
      this.showDefaultSignupTopWidget = false,
      this.isLeftSideColumnButtonsActive = true,
      UserRole? role})
      : role = role ?? UserRole.primary();

  @override
  Widget build(BuildContext context) {
    if (leftSideColumnWidgetIndex > availableIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigatorManager.navigateTo(context, chooseStep(availableIndex));
      });
    }
    return Scaffold(
      backgroundColor: CustomColorScheme.authBackGround,
      body: Title(
        key: ObjectKey(role),
        color: Colors.white,
        title: title,
        child: BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository, userRepository,
              fetchUserData: (leftSideColumnWidgetIndex == 1 || leftSideColumnWidgetIndex == 2)),
          child: Stack(children: [
            Align(alignment: Alignment.centerLeft, child: leftArt),
            Align(alignment: Alignment.bottomRight, child: rightArt),
            Builder(builder: (context) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32, left: 48, right: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomMaterialInkWell(
                              type: InkWellType.White,
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                NavigatorManager.navigateTo(context, SigninPage.routeName,
                                    transition: TransitionType.material);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: logo,
                              )),
                        ),
                        Flexible(
                            child: showDefaultSignupTopWidget
                                ? _defaultSignupTopWidget(context)
                                : topRightWidget ?? SizedBox()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (leftSideColumnWidgetIndex != 0)
                          Container(
                            width: 400,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                                  return _leftSideColumnWidget(
                                      leftSideColumnWidgetIndex, state, availableIndex, context);
                                }),
                              ],
                            ),
                          ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Center(child: centerWidget),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ]),
        ),
      ),
    );
  }

  Widget _leftSideColumnWidget(
      int currentIndex, AuthState state, int availableScreenIndex, BuildContext context) {
    if (currentIndex == 0) {
      return SizedBox();
    } else {
      var availableIndex = availableScreenIndex;
      if (state is AuthLoadedState && state.availableStep != null) {
        availableIndex = state.availableStep!;
      }
      var buttonDataMap = {
        AppLocalizations.of(context)!.passwordRouteButtonText: SignupPasswordPage.routeName,
        AppLocalizations.of(context)!.mailCodeRouteButtonText: SignupMailCodePage.routeName,
        AppLocalizations.of(context)!.personalDataRouteButtonText: SignupPersonalDataPage.routeName,
        AppLocalizations.of(context)!.employmentRouteButtonText: SignupEmploymentPage.routeName,
        AppLocalizations.of(context)!.experienceRouteButtonText: SignupExperiencePage.routeName,
        if (!role.isPartner) AppLocalizations.of(context)!.subscription: SubscriptionPage.routeName,
        if (!role.isPartner)
          AppLocalizations.of(context)!.addCardRouteButtonText: SignupAddCardPage.routeName,
      };
      return Expanded(
        key: UniqueKey(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 0, 80),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(buttonDataMap.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28.0, right: 20),
                    child: CustomMaterialInkWell(
                      borderRadius: BorderRadius.circular(16),
                      canRequestFocus: false,
                      type: InkWellType.White,
                      onTap:
                          // empty callback on current item to show item as InkWell but not reload page
                          index == currentIndex - 1
                              ? () {}
                              : index < availableIndex && isLeftSideColumnButtonsActive
                                  ? () {
                                      NavigatorManager.navigateTo(
                                        context,
                                        buttonDataMap.values.toList()[index],
                                        params: {
                                          'type': 'returned',
                                          'role': role.mappedValue.toString()
                                        },
                                      );
                                    }
                                  : null,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: index == currentIndex - 1 ? Colors.white12 : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 32.0,
                              width: 32.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: CustomColorScheme.authColumnEmpty),
                                color: index < availableIndex
                                    ? CustomColorScheme.blockBackground
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: index < availableIndex
                                      ? CustomTextStyle.AuthNumberTextStyle(context)
                                      : CustomTextStyle.AuthNumberEmptyTextStyle(context),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              buttonDataMap.keys.toList()[index],
                              style: index < availableIndex
                                  ? CustomTextStyle.AuthColumnFilledTextStyle(context)
                                  : CustomTextStyle.AuthColumnEmptyTextStyle(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _defaultSignupTopWidget(BuildContext context) => Wrap(
        children: [
          Label(
            text: AppLocalizations.of(context)!.alreadyHaveAccount,
            type: LabelType.General,
          ),
          LabelButtonItem(
            label: Label(
              text: AppLocalizations.of(context)!.signIn,
              type: LabelType.Link,
            ),
            onPressed: () {
              NavigatorManager.navigateTo(
                context,
                SigninPage.routeName,
                transition: TransitionType.material,
              );
            },
          ),
        ],
      );
}
