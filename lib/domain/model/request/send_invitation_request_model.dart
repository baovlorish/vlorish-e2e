class InvitationSendRequestModel {
  int? accessType;
  String? note;
  int role;
  String email;

  InvitationSendRequestModel(
      {required this.accessType,
      this.note,
      required this.role,
      required this.email});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['accessType'] = accessType;
    data['note'] = note;
    data['role'] = role;
    data['email'] = email;
    return data;
  }
}
