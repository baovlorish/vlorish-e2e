import 'package:burgundy_budgeting_app/ui/atomic/atom/colored_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/new_show_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/card_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/model/account.dart';
import 'package:burgundy_budgeting_app/ui/model/account_group.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_account_from_plaid_popup.dart';

class InstitutionView extends StatelessWidget {
  final AccountGroup group;

  final VoidCallback? onDeleteGroup;
  final VoidCallback onLoginWithPlaid;
  final VoidCallback onManageInstitution;
  final ProfileOverviewModel user;

  const InstitutionView({
    required this.group,
    this.onDeleteGroup,
    required this.onLoginWithPlaid,
    required this.onManageInstitution,
    required this.user,
    Key? key,
  }) : super(key: key);

  bool get showReconnectButton => !group.isManual && group.isLoginRequired;
  bool get showManageInstitutionButton => !group.isManual && canEdit && !group.isLoginRequired;
  bool get canEdit => group.isOwnerBudgetUser ^ user.role.isPartner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Label(text: group.institutionName, type: LabelType.NewLargeTextStyle),
                if (!canEdit) Label(text: ' (${AppLocalizations.of(context)!.partner})', type: LabelType.Header3),
                Spacer(),
                if (showReconnectButton)
                  CustomOneTooltip(
                    message: AppLocalizations.of(context)!.reconnectAccountMessage,
                    child: ColoredButton(
                      onPressed: onLoginWithPlaid,
                      buttonStyle: ColoredButtonStyle.Red,
                      isTransparent: false,
                      child: Label(
                        text: AppLocalizations.of(context)!.reconnect,
                        type: LabelType.NewSmallTextStyle,
                        color: VersionTwoColorScheme.White,
                      ),
                    ),
                  ),
                if (showManageInstitutionButton)
                  NewOutlinedButton(
                    isTransparent: true,
                    enabled: !group.isLoginRequired,
                    onPressed: onManageInstitution,
                    buttonStyle: ColoredButtonStyle.Purple,
                    child: Label(
                      text: AppLocalizations.of(context)!.manageInstitution,
                      type: LabelType.NewSmallTextStyle,
                    ),
                  ),
                if (!group.isManual)
                  NewOutlinedButton(
                    onPressed: onDeleteGroup,
                    buttonStyle: ColoredButtonStyle.Purple,
                    onlyIcon: true,
                    isTransparent: true,
                    child: ImageIcon(
                      AssetImage('assets/images/icons/remove_accounts_icon.png'),
                      color: VersionTwoColorScheme.Black,
                      size: 14,
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _getCardWidgets(group.accounts, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getCardWidgets(List<Account> accounts, BuildContext context) {
    var manageAccountsCubit = BlocProvider.of<ManageAccountsCubit>(context);
    var cards = <CardWidget>[];
    for (var item in accounts) {
      cards.add(
        CardWidget(
          key: UniqueKey(),
          account: item,
          muteCallBack: () async {
            var businessNameList = [''];
            if (!user.subscription!.isStandard) {
              businessNameList = await manageAccountsCubit.businessNameList();
            }
            await showDialog(
              context: context,
              builder: (_context) {
                return item.usageType == 0
                    ? AddAccountFromPlaidPopup(
                        bankAccounts: [item as BankAccount],
                        showItemsValidation: false,
                        businessNameList: businessNameList,
                        plaidRepository: manageAccountsCubit.accountsTransactionsRepository,
                        netWorthRepository: manageAccountsCubit.netWorthRepository,
                        onSuccessCallback: () async => await manageAccountsCubit.updateAccounts(),
                        isStandardSubscription: user.subscription!.isStandard,
                      )
                    : _getMuteDialog(context, item);
              },
            );
          },
          deleteCallBack: group.isManual
              ? () => newShowDialog(
                    context,
                    builder: (_context) => DeleteAccountAlertDialog(
                      itemName: item.name,
                      deleteCallback: () async => await manageAccountsCubit.deleteManualAccount(item),
                    ),
                  )
              : null,
        ),
      );
    }
    return cards;
  }

  Widget _getMuteDialog(BuildContext context, Account item) {
    var manageAccountsCubit = BlocProvider.of<ManageAccountsCubit>(context);
    return TwoButtonsDialog(
      context,
      title:
          '${AppLocalizations.of(context)!.areYouSureTo} ${item.isMuted ? AppLocalizations.of(context)!.unmute : AppLocalizations.of(context)!.mute} ${item.name}?',
      mainButtonText:
          item.isMuted ? AppLocalizations.of(context)!.yesUnmuteIt : AppLocalizations.of(context)!.yesMuteIt,
      dismissButtonText: AppLocalizations.of(context)!.no,
      onMainButtonPressed: () async => await manageAccountsCubit.changeMuteMode(item),
    );
  }
}

class DeleteAccountAlertDialog extends StatelessWidget {
  final String itemName;
  final void Function() deleteCallback;

  const DeleteAccountAlertDialog({Key? key, required this.deleteCallback, required this.itemName}) : super(key: key);

  @override
  Widget build(BuildContext context) => ActionConfirmDialog(
        title: '${AppLocalizations.of(context)!.areYouSureToRemove} $itemName?',
        description: AppLocalizations.of(context)!.removeAccountDescription,
        image: ImageIcon(
          AssetImage('assets/images/icons/delete_face_icon.png'),
          color: VersionTwoColorScheme.Black,
          size: 60,
        ),
        rightButtonText: AppLocalizations.of(context)!.neverMind,
        leftButtonText: AppLocalizations.of(context)!.yesRemove,
        leftButtonCallback: deleteCallback,
        backgroundColor: VersionTwoColorScheme.RedBackground,
        borderColor: VersionTwoColorScheme.Red,
        leftButtonStyle: ColoredButtonStyle.Red,
      );
}