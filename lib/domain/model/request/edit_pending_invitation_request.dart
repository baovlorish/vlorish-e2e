class EditPendingInvitationRequest {
  EditPendingInvitationRequest(
      {required this.invitationId,
      required this.role,
      this.accessType,
      this.note});

  String invitationId;
  int role;
  int? accessType;
  String? note;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['invitationId'] = invitationId;
    data['role'] = role;
    data['accessType'] = accessType;
    data['note'] = note;
    return data;
  }
}
