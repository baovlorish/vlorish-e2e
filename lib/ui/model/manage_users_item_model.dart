class ManageUsersItemModel {
  final int? accessType;
  final String? note;
  final String? targetUserIconUrl;
  final int role;
  final int sharingApplicationType;
  final String? targetUserFirstName;
  final String? targetUserLastName;
  final String id;
  final int? requestedAccessType;
  final bool isAccessTypeChangingRequested;
  final String email;
  final String userId;
  final int status;
  final bool isInvitation;

  ManageUsersItemModel(
      {required this.accessType,
      this.note,
      required this.targetUserIconUrl,
      required this.role,
      required this.userId,
      required this.sharingApplicationType,
      required this.targetUserFirstName,
      required this.targetUserLastName,
      required this.id,
      required this.requestedAccessType,
      required this.isAccessTypeChangingRequested,
      required this.email,
      required this.status,
      required this.isInvitation});

  factory ManageUsersItemModel.fromJson(Map<String, dynamic> json,
          {required bool isInvitation}) =>
      ManageUsersItemModel(
        accessType: json['accessType'],
        note: json['note'],
        targetUserIconUrl: json['targetUserIconUrl'],
        role: json['role'],
        sharingApplicationType: json['sharingApplicationType'],
        targetUserFirstName: json['targetUserFirstName'],
        targetUserLastName: json['targetUserLastName'],
        id: json['id'],
        requestedAccessType: json['requestedAccessType'],
        isAccessTypeChangingRequested: json['isAccessTypeChangingRequested'],
        email: json['email'],
        status: json['status'],
        isInvitation: isInvitation,
        userId: json['targetUserId'] ?? '',
      );

  ManageUsersItemModel copyWith({
    int? accessType,
    String? note,
    String? targetUserIconUrl,
    int? role,
    int? sharingApplicationType,
    String? targetUserFirstName,
    String? targetUserLastName,
    String? id,
    int? requestedAccessType,
    bool? isAccessTypeChangingRequested,
    String? email,
    int? status,
    bool? isInvitation,
  }) {
    var newAccessType = role == 2 ? null : accessType ?? this.accessType;
    return ManageUsersItemModel(
        accessType: newAccessType,
        note: note ?? this.note,
        targetUserIconUrl: targetUserIconUrl ?? this.targetUserIconUrl,
        role: role ?? this.role,
        sharingApplicationType:
            sharingApplicationType ?? this.sharingApplicationType,
        targetUserFirstName: targetUserFirstName ?? this.targetUserFirstName,
        targetUserLastName: targetUserLastName ?? this.targetUserLastName,
        requestedAccessType: requestedAccessType ?? this.requestedAccessType,
        isAccessTypeChangingRequested:
            isAccessTypeChangingRequested ?? this.isAccessTypeChangingRequested,
        email: email ?? this.email,
        status: status ?? this.status,
        isInvitation: isInvitation ?? this.isInvitation,
        id: id ?? this.id, userId: userId);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['accessType'] = accessType;
    data['note'] = note;
    data['targetUserIconUrl'] = targetUserIconUrl;
    data['role'] = role;
    data['sharingApplicationType'] = sharingApplicationType;
    data['targetUserFirstName'] = targetUserFirstName;
    data['targetUserLastName'] = targetUserLastName;
    data['id'] = id;
    data['requestedAccessType'] = requestedAccessType;
    data['isAccessTypeChangingRequested'] = isAccessTypeChangingRequested;
    data['email'] = email;
    data['status'] = status;
    return data;
  }

  @override
  String toString() => '''
  {accessType:$accessType,
    note: $note,
    targetUserIconUrl: $targetUserIconUrl,
    role: $role,
    sharingApplicationType: $sharingApplicationType,
    targetUserFirstName: $targetUserFirstName,
    targetUserLastName: $targetUserLastName,
    id: $id,
    requestedAccessType: $requestedAccessType,
    isAccessTypeChangingRequested: $isAccessTypeChangingRequested,
    email: $email,
    status: $status}
    \n''';
}
