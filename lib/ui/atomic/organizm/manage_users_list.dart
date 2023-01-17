import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/page_selector_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/dropdown_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/empty_manage_users_card.dart';
import 'package:burgundy_budgeting_app/ui/model/invitations_page_model.dart';
import 'package:burgundy_budgeting_app/ui/model/manage_users_page.dart';
import 'package:burgundy_budgeting_app/ui/model/requests_page_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_bloc.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'manage_users_list_item.dart';

class ManageUsersList extends StatefulWidget {
  const ManageUsersList(
    this.manageUsersPage,
    this.onSend, {
    required this.filterPosition,
    Key? key,
  }) : super(key: key);

  final ManageUsersPage manageUsersPage;
  final VoidCallback onSend;
  final int filterPosition;

  @override
  _ManageUsersListState createState() => _ManageUsersListState();
}

class _ManageUsersListState extends State<ManageUsersList>
    with ManageUsersFlexFactors {
  late var manageUsersBloc;

  @override
  void initState() {
    manageUsersBloc = BlocProvider.of<ManageUsersBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColorScheme.blockBackground,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: CustomColorScheme.tableBorder,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 22.0,
                    ),
                    child: Label(
                      text: widget.manageUsersPage is InvitationsPageModel
                          ? AppLocalizations.of(context)!.shareMyBudget
                          : AppLocalizations.of(context)!.accessToOthers,
                      type: LabelType.Header,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: DropdownItem<int>(
                        isSmall: true,
                        initialValue: widget.filterPosition,
                        items: [
                          AppLocalizations.of(context)!.all,
                          AppLocalizations.of(context)!.sent,
                          AppLocalizations.of(context)!.received,
                          AppLocalizations.of(context)!.approved,
                        ],
                        itemKeys: [
                          0,
                          1,
                          2,
                          3,
                        ],
                        hintText: AppLocalizations.of(context)!.all,
                        callback: (value) {
                          widget.manageUsersPage is InvitationsPageModel
                              ? manageUsersBloc.add(FetchInvitationsPageEvent(1,
                                  invitationStatus: value))
                              : manageUsersBloc.add(FetchRequestsPageEvent(1,
                                  requestsStatus: value));
                        }),
                  ),
                  Spacer(),
                  ButtonItem(context,
                      text: widget.manageUsersPage is InvitationsPageModel
                          ? AppLocalizations.of(context)!.addAnother
                          : AppLocalizations.of(context)!.requestTheAccess,
                      onPressed: widget.onSend)
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: CustomColorScheme.tableBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: listOfFlexFactors[0],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.useName,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: listOfFlexFactors[1],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.userEmail,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: listOfFlexFactors[2],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.role,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: listOfFlexFactors[3],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.accessType,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: listOfFlexFactors[4],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Label(
                        text: AppLocalizations.of(context)!.note,
                        type: LabelType.TableHeader,
                        color: CustomColorScheme.tableHeaderText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: widget.manageUsersPage.items.isNotEmpty
                    ? BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: CustomColorScheme.tableBorder),
                          right:
                              BorderSide(color: CustomColorScheme.tableBorder),
                          left:
                              BorderSide(color: CustomColorScheme.tableBorder),
                        ),
                      )
                    : null,
                child: widget.manageUsersPage.items.isEmpty
                    ? EmptyManageUsersCardSmall(
                        message: widget.manageUsersPage is InvitationsPageModel
                            ? AppLocalizations.of(context)!.noInvitationsFound
                            : AppLocalizations.of(context)!.noRequestsFound)
                    : ListView.builder(
                        itemCount: widget.manageUsersPage.items.length + 1,
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: CustomColorScheme.tableBorder),
                            ),
                          ),
                          child: index < widget.manageUsersPage.items.length
                              ? widget.manageUsersPage is InvitationsPageModel
                                  ? ManageUsersListItem.fromInvitationModel(
                                      key: Key(widget
                                          .manageUsersPage.items[index].id),
                                      manageUsersItemModel:
                                          widget.manageUsersPage.items[index],
                                      canInviteCoach: (widget.manageUsersPage
                                              as InvitationsPageModel)
                                          .canInviteCoach,
                                      canInvitePartner: (widget.manageUsersPage
                                              as InvitationsPageModel)
                                          .canInvitePartner,
                                      onItemChanged: (item) {
                                        widget.manageUsersPage.items[index] =
                                            item;
                                      },
                                    )
                                  : ManageUsersListItem.fromRequestModel(
                                      key: Key(widget
                                          .manageUsersPage.items[index].id),
                                      manageUsersItemModel:
                                          widget.manageUsersPage.items[index],
                                      hasRequestSlots: (widget.manageUsersPage
                                              as RequestsPageModel)
                                          .hasRequestSlots,
                                      canRequestToday: (widget.manageUsersPage
                                              as RequestsPageModel)
                                          .canRequestToday,
                                      onItemChanged: (item) {
                                        widget.manageUsersPage.items[index] =
                                            item;
                                      },
                                    )
                              : widget.manageUsersPage.pageCount > 1
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (var i = 1;
                                            i <=
                                                widget
                                                    .manageUsersPage.pageCount;
                                            i++)
                                          PageSelectorItem(
                                            number: i,
                                            isSelected: i ==
                                                widget
                                                    .manageUsersPage.pageNumber,
                                            callback: (int value) {
                                              widget.manageUsersPage
                                                      is InvitationsPageModel
                                                  ? manageUsersBloc.add(
                                                      FetchInvitationsPageEvent(
                                                          i))
                                                  : manageUsersBloc.add(
                                                      FetchRequestsPageEvent(i),
                                                    );
                                            },
                                          ),
                                      ],
                                    )
                                  : SizedBox(),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

mixin ManageUsersFlexFactors {
  List<int> get listOfFlexFactors => [35, 35, 10, 15, 60];
}
