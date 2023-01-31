import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/Invitation_form_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/terms_popup.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/model/manage_users_item_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'manage_users_list.dart';

class ManageUsersListItem extends StatefulWidget {
  const ManageUsersListItem._inner({
    Key? key,
    required this.model,
    this.canInviteCoach,
    this.canInvitePartner,
    this.hasRequestSlots,
    this.canRequestToday,
    required this.onItemChanged,
  }) : super(key: key);

  factory ManageUsersListItem.fromInvitationModel(
          {required Key key,
          required ManageUsersItemModel manageUsersItemModel,
          required bool canInviteCoach,
          required bool canInvitePartner,
          required Function(ManageUsersItemModel model) onItemChanged}) =>
      ManageUsersListItem._inner(
        key: key,
        model: manageUsersItemModel,
        canInviteCoach: canInviteCoach,
        canInvitePartner: canInvitePartner,
        onItemChanged: onItemChanged,
      );

  factory ManageUsersListItem.fromRequestModel(
          {required Key key,
          required ManageUsersItemModel manageUsersItemModel,
          required bool hasRequestSlots,
          required bool canRequestToday,
          required Function(ManageUsersItemModel model) onItemChanged}) =>
      ManageUsersListItem._inner(
        key: key,
        model: manageUsersItemModel,
        hasRequestSlots: hasRequestSlots,
        canRequestToday: canRequestToday,
        onItemChanged: onItemChanged,
      );

  final ManageUsersItemModel model;

  final bool? canInviteCoach;
  final bool? canInvitePartner;

  final bool? hasRequestSlots;
  final bool? canRequestToday;
  final Function(ManageUsersItemModel model) onItemChanged;

  @override
  _ManageUsersListItemState createState() => _ManageUsersListItemState();
}

