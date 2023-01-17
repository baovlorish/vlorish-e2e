class ClientMenuItemModel {
  final String userId;
  final String email;
  final int accessType;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  const ClientMenuItemModel(
      {required this.userId,
      required this.email,
      required this.accessType,
      required this.firstName,
      required this.lastName,
      required this.imageUrl});

  factory ClientMenuItemModel.fromJson(Map<String, dynamic> map) {
    return ClientMenuItemModel(
      userId: map['userId'] as String,
      email: map['email'] as String,
      accessType: map['accessType'] as int,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  @override
  String toString() {
    return 'userId: $userId, email:$email, accessType:$accessType, firstName: $firstName, lastName: $lastName, imageUrl: $imageUrl\n';
  }
}
