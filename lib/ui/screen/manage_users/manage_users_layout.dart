import 'dart:async';

import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/back_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/Invitation_form_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/error_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/inform_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/empty_manage_users_card.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/manage_users_list.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_event.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageUsersLayout extends StatefulWidget {
  const ManageUsersLayout({Key? key}) : super(key: key);

  @override
  _ManageUsersLayoutState createState() => _ManageUsersLayoutState();
}

class _ManageUsersLayoutState extends State<ManageUsersLayout> {
  bool isHintVisible = false;
  bool isHintFocused = false;
  bool isItemFocused = false;
  late final ManageUsersBloc _manageUsersBloc;
  late final HomeScreenCubit _homeScreenCubit;

  @override
  void initState() {
    _manageUsersBloc = BlocProvider.of<ManageUsersBloc>(context);
    _homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      title: AppLocalizations.of(context)!.manageUsers,
      headerWidget: Row(
        children: [
          CustomBackButton(
              onPressed: () =>
                  _manageUsersBloc.navigateToProfileOverview(context)),
          Label(
            text: AppLocalizations.of(context)!.manageUsers,
            type: LabelType.Header2,
          ),
          Spacer(),
          ModalAnchor(
            tag: 'assets/images/icons/ic_help.png',
            child: MouseRegion(
              onEnter: (_) {
                isItemFocused = true;
                if (!isHintVisible) {
                  showHelpMenu('assets/images/icons/ic_help.png');
                }
              },
              onExit: (_) async {
                isItemFocused = false;
                if (isHintVisible) {
                  Timer(
                    Duration(milliseconds: 100),
                    () {
                      if (!isHintFocused) {
                        removeHelpMenu();
                      }
                    },
                  );
                }
              },
              child: ImageIcon(
                AssetImage('assets/images/icons/ic_help.png'),
                color: CustomColorScheme.button,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      bodyWidget: BlocConsumer<ManageUsersBloc, ManageUsersState>(
        listener: (BuildContext context, state) async {
          if (state is ManageUsersError) {
            await showDialog(
              context: context,
              builder: (context) {
                return state.type == CustomExceptionType.Inform
                    ? InformAlertDialog(
                        context,
                        text: state.isInvitation != null
                            ? state.errorMessage
                            : null,
                        title: state.isInvitation != null
                            ? 'The ${state.isInvitation == true ? 'invitation' : 'request'} couldn’t be sent'
                            : state.errorMessage,
                        buttonText: state.errorDialogButtonText,
                      )
                    : ErrorAlertDialog(
                        context,
                        message: state.errorMessage,
                      );
              },
            );
          }
          if (state is ManageUsersLoaded && state.shouldUpdateUserData) {
            await _homeScreenCubit.updateUserData();
          }
        },
        builder: (context, state) {
          if (state is ManageUsersLoading) {
            return CustomLoadingIndicator();
          } else if (state is ManageUsersLoaded) {
            return Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: state.invitationsPageModel.invitations.isEmpty &&
                            state.invitationsPageModel.invitationStatus == 0
                        ? EmptyManageUsersCard(
                            header: AppLocalizations.of(context)!.shareMyBudget,
                            message: AppLocalizations.of(context)!
                                .youHaveNotTheInvitedUsersYet,
                            buttonText:
                                AppLocalizations.of(context)!.sendInvitation,
                            onPressed: () {
                              showInvitationAlertOrForm(
                                  state.invitationsPageModel.canInviteCoach,
                                  state.invitationsPageModel.canInvitePartner);
                            },
                          )
                        : ManageUsersList(
                            state.invitationsPageModel,
                            () {
                              showInvitationAlertOrForm(
                                  state.invitationsPageModel.canInviteCoach,
                                  state.invitationsPageModel.canInvitePartner);
                            },
                            key: ObjectKey(state.invitationsPageModel),
                            filterPosition:
                                state.invitationsPageModel.invitationStatus,
                          ),
                  ),
                  if (_homeScreenCubit.user.subscription!.isAdvisor)
                    Expanded(
                      child: state.requestsPageModel.requests.isEmpty &&
                              state.requestsPageModel.requestsStatus == 0
                          ? EmptyManageUsersCard(
                              header:
                                  AppLocalizations.of(context)!.accessToOthers,
                              message: AppLocalizations.of(context)!
                                  .youHaveNotTheRequestsUsersYet,
                              buttonText:
                                  AppLocalizations.of(context)!.sendRequest,
                              onPressed: () {
                                showRequestAlertOrForm(
                                    !state.requestsPageModel.hasRequestSlots,
                                    !state.requestsPageModel.canRequestToday);
                              },
                            )
                          : ManageUsersList(
                              state.requestsPageModel,
                              () {
                                showRequestAlertOrForm(
                                    !state.requestsPageModel.hasRequestSlots,
                                    !state.requestsPageModel.canRequestToday);
                              },
                              key: ObjectKey(state.requestsPageModel),
                              filterPosition:
                                  state.requestsPageModel.requestsStatus,
                            ),
                    ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  void showInvitationAlertOrForm(bool canInviteCoach, bool canInvitePartner) {
    if (!canInviteCoach && !canInvitePartner) {
      showDialog(
        context: context,
        builder: (_) {
          return InformAlertDialog(
            context,
            title: AppLocalizations.of(context)!
                .youReachedTheMaximumAmountOfInvitations,
            text: AppLocalizations.of(context)!
                .removeExistingInvitationToSendNewOne,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return InvitationRequestFormAlertDialog.addInvitation(
            context,
            checkEmail: (email) async {
              //for Invitation validation error occurs  if role  is partner and  user exists
              var checkEmailAnswer =
                  await _manageUsersBloc.isUserRegistered(email);
              return checkEmailAnswer.isRegistered
                  ? AppLocalizations.of(context)!
                      .mentionedUserIsAlreadyRegistered
                  : null;
            },
            onButtonPress: (accessType, email, role, note) {
              _manageUsersBloc
                  .add(SendInviteEvent(accessType, email, role!, note: note));
            },
            canInviteCoach: canInviteCoach,
            canInvitePartner: canInvitePartner,
            isAdvisor: _homeScreenCubit.user.subscription!.isAdvisor,
          );
        },
      );
    }
  }

  void showRequestAlertOrForm(bool hasRequestSlots, bool canRequestToday) {
    if (hasRequestSlots) {
      showDialog(
        context: context,
        builder: (_) {
          return InformAlertDialog(
            context,
            title: AppLocalizations.of(context)!
                .youHaveReachedTheMaximumNumberOfSentRequests,
            text:
                AppLocalizations.of(context)!.removeExistingRequestToSendNewOne,
          );
        },
      );
    } else if (canRequestToday) {
      showDialog(
        context: context,
        builder: (_) {
          return InformAlertDialog(
            context,
            title: AppLocalizations.of(context)!
                .youHaveReachedTheMaximumNumberOfSentRequestsPerADay,
            text:
                AppLocalizations.of(context)!.newAttemptsWillBeEnrolledTomorrow,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return InvitationRequestFormAlertDialog.addRequest(context,
              checkEmail: (email) async {
            //for request validation error occurs if user doesn't exist or user registered as a partner
            var checkEmailAnswer =
                await _manageUsersBloc.isUserRegistered(email);
            return checkEmailAnswer.isRegistered
                ? checkEmailAnswer.role == 2
                    ? AppLocalizations.of(context)!
                        .userIsAlreadyRegisteredAsPartner
                    : null
                : AppLocalizations.of(context)!
                    .thisEmailIsNotRegisteredInVlorish;
          }, onButtonPress: (accessType, email, role, note) {
            _manageUsersBloc.add(
              SendRequestEvent(accessType!, email, note: note),
            );
          });
        },
      );
    }
  }

  void removeHelpMenu() {
    isHintFocused = false;
    isHintVisible = false;
    removeModal();
  }

  void showHelpMenu(String tag) {
    isHintVisible = true;
    showModal(
      ModalEntry.anchored(
        context,
        tag: 'menu$tag',
        anchorTag: tag,
        modalAlignment: Alignment.topRight,
        anchorAlignment: Alignment.bottomRight,
        child: MouseRegion(
          onEnter: (_) {
            isHintFocused = true;
          },
          onExit: (_) {
            isHintFocused = false;
            Timer(Duration(milliseconds: 100), () {
              if (!isItemFocused) {
                removeHelpMenu();
              }
            });
          },
          child: Material(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                    ),
                  ],
                  color: CustomColorScheme.mainDarkBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Label(
                    type: LabelType.General,
                    textAlign: TextAlign.justify,
                    color: Colors.white,
                    text: _homeScreenCubit.user.subscription!.isBusiness
                        ? '  To share your budget, send the invitation. After the invitation is confirmed by mentioned user, they will have the access to your budget. You can have up to 3 active invitations: 2 coach types and 1 with partner type.'
                        : AppLocalizations.of(context)!.helpHintManageUsers,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    setState(() {});
  }
}
