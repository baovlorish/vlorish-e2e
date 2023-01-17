import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/inform_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/restricted_layout.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  final BlocProvider innerBlocProvider;
  final String title;
  final bool isPremium;

  const HomePage({
    Key? key,
    required this.innerBlocProvider,
    required this.title,
    this.isPremium = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    return Builder(
      builder: (context) {
        return BlocConsumer<HomeScreenCubit, HomeScreenState>(
          listener: (context, state) {
            if (state is HomeScreenError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return state.type == CustomExceptionType.Inform
                        ? InformAlertDialog(
                            context,
                            title: AppLocalizations.of(context)!
                                    .theseInstitutionsRequireLogin +
                                state.errorMessage,
                            buttonText: state.errorDialogButtonText,
                            onButtonPress: () {
                              NavigatorManager.navigateTo(
                                context,
                                ManageAccountsPage.routeName,
                              );
                            },
                          )
                        : ErrorAlertDialog(
                            context,
                            message: state.errorMessage,
                            buttonText: state.errorDialogButtonText,
                            onButtonPress: state.callback,
                          );
                  },
                );
              });
            }
          },
          builder: (context, state) {
            {
              RestrictionType? restrictionType;
              if (state is HomeScreenLoaded) {
                //if user is a partner, subscription status is ignored
                if (state.user.role.isPartner) {
                  restrictionType = null;
                } else {
                  //if user has no subscription
                  if (state.user.subscription == null) {
                    restrictionType = RestrictionType.NotSubscribed;
                  } else if (state
                          .user.subscription!.creditCardLastFourDigits ==
                      null) {
                    //checkout session started, but subscription was not created
                    restrictionType = RestrictionType.NotSubscribed;
                  } else if (state.user.subscription!.status == 0) {
                    // subscription created but not active
                    restrictionType = RestrictionType.NotActive;
                  } else if (isPremium &&
                      !(state.user.subscription!.isPremiumOrHigher)) {
                    //if this is premium page but subscription is standard
                    restrictionType = RestrictionType.RestrictedByPlan;
                  } else if (state.user.subscription!.status == 2 ||
                      state.user.subscription!.status == 3) {
                    // subscription has expired or past due
                    restrictionType = RestrictionType.Expired;
                  }
                }
                if (restrictionType == null ||
                    ModalRoute.of(context)!.settings.name! ==
                        ProfileOverviewPage.routeName) {
                  //no restriction was added, show the page
                  //profile overview is not restricted
                  return innerBlocProvider;
                } else {
                  return HomeScreen(
                    bodyWidget: RestrictedLayout(
                        title: title,
                        onPressed: () {
                          if (restrictionType ==
                              RestrictionType.NotSubscribed) {
                            homeScreenCubit.navigateToSubscriptionPage(context);
                          } else {
                            homeScreenCubit.goToCustomerPortal(
                                ModalRoute.of(context)!.settings.name!);
                          }
                        },
                        restrictionType: restrictionType),
                    title: title,
                  );
                }
              } else {
                if (state is HomeScreenLoading) {
                  return HomeScreen(
                    title: title,
                    bodyWidget: CustomLoadingIndicator(),
                  );
                } else {
                  return HomeScreen(
                    title: title,
                    bodyWidget: SizedBox(),
                  );
                }
              }
            }
          },
        );
      },
    );
  }
}
