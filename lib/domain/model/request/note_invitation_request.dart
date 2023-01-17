class NoteInvitationRequest{
  NoteInvitationRequest({required this.invitationId, this.note});
  String invitationId;
  String? note;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['invitationId'] = invitationId;
    data['note'] = note;
    return data;
  }
}