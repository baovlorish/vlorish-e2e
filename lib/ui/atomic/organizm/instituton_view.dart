import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item_transparent.dart';
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

  final Function? onDeleteGroup;
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

  @override
  Widget build(BuildContext context) {
    var canEdit = (group.isOwnerBudgetUser ^ user.role.isPartner);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Label(text: group.institutionName, type: LabelType.Header3),
                if (!canEdit)
                  Label(
                      text: ' (${AppLocalizations.of(context)!.partner})',
                      type: LabelType.Header3),
                Spacer(),
                if (!group.isManual && group.isLoginRequired)
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ButtonItemTransparent(
                      context,
                      color: CustomColorScheme.inputErrorBorder,
                      text: AppLocalizations.of(context)!.loginWithPlaid,
                      onPressed: onLoginWithPlaid,
                    ),
                  ),
                if (!group.isManual && canEdit)
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ButtonItemTransparent(
                      context,
                      text: AppLocalizations.of(context)!.manageInstitution,
                      onPressed: onManageInstitution,
                    ),
                  ),
                if (!group.isManual)
                  CustomMaterialInkWell(
                    borderRadius: BorderRadius.circular(4),
                    materialColor: Colors.transparent,
                    type: InkWellType.Purple,
                    onTap: () => onDeleteGroup?.call(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ImageIcon(
                        AssetImage('assets/images/icons/delete.png'),
                        color: CustomColorScheme.mainDarkBackground,
                        size: 24,
                      ),
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
            var businessNameList = await manageAccountsCubit.businessNameList();
            await showDialog(
              context: context,
              builder: (_context) {
                return item.usageType == 0
                    ? AddAccountFromPlaidPopup(
                        bankAccounts: [item as BankAccount],
                        showItemsValidation: false,
                        businessNameList: businessNameList,
                        plaidRepository:
                            manageAccountsCubit.accountsTransactionsRepository,
                        netWorthRepository: manageAccountsCubit.netWorthRepository,
                        onSuccessCallback: () async {
                          await manageAccountsCubit.updateAccounts();
                        },
                      )
                    : _getMuteDialog(context, item);
              },
            );
          },
          deleteCallBack: group.isManual
              ? () {
                  showDialog(
                    context: context,
                    builder: (_context) {
                      return TwoButtonsDialog(
                        context,
                        title:
                            '${AppLocalizations.of(context)!.areYouSureToRemove} ${item.name}?',
                        mainButtonText:
                            AppLocalizations.of(context)!.yesRemoveIt,
                        dismissButtonText: AppLocalizations.of(context)!.no,
                        onMainButtonPressed: () async {
                          await manageAccountsCubit.deleteManualAccount(item);
                        },
                      );
                    },
                  );
                }
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
      mainButtonText: item.isMuted
          ? AppLocalizations.of(context)!.yesUnmuteIt
          : AppLocalizations.of(context)!.yesMuteIt,
      dismissButtonText: AppLocalizations.of(context)!.no,
      onMainButtonPressed: () async {
        await manageAccountsCubit.changeMuteMode(item);
      },
    );
  }
}
