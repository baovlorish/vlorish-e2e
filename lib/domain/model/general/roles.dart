enum _UserRoleType { none, primary, partner, coach }

class UserRole {
  UserRole(this._role);

  _UserRoleType _role;

  int get mappedValue {
    switch (_role) {
      case _UserRoleType.none:
        return 0;
      case _UserRoleType.primary:
        return 1;
      case _UserRoleType.partner:
        return 2;
      case _UserRoleType.coach:
        return 3;
    }
  }

  bool get isPrimary => _role == _UserRoleType.primary;

  bool get isPartner => _role == _UserRoleType.partner;

  bool get isCoach => _role == _UserRoleType.coach;

  static UserRole fromMapped(int value) {
    assert(value < _UserRoleType.values.length,
        'Incorrect value for _UserRoleType');
    return UserRole(_UserRoleType.values[value]);
  }

  factory UserRole.primary() {
    return UserRole(_UserRoleType.primary);
  }

  factory UserRole.partner() {
    return UserRole(_UserRoleType.partner);
  }

  factory UserRole.coach() {
    return UserRole(_UserRoleType.coach);
  }

  factory UserRole.none() {
    return UserRole(_UserRoleType.none);
  }

  @override
  String toString() => _role.toString();
}
