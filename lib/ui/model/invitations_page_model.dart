import 'package:burgundy_budgeting_app/ui/model/manage_users_item_model.dart';
import 'manage_users_page.dart';

class InvitationsPageModel extends ManageUsersPage
    implements _InvitationParameters {
  InvitationsPageModel({
    required this.pageCount,
    required this.pageNumber,
    required this.invitations,
    required this.canInviteCoach,
    required this.canInvitePartner,
    required this.invitationStatus,
  });

  @override
  int pageCount;
  @override
  int pageNumber;
  List<ManageUsersItemModel> invitations;
  @override
  bool canInviteCoach;
  @override
  bool canInvitePartner;
  @override
  int invitationStatus;

  factory InvitationsPageModel.fromJson(
          Map<String, dynamic> json, int pageNumber, int invitationStatus) =>
      InvitationsPageModel(
        pageCount: json['pageCount'],
        pageNumber: pageNumber,
        invitations: [
          for (var item in json['invitations']) ManageUsersItemModel.fromJson(item, isInvitation: true)
        ],
        canInviteCoach: json['canInviteCoach'] ?? false,
        canInvitePartner: json['canInvitePartner'] ?? false,
        invitationStatus: invitationStatus,
      );

  @override
  String toString() => '''\n
  -----InvitesPageModel-----
  {pageCount: $pageCount,
  pageNumber: $pageNumber,
  invitations: ${invitations.toString()} 
  canInviteCoach: $canInviteCoach,
  canInvitePartner: $canInvitePartner
  }\n''';

  @override
  List<ManageUsersItemModel> get items => invitations;

}

abstract class _InvitationParameters {
  abstract bool canInviteCoach;
  abstract bool canInvitePartner;
  abstract int invitationStatus;
}

