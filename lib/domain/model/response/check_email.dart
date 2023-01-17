class CheckEmailResponse {
  CheckEmailResponse({required this.role, required this.isRegistered});
  bool isRegistered;
  int role;

  factory CheckEmailResponse.fromJson(Map<String, dynamic> json) =>
      CheckEmailResponse(
          role: json['role'], isRegistered: json['isRegistered']);
}
