import 'package:burgundy_budgeting_app/domain/model/request/edit_approved_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/edit_pending_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/invitations_page_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/note_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/send_invitation_request_model.dart';
import 'package:dio/dio.dart';

abstract class ApiInviteService {
  Future<Response> fetchInvitationPage(InvitationsPageRequest invites);

  Future<Response> sendInvite(InvitationSendRequestModel request);

  Future<Response> deleteInvitation(String invitationId);

  Future<Response> noteInvitation(NoteInvitationRequest note);

  Future<Response> approveInvitation(String invitationId);

  Future<Response> editPendingInvitation(EditPendingInvitationRequest editPendingInvitationRequest);

  Future<Response> editApprovedInvitation(EditApprovedInvitationRequest editApprovedInvitationRequest);

  Future<Response> acceptAccessTypeChanging(String invitationId);

  Future<Response> declineAccessTypeChanging(String invitationId);
}
