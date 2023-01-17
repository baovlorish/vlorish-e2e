class CheckInvitationResponseModel{
  final int role;
  final String email;

  CheckInvitationResponseModel({required this.role, required this.email});

  factory CheckInvitationResponseModel.fromJson(Map<String, dynamic> json){
    return CheckInvitationResponseModel(
      role: json['role'], email: json['email'],
    );
  }
}