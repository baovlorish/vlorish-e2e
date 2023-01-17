import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/label_button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/terms_popup.dart';
import 'package:burgundy_budgeting_app/ui/model/manage_users_item_model.dart';
import 'package:burgundy_budgeting_app/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvitationRequestFormAlertDialog extends AlertDialog {
  InvitationRequestFormAlertDialog.addInvitation(
    BuildContext context, {
    String? title,
    String? message,
    required Future<String?> Function(String email) checkEmail,
    required void Function(
            int? accessType, String email, int? role, String? note)
        onButtonPress,
    bool? canInviteCoach,
    bool? canInvitePartner,
  }) : super(
          content: _AddInvitationRequestForm(
            context,
            title: title,
            message: message,
            onButtonPress: onButtonPress,
            isInvitation: true,
            checkEmail: checkEmail,
            canInviteCoach: canInviteCoach,
            canInvitePartner: canInvitePartner,
          ),
        );

  InvitationRequestFormAlertDialog.addRequest(
    BuildContext context, {
    String? title,
    String? message,
    required Future<String?> Function(String email) checkEmail,
    required void Function(
            int? accessType, String email, int? role, String? note)
        onButtonPress,
  }) : super(
          content: _AddInvitationRequestForm(
            context,
            title: title,
            message: message,
            onButtonPress: onButtonPress,
            isInvitation: false,
            checkEmail: checkEmail,
          ),
        );

  InvitationRequestFormAlertDialog.edit(
    BuildContext context, {
    String? title,
    String? message,
    required ManageUsersItemModel itemModel,
    required Future<String?> Function(String email) checkEmail,
    required bool isInvitation,
    required void Function(
            int? accessType, String email, int? role, String? note)
        onButtonPress,
    bool? canInviteCoach,
    bool? canInvitePartner,
  }) : super(
          content: isInvitation
              ? _EditInvitationRequestForm(
                  context,
                  title: title,
                  message: message,
                  onButtonPress: onButtonPress,
                  isInvitation: true,
                  checkEmail: checkEmail,
                  canInviteCoach: canInviteCoach,
                  canInvitePartner: canInvitePartner,
                  itemModel: itemModel,
                )
              : _EditInvitationRequestForm(
                  context,
                  title: title,
                  message: message,
                  onButtonPress: onButtonPress,
                  isInvitation: false,
                  checkEmail: checkEmail,
                  itemModel: itemModel,
                ),
        );
}

class _AddInvitationRequestForm extends StatefulWidget {
  final String? title;
  final String? message;
  final void Function(int? accessType, String email, int? role, String? note)
      onButtonPress;
  final bool isInvitation;
  final Future<String?> Function(String email) checkEmail;
  final bool? canInviteCoach;
  final bool? canInvitePartner;

  _AddInvitationRequestForm(
    BuildContext context, {
    Key? key,
    required this.title,
    required this.message,
    required this.onButtonPress,
    this.isInvitation = true,
    required this.checkEmail,
    this.canInviteCoach,
    this.canInvitePartner,
  }) : super(key: key);

  @override
  _AddInvitationRequestFormState createState() =>
      _AddInvitationRequestFormState();
}

class _AddInvitationRequestFormState extends State<_AddInvitationRequestForm> {
  var enableMainButton = false;

  int? accessType;
  String? email;
  late int? role = !widget.isInvitation ? 3 : null;
  String? note;

  String? emailErrorText;
  var showEmailError = false;
  String? invitationTypeErrorText;
  var showInvitationTypeError = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    enableMainButton = validateButton();
    return Form(
      key: formKey,
      child: Container(
        width: 600,
        child: ColumnItem(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomMaterialInkWell(
                type: InkWellType.Purple,
                borderRadius: BorderRadius.circular(10),
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close_rounded,
                  size: 26,
                  color: CustomColorScheme.close,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: Label(
                  text: widget.isInvitation
                      ? AppLocalizations.of(context)!
                          .provideTheAccessToYourAccount
                      : AppLocalizations.of(context)!
                          .requestTheAccessToUserAccountAsACoach,
                  type: LabelType.Header3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: InputItem(
                labelText: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.emailHint,
                onChanged: (value) {
                  email = value;
                  if (emailErrorText != null && emailErrorText!.isNotEmpty) {
                    showEmailError = false;
                    emailErrorText = null;
                  }
                  setState(() {});
                },
                errorText: emailErrorText,
                showErrorText: showEmailError,
              ),
            ),
            if (widget.isInvitation)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                child: DropdownItem<int>(
                  itemKeys: [
                    2, //partner
                    3, //coach
                  ],
                  callback: (value) {
                    validateInvitationType(value);
                    setState(() {
                      clearEmailValidationError();
                      role = value;
                    });
                  },
                  labelText:
                      AppLocalizations.of(context)!.chooseTheInvitationType,
                  items: [
                    AppLocalizations.of(context)!.partner,
                    AppLocalizations.of(context)!.coach,
                  ],
                  hintText:
                      AppLocalizations.of(context)!.chooseTheInvitationType,
                  errorText: invitationTypeErrorText,
                ),
              ),
            if (role == 3)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                child: DropdownItem<int>(
                  itemKeys: [
                    1, //limited
                    2, //secondary
                  ],
                  callback: (value) {
                    setState(() {
                      accessType = value;
                    });
                  },
                  labelText: AppLocalizations.of(context)!.chooseTheAccessType,
                  items: [
                    AppLocalizations.of(context)!.limited,
                    AppLocalizations.of(context)!.secondary,
                  ],
                  hintText: AppLocalizations.of(context)!.chooseTheAccessType,
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: InputItem(
                labelText: AppLocalizations.of(context)!.writeANote,
                hintText: widget.isInvitation
                    ? AppLocalizations.of(context)!
                        .writeANoteToRememberTheAimOfSendingTheInvitationOnlyTheInvitationSenderCanSeeTheNote
                    : AppLocalizations.of(context)!
                        .writeANoteToRememberTheAimOfSendingTheRequestOnlyTheRequestSenderCanSeeTheNote,
                textInputFormatters: [
                  LengthLimitingTextInputFormatter(85),
                ],
                hintMaxLines: 2,
                maxLines: 2,
                onChanged: (value) {
                  note = value;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: LabelButtonItem(
                        label: Label(
                          text: AppLocalizations.of(context)!.cancel,
                          type: LabelType.LargeButton,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ButtonItem(context,
                        enabled: enableMainButton,
                        buttonType: ButtonType.LargeText,
                        text: AppLocalizations.of(context)!.confirm,
                        onPressed: () async {
                      if (enableMainButton) {
                        var accessTypeIsChanged = true;
                        formKey.currentState!.validate();
                        emailErrorText = FormValidators.emailValidateFunction(
                            email, context);
                        var isChecked;
                        if (emailErrorText == null) {
                          //check email if inviting partner
                          // or on any request
                          if (widget.isInvitation) {
                            isChecked = await checkInvitation();
                          } else {
                            isChecked = await checkRequest();
                          }
                          if (isChecked) {
                            if (accessTypeIsChanged) {
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) =>
                                    TermsPopup(onMainButtonPressed: () {
                                  widget.onButtonPress(
                                      accessType, email!, role, note);
                                  Navigator.pop(context);
                                }),
                              );
                            }
                          }
                        } else {
                          showEmailError = true;
                          setState(() {});
                        }
                      }
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validateButton() {
    if (email == null ||
        email?.isEmpty == true ||
        showEmailError ||
        showInvitationTypeError) {
      return false;
    } else {
      // invitations
      if (widget.isInvitation) {
        if (role != null) {
          // coach needs access type
          if (role == 3) {
            return accessType != null;
          } else {
            // partner
            return true;
          }
        } else {
          return false;
        }
        // requests
      } else {
        return accessType != null;
      }
    }
  }

  void validateInvitationType(int invitationType) {
    if (invitationType == 3 && !(widget.canInviteCoach == true)) {
      // if invitation type is coach and can't invite coach
      showInvitationTypeError = true;
      invitationTypeErrorText = AppLocalizations.of(context)!
          .youReachedTheMaximumAmountOfCoachInvitations;
    } else if (invitationType == 2 && !(widget.canInvitePartner == true)) {
      // if invitation type is partner and can invite partner
      showInvitationTypeError = true;
      invitationTypeErrorText = AppLocalizations.of(context)!
          .youReachedTheMaximumAmountOfPartnerInvitations;
    } else {
      showInvitationTypeError = false;
      invitationTypeErrorText = null;
    }
  }

  Future<bool> checkInvitation() async {
    if (role == 2) {
      emailErrorText = await widget.checkEmail(email!);
      if (emailErrorText == null) {
        return true;
      } else {
        showEmailError = true;
        setState(() {});
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> checkRequest() async {
    emailErrorText = await widget.checkEmail(email!);
    if (emailErrorText == null) {
      return true;
    } else {
      showEmailError = true;
      setState(() {});
      return false;
    }
  }

  void clearEmailValidationError() {
    showEmailError = false;
    emailErrorText = null;
  }
}

class _EditInvitationRequestForm extends StatefulWidget {
  final String? title;
  final String? message;
  final void Function(int? accessType, String email, int? role, String? note)
      onButtonPress;
  final bool isInvitation;
  final Future<String?> Function(String email) checkEmail;
  final bool? canInviteCoach;
  final bool? canInvitePartner;
  final ManageUsersItemModel itemModel;

  _EditInvitationRequestForm(
    BuildContext context, {
    Key? key,
    required this.title,
    required this.message,
    required this.onButtonPress,
    this.isInvitation = true,
    required this.checkEmail,
    this.canInviteCoach,
    this.canInvitePartner,
    required this.itemModel,
  }) : super(key: key);

  @override
  _EditInvitationRequestFormState createState() =>
      _EditInvitationRequestFormState();
}

class _EditInvitationRequestFormState
    extends State<_EditInvitationRequestForm> {
  var enableMainButton = false;

  late int? accessType = widget.itemModel.accessType;
  late String email = widget.itemModel.email;
  late int role = widget.itemModel.role;
  late var initialNote = widget.itemModel.note ?? '';
  late String note = initialNote;

  String? emailErrorText;
  var showEmailError = false;
  String? invitationTypeErrorText;
  var showInvitationTypeError = false;
  final formKey = GlobalKey<FormState>();
  late var roleIsEnabled = widget.isInvitation && widget.itemModel.status == 1;

  @override
  Widget build(BuildContext context) {
    enableMainButton = validateButton();
    return Form(
      key: formKey,
      child: Container(
        width: 600,
        child: ColumnItem(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomMaterialInkWell(
                type: InkWellType.Purple,
                borderRadius: BorderRadius.circular(10),
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close_rounded,
                  size: 26,
                  color: CustomColorScheme.close,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: Label(
                  text: widget.isInvitation
                      ? AppLocalizations.of(context)!.editInvitation
                      : AppLocalizations.of(context)!.editRequest,
                  type: LabelType.Header3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: InputItem(
                value: widget.itemModel.email,
                enabled: false,
                labelText: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.emailHint,
                errorText: emailErrorText,
                showErrorText: showEmailError,
              ),
            ),
            if (widget.isInvitation)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                child: DropdownItem<int>(
                  initialValue: widget.itemModel.role,
                  enabled: roleIsEnabled,
                  itemKeys: [
                    2, //partner
                    3, //coach
                  ],
                  callback: (value) {
                    validateInvitationTypeForEditItem(value);
                    setState(() {
                      clearEmailValidationError();
                      role = value;
                    });
                  },
                  labelText:
                      AppLocalizations.of(context)!.chooseTheInvitationType,
                  items: [
                    AppLocalizations.of(context)!.partner,
                    AppLocalizations.of(context)!.coach,
                  ],
                  hintText:
                      AppLocalizations.of(context)!.chooseTheInvitationType,
                  errorText: invitationTypeErrorText,
                ),
              ),
            if (role == 3)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                child: DropdownItem<int>(
                  initialValue: widget.itemModel.accessType,
                  itemKeys: [
                    1, //limited
                    2, //secondary
                  ],
                  callback: (value) {
                    setState(() {
                      clearEmailValidationError();
                      accessType = value;
                    });
                  },
                  labelText: AppLocalizations.of(context)!.chooseTheAccessType,
                  items: [
                    AppLocalizations.of(context)!.limited,
                    AppLocalizations.of(context)!.secondary,
                  ],
                  hintText: AppLocalizations.of(context)!.chooseTheAccessType,
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: InputItem(
                value: note,
                labelText: AppLocalizations.of(context)!.writeANote,
                hintText: widget.isInvitation
                    ? AppLocalizations.of(context)!
                        .writeANoteToRememberTheAimOfSendingTheInvitationOnlyTheInvitationSenderCanSeeTheNote
                    : AppLocalizations.of(context)!
                        .writeANoteToRememberTheAimOfSendingTheRequestOnlyTheRequestSenderCanSeeTheNote,
                textInputFormatters: [
                  LengthLimitingTextInputFormatter(85),
                ],
                hintMaxLines: 2,
                maxLines: 2,
                onChanged: (value) {
                  setState(() {
                    note = value;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: LabelButtonItem(
                        label: Label(
                          text: AppLocalizations.of(context)!.cancel,
                          type: LabelType.LargeButton,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ButtonItem(context,
                        enabled: enableMainButton,
                        buttonType: ButtonType.LargeText,
                        text: AppLocalizations.of(context)!.confirm,
                        onPressed: () async {
                      if (enableMainButton) {
                        formKey.currentState!.validate();
                        emailErrorText = FormValidators.emailValidateFunction(
                            email, context);
                        if (emailErrorText == null) {
                          //check email if inviting partner
                          var isChecked = await checkForEdit();
                          if (isChecked) {
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) =>
                                  TermsPopup(onMainButtonPressed: () {
                                widget.onButtonPress(
                                    accessType, email, role, note);
                                Navigator.pop(context);
                              }),
                            );
                          }
                        } else {
                          showEmailError = true;
                          setState(() {});
                        }
                      }
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validateButton() {
    var hasError = emailErrorText!=null || showInvitationTypeError;
    var changed = role != widget.itemModel.role ||
        accessType != widget.itemModel.accessType ||
        note != initialNote;
    return !hasError && changed;
  }

  void validateInvitationTypeForEditItem(int newRole) {
    if (newRole != widget.itemModel.role) {
      if (newRole == 3 && !(widget.canInviteCoach == true)) {
        showInvitationTypeError = true;
        invitationTypeErrorText = AppLocalizations.of(context)!
            .youReachedTheMaximumAmountOfCoachInvitations;
      } else if (newRole == 2 && !(widget.canInvitePartner == true)) {
        showInvitationTypeError = true;
        invitationTypeErrorText = AppLocalizations.of(context)!
            .youReachedTheMaximumAmountOfPartnerInvitations;
      }
    } else {
      showInvitationTypeError = false;
      invitationTypeErrorText = null;
    }
  }

  Future<bool> checkForEdit() async {
    if (widget.isInvitation && role == 2) {
      emailErrorText = await widget.checkEmail(email);
      showEmailError = true;
      setState(() {});
      return emailErrorText == null;
    } else {
      return true;
    }
  }

  void clearEmailValidationError() {
    showEmailError = false;
    emailErrorText = null;
  }
}
