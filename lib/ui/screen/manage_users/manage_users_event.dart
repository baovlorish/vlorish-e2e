import 'package:burgundy_budgeting_app/ui/model/manage_users_item_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_state.dart';

abstract class ManageUsersEvent {}

class ManageUsersInitialLoadingEvent extends ManageUsersEvent {
  final int pageNumber = 1;
  final int invitationStatus = 0; //to requests/invitations filtered - NONE
  final int requestsStatus = 0;
}

class FetchInitialManageUsersDataEvent extends ManageUsersEvent {}

class FetchInvitationsPageEvent extends ManageUsersEvent {
  final int pageNumber;
  final int? invitationStatus;
  ManageUsersLoaded? previousLoadedState;

  FetchInvitationsPageEvent(this.pageNumber,
      {this.invitationStatus, this.previousLoadedState});
}

class FetchRequestsPageEvent extends ManageUsersEvent {
  final int pageNumber;
  final int? requestsStatus;
  ManageUsersLoaded? previousLoadedState;
  final bool shouldUpdateUserData;

  FetchRequestsPageEvent(this.pageNumber,
      {this.requestsStatus,
      this.previousLoadedState,
      this.shouldUpdateUserData = false});
}

class SendInviteEvent extends ManageUsersEvent {
  SendInviteEvent(this.accessType, this.email, this.role, {this.note});
  final int? accessType;
  final String email;
  final int role;
  final String? note;
}

class SendRequestEvent extends ManageUsersEvent {
  SendRequestEvent(this.accessType, this.email, {this.note});
  final int accessType;
  final String email;
  final String? note;
}

class DeleteEvent extends ManageUsersEvent {
  DeleteEvent({required this.model});
  final ManageUsersItemModel model;
}

class NoteEvent extends ManageUsersEvent {
  NoteEvent({required this.model});
  final ManageUsersItemModel model;
}

class ApproveEvent extends ManageUsersEvent {
  ApproveEvent({required this.model});
  final ManageUsersItemModel model;
}

class AcceptAccessTypeChangingEvent extends ManageUsersEvent {
  AcceptAccessTypeChangingEvent({
    required this.model,
  });
  final ManageUsersItemModel model;
}

class DeclineAccessTypeChangingEvent extends ManageUsersEvent {
  DeclineAccessTypeChangingEvent({
    required this.model,
  });
  final ManageUsersItemModel model;
}

class EditItemEvent extends ManageUsersEvent {
  EditItemEvent({required this.model, this.note, this.accessType, this.role});
  final ManageUsersItemModel model;
  final int? accessType;
  final String? note;
  final int? role;
}
