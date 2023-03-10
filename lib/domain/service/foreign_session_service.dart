import 'package:burgundy_budgeting_app/domain/storage/session_storage.dart';

abstract class ForeignSessionService {
  ForeignSessionService(SessionStorage storage);

  //todo use endpoints
  Set<String> forbidden = {
    '/user/profile-details',
    '/user/profile-overview',
    '/request/clients-list',
    '/notification/get-last',
    '/notification/get-all',
    '/notification/set-deleted',
    '/notification/set-read',
    '/notification/set-deleted-all',
  };

  void startForeignSession(ForeignSessionParams params);

  void stopForeignSession();

  ForeignSessionParams? currentForeignSession();
}

class ForeignSessionServiceImpl extends ForeignSessionService {
  final SessionStorage _storage;
  ForeignSessionParams? _currentForeignSession;

  ForeignSessionServiceImpl(this._storage) : super(_storage) {
    var initial = _storage.getForeignSessionDetails();
    if (initial != null) {
      _currentForeignSession = initial;
    }
  }

  @override
  void startForeignSession(ForeignSessionParams params) {
    _storage.saveForeignSessionDetails(params);
    _currentForeignSession = params;
  }

  @override
  void stopForeignSession() {
    _storage.deleteForeignSessionDetails();
    _currentForeignSession = null;
  }

  @override
  ForeignSessionParams? currentForeignSession() => _currentForeignSession;
}

enum _ForeignSessionAccessType { none, readOnly, editor }

class ForeignSessionParams {
  ForeignSessionParams({
    required this.id,
    required int accessType,
    this.firstName,
    this.lastName,
  }) : access = ForeignSessionAccess.fromMapped(accessType);

  final String? firstName;
  final String? lastName;
  final ForeignSessionAccess access;
  final String id;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'accessType': access.mappedValue,
      'id': id,
    };
  }

  factory ForeignSessionParams.fromJson(Map<String, dynamic> json) {
    return ForeignSessionParams(
        id: json['id'],
        accessType: json['accessType'] ?? 0,
        firstName: json['firstName'],
        lastName: json['lastName']);
  }
}

class ForeignSessionAccess {
  ForeignSessionAccess(this._type);

  _ForeignSessionAccessType _type;

  int get mappedValue {
    switch (_type) {
      case _ForeignSessionAccessType.none:
        return 0;
      case _ForeignSessionAccessType.readOnly:
        return 1;
      case _ForeignSessionAccessType.editor:
        return 2;
    }
  }

  bool get isReadOnly => _type == _ForeignSessionAccessType.readOnly;

  bool get isEditor => _type == _ForeignSessionAccessType.editor;

  static ForeignSessionAccess fromMapped(int value) {
    assert(value < _ForeignSessionAccessType.values.length,
        'Incorrect value for _ForeignSessionPermissionType');
    return ForeignSessionAccess(_ForeignSessionAccessType.values[value]);
  }

  factory ForeignSessionAccess.readOnly() {
    return ForeignSessionAccess(_ForeignSessionAccessType.readOnly);
  }

  factory ForeignSessionAccess.editor() {
    return ForeignSessionAccess(_ForeignSessionAccessType.editor);
  }

  @override
  String toString() => _type.toString();
}
