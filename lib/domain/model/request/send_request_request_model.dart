class RequestSendRequestModel {
  int accessType;
  String? note;
  String email;

  RequestSendRequestModel({required this.accessType,  this.note, required this.email});

  Map<String, dynamic> toJson() {
    final data =  <String, dynamic>{};
    data['accessType'] = accessType;
    data['note'] = note;
    data['email'] = email;
    return data;
  }
}