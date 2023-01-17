import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupAddCardLayout extends StatefulWidget {
  const SignupAddCardLayout();

  @override
  State<SignupAddCardLayout> createState() => _SignupAddCardLayoutState();
}

class _SignupAddCardLayoutState extends State<SignupAddCardLayout> {
  final connectAccountsButtonNode = FocusNode();

  UserRole? role;
  late final SignupAddCardCubit signupAddCardCubit;

  @override
  void initState() {
    signupAddCardCubit = BlocProvider.of<SignupAddCardCubit>(context);
    connectAccountsButtonNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    connectAccountsButtonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupAddCardCubit, SignupAddCardState>(
        listener: (context, state) {
      if (state is ErrorAddCardState) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              context,
              message: state.message,
            );
          },
        );
      }
    }, builder: (context, state) {
      role = signupAddCardCubit.role;
      return AuthScreen(
        title: AppLocalizations.of(context)!.signupPersonalDataHeadline,
        showDefaultSignupTopWidget: true,
        role: role,
        leftSideColumnWidgetIndex: 7,
        availableIndex: 7,
        isLeftSideColumnButtonsActive: !(state is LoadingAddCardState),
        centerWidget: BlocListener<HomeScreenCubit, HomeScreenState>(
          listener: (_, homeScreenState) {
            if (homeScreenState is HomeScreenLoaded) {
              if (homeScreenState.user.subscription == null ||
                  homeScreenState.user.subscription?.creditCardLastFourDigits ==
                      null) {
                signupAddCardCubit.userNotSubscribed(
                  context,
                  AppLocalizations.of(context)!.youHaveNotSubscribedYet,
                );
              } else {
                signupAddCardCubit.referralConvert();
              }
            }
          },
          child: ColumnItem(
            children: [
              Label(
                text: AppLocalizations.of(context)!.connectAccounts,
                type: LabelType.Header,
              ),
              SizedBox(
                height: 12,
              ),
              Label(
                text: AppLocalizations.of(context)!.connectAccountsText,
                type: LabelType.General,
              ),
              SizedBox(
                height: 43,
              ),
              Label(
                text: AppLocalizations.of(context)!.whatIsPlaid,
                type: LabelType.Header2,
              ),
              SizedBox(
                height: 14,
              ),
              Label(
                text: AppLocalizations.of(context)!.plaidIs,
                type: LabelType.General,
              ),
              SizedBox(
                height: 40,
              ),
              if (state is LoadingAddCardState)
                CustomLoadingIndicator(isExpanded: false),
              if (!(state is LoadingAddCardState))
                ButtonItem(
                  context,
                  focusNode: connectAccountsButtonNode,
                  buttonType: ButtonType.LargeText,
                  text: AppLocalizations.of(context)!.connectPlaidButton,
                  onPressed: () {
                    signupAddCardCubit.connectPlaidAccount(context);
                  },
                ),
              SizedBox(
                height: 25,
              ),
/*              if (role != null && role!.isCoach)
                Align(
                  alignment: Alignment.center,
                  child: LabelButtonItem(
                    label: Label(
                        text: AppLocalizations.of(context)!.skip,
                        type: LabelType.Link),
                    onPressed: () => NavigatorManager.navigateTo(
                        context, BudgetBusinessPage.routeName),
                  ),
                ),*/
            ],
          ),
        ),
      );
    });
  }
}