class _ManageUsersListItemState extends State<ManageUsersListItem>
    with ManageUsersFlexFactors {
  var initials = '';
  final TextEditingController _controller = TextEditingController();
  var fillColor = Colors.transparent;
  var focusNode = FocusNode();

  late final canInviteCoach = widget.canInviteCoach;
  late final canInvitePartner = widget.canInvitePartner;

  late final hasRequestSlots = widget.hasRequestSlots;
  late final canRequestToday = widget.canRequestToday;

  late ManageUsersItemModel model = widget.model;
  var manageUsersBloc;

  @override
  void initState() {
    super.initState();
    manageUsersBloc = BlocProvider.of<ManageUsersBloc>(context);
    _controller.text = widget.model.note ?? '';
    focusNode.addListener(() {
      fillColor = focusNode.hasFocus
          ? CustomColorScheme.tableBorder
          : Colors.transparent;
      if (!focusNode.hasFocus && _controller.text != model.note) {
        model = model.copyWith(note: _controller.text);
        widget.onItemChanged(model);
        manageUsersBloc.add(NoteEvent(model: model));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (model.targetUserFirstName != null &&
        model.targetUserFirstName?.isNotEmpty == true) {
      initials = model.targetUserFirstName![0];
      if ((model.targetUserLastName != null &&
          model.targetUserLastName?.isNotEmpty == true)) {
        initials += '${model.targetUserLastName![0]}';
      }
    } else {
      if ((model.targetUserLastName != null &&
          model.targetUserLastName?.isNotEmpty == true)) {
        initials = model.targetUserLastName![0];
      }
    }
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: listOfFlexFactors[0],
                child: showWaitingForConfirmation()
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 24),
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Label(
                            text: AppLocalizations.of(context)!
                                .waitingForConfirmation,
                            type: LabelType.General,
                            color: CustomColorScheme.textHint,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AvatarWidget(
                              imageUrl: model.targetUserIconUrl,
                              initials: initials.toUpperCase(),
                              colorGeneratorKey: model.email,
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Label(
                                text: '${model.targetUserFirstName ?? ''} '
                                    '${model.targetUserLastName ?? ''}',
                                type: LabelType.General,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              CustomVerticalDivider(
                color: CustomColorScheme.tableBorder,
              ),
              Expanded(
                flex: listOfFlexFactors[1],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Label(
                      text: model.email,
                      type: LabelType.General,
                    ),
                  ),
                ),
              ),
              CustomVerticalDivider(
                color: CustomColorScheme.tableBorder,
              ),
              Expanded(
                flex: listOfFlexFactors[2],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Label(
                      text: widget.model.role == 2
                          ? AppLocalizations.of(context)!.partner
                          : widget.model.role == 3
                              ? AppLocalizations.of(context)!.coach
                              : '',
                      type: LabelType.General,
                    ),
                  ),
                ),
              ),
              CustomVerticalDivider(
                color: CustomColorScheme.tableBorder,
              ),
              Expanded(
                flex: listOfFlexFactors[3],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Row(children: [
                      if (model.isAccessTypeChangingRequested &&
                          !model.isInvitation)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: CustomTooltip(
                            message: AppLocalizations.of(context)!
                                .waitingForApprovingNewAccessType,
                            child: Icon(Icons.info_sharp,
                                color: Colors.blueAccent),
                          ),
                        ),
                      Label(
                        text: model.accessType == 2
                            ? AppLocalizations.of(context)!.editor
                            : model.accessType == 1
                                ? AppLocalizations.of(context)!.readOnly
                                : '-',
                        type: LabelType.General,
                      ),
                    ]),
                  ),
                ),
              ),
              CustomVerticalDivider(
                color: CustomColorScheme.tableBorder,
              ),
              Expanded(
                flex: listOfFlexFactors[4],
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: fillColor,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    minLines: 1,
                                    maxLines: 2,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(85),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomVerticalDivider(
                      color: CustomColorScheme.tableBorder,
                    ),
                    SizedBox(
                      width: model.isInvitation ? 100 : 150,
                      child: isInvitation()
                          ? Row(
                              key: Key(model.status.toString() + model.id),
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomTooltip(
                                  message: isCheckButtonActive()
                                      ? AppLocalizations.of(context)!.accept
                                      : AppLocalizations.of(context)!
                                          .youReachedTheMaximumAmountOfInvitations,
                                  child: CustomMaterialInkWell(
                                    borderRadius: BorderRadius.circular(22),
                                    onTap: isCheckButtonActive()
                                        ? () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => TermsPopup(
                                                onMainButtonPressed: () {
                                                  manageUsersBloc.add(
                                                    ApproveEvent(
                                                        model: widget.model),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        : null,
                                    type: InkWellType.Purple,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          'assets/images/icons/success.png',
                                        ),
                                        color: isCheckButtonActive()
                                            ? CustomColorScheme
                                                .tablePositivePersonal
                                            : CustomColorScheme.textHint,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                CustomTooltip(
                                  message:
                                      AppLocalizations.of(context)!.decline,
                                  child: CustomMaterialInkWell(
                                    borderRadius: BorderRadius.circular(22),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => TwoButtonsDialog(
                                          context,
                                          height: 200,
                                          title: !widget.model.isInvitation
                                              ? AppLocalizations.of(context)!
                                                  .declineTheInvitation
                                              : AppLocalizations.of(context)!
                                                  .declineTheRequest,
                                          message: !widget.model.isInvitation
                                              ? AppLocalizations.of(context)!
                                                  .youCouldNotViewTheSharedBudgetByDecliningTheInvitation
                                              : AppLocalizations.of(context)!
                                                  .youCouldNotProvideTheAccessToYourBudget,
                                          dismissButtonText:
                                              AppLocalizations.of(context)!
                                                  .cancel,
                                          mainButtonText:
                                              AppLocalizations.of(context)!
                                                  .confirm,
                                          onMainButtonPressed: () {
                                            manageUsersBloc.add(
                                              DeleteEvent(model: widget.model),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    type: InkWellType.Purple,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          'assets/images/icons/close.png',
                                        ),
                                        color:
                                            CustomColorScheme.errorPopupButton,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              key: Key(model.status.toString() + model.id),
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (!model.isInvitation)
                                  CustomTooltip(
                                    message: model.status == 1
                                        ? AppLocalizations.of(context)!
                                            .theUserHasNotApproveTheRequest
                                        : null,
                                    child: CustomMaterialInkWell(
                                      borderRadius: BorderRadius.circular(22),
                                      onTap: model.status == 2
                                          ? () {
                                              manageUsersBloc
                                                  .startForeignSession(
                                                      model.userId,
                                                      model.accessType!,
                                                      model.targetUserFirstName,
                                                      model.targetUserLastName,
                                                      context);
                                            }
                                          : null,
                                      type: InkWellType.Purple,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ImageIcon(
                                          AssetImage(
                                            'assets/images/icons/trailing.png',
                                          ),
                                          color: model.status == 1
                                              ? CustomColorScheme.textHint
                                              : CustomColorScheme
                                                  .mainDarkBackground,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                CustomTooltip(
                                  message:
                                      model.isInvitation || model.status == 2
                                          ? AppLocalizations.of(context)!.edit
                                          : null,
                                  child: CustomMaterialInkWell(
                                    borderRadius: BorderRadius.circular(22),
                                    onTap: model.isInvitation ||
                                            model.status == 2
                                        ? () {
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return InvitationRequestFormAlertDialog
                                                      .edit(
                                                    context,
                                                    itemModel: model,
                                                    isInvitation: widget
                                                        .model.isInvitation,
                                                    canInviteCoach:
                                                        widget.canInviteCoach,
                                                    canInvitePartner:
                                                        widget.canInvitePartner,
                                                    checkEmail: (email) async {
                                                      var checkEmailAnswer =
                                                          await manageUsersBloc
                                                              .isUserRegistered(
                                                                  email);
                                                      return checkEmailAnswer
                                                              .isRegistered
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .mentionedUserIsAlreadyRegistered
                                                          : null;
                                                    },
                                                    onButtonPress: (accessType, email, role, note) {

                                                      manageUsersBloc.add(
                                                        EditItemEvent(
                                                            model: widget.model,
                                                            note: note,
                                                            accessType: accessType,
                                                            role: role),
                                                      );
                                                      setState(() {

                                                        model = model.copyWith(
                                                            role: role,
                                                            note: note,
                                                            accessType:
                                                                model.isInvitation ? accessType : model.accessType,
                                                            isAccessTypeChangingRequested:
                                                                model.accessType != accessType &&
                                                                    !model.isInvitation);
                                                        _controller.text = note ?? model.note ?? '';
                                                        widget.onItemChanged(model); //updating note in item
                                                      });
                                                    },
                                                  );
                                                });
                                          }
                                        : null,
                                    type: InkWellType.Purple,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          'assets/images/icons/edit_ic.png',
                                        ),
                                        color: widget.model.isInvitation ||
                                                widget.model.status == 2
                                            ? CustomColorScheme
                                                .mainDarkBackground
                                            : CustomColorScheme.textHint,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ),
                                CustomTooltip(
                                  message: AppLocalizations.of(context)!.delete,
                                  child: CustomMaterialInkWell(
                                    borderRadius: BorderRadius.circular(22),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => TwoButtonsDialog(
                                          context,
                                          height: 200,
                                          title: widget.model.isInvitation
                                              ? AppLocalizations.of(context)!
                                                  .declineTheAccess
                                              : AppLocalizations.of(context)!
                                                  .cancelTheRequest,
                                          message: widget.model.isInvitation
                                              ? AppLocalizations.of(context)!
                                                  .invitedUserCouldNotGetTheAccessToYourAccount
                                              : AppLocalizations.of(context)!
                                                  .requestedUserCouldNotProvideTheAccessToTheirAccount,
                                          dismissButtonText:
                                              AppLocalizations.of(context)!
                                                  .cancel,
                                          mainButtonText:
                                              AppLocalizations.of(context)!
                                                  .confirm,
                                          onMainButtonPressed: () {
                                            manageUsersBloc.add(
                                              DeleteEvent(model: widget.model),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    type: InkWellType.Purple,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          'assets/images/icons/delete.png',
                                        ),
                                        color: CustomColorScheme
                                            .mainDarkBackground,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isAccessTypeChangingRequested())
          Container(
            color: CustomColorScheme.homeBodyWidgetBackground,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Label(
                        text: widget.model.accessType == 1
                            ? AppLocalizations.of(context)!
                                .theUserAskedToChangeTheAccessTypeReadOnlyToEditor
                            : AppLocalizations.of(context)!
                                .theUserAskedToChangeTheAccessTypeEditorToReadOnly,
                        type: LabelType.GeneralBold),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomTooltip(
                        message: AppLocalizations.of(context)!.accept,
                        child: CustomMaterialInkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => TermsPopup(
                                onMainButtonPressed: () {
                                  manageUsersBloc.add(
                                    AcceptAccessTypeChangingEvent(
                                        model: widget.model),
                                  );
                                  model = model.copyWith(
                                      accessType:
                                          widget.model.requestedAccessType);
                                  widget.onItemChanged(model);
                                },
                              ),
                            );
                          },
                          type: InkWellType.Purple,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/icons/success.png',
                              ),
                              color: CustomColorScheme.tablePositivePersonal,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      CustomTooltip(
                        message: AppLocalizations.of(context)!.decline,
                        child: CustomMaterialInkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            manageUsersBloc.add(
                              DeclineAccessTypeChangingEvent(
                                  model: widget.model),
                            );
                          },
                          type: InkWellType.Purple,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/icons/close.png',
                              ),
                              color: CustomColorScheme.errorPopupButton,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  bool showWaitingForConfirmation() {
    if (widget.model.isInvitation) {
      return widget.model.status == 1 &&
          widget.model.sharingApplicationType == 1;
    } else {
      return widget.model.status == 1 &&
          widget.model.sharingApplicationType == 2;
    }
  }

  bool isInvitation() {
    if (widget.model.isInvitation) {
      return widget.model.status == 1 &&
          widget.model.sharingApplicationType == 2;
    } else {
      return widget.model.status == 1 &&
          widget.model.sharingApplicationType == 1;
    }
  }

  bool isCheckButtonActive() {
    if (widget.model.isInvitation) {
      return canInviteCoach!;
    } else {
      return hasRequestSlots!;
    }
  }

  bool isAccessTypeChangingRequested() {
    if (widget.model.isInvitation) {
      return widget.model.isAccessTypeChangingRequested;
    } else {
      return false;
    }
  }
}
