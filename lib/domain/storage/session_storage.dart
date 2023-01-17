import 'package:burgundy_budgeting_app/domain/service/foreign_session_service.dart';

abstract class SessionStorage {

  Future<SessionStorage> init();

  Future<void> saveSessionDetails(SessionDetails data);

  SessionDetails? getSessionDetails();

  Future<void> deleteSessionDetails();

  Future<void> saveForeignSessionDetails(ForeignSessionParams data);

  ForeignSessionParams? getForeignSessionDetails();

  Future<void> deleteForeignSessionDetails();
}

class SessionDetails {
  final String username;
  final String idToken;
  final String accessToken;
  final String refreshToken;
  final int? clockDrift;

  SessionDetails({
    required this.username,
    required this.idToken,
    required this.accessToken,
    required this.refreshToken,
    required this.clockDrift,
  });

  factory SessionDetails.fromJson(Map<String, dynamic> map) {
    return SessionDetails(
      username: map['username'] as String,
      idToken: map['idToken'] as String,
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      clockDrift: map['clockDrift'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'idToken': idToken,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'clockDrift': clockDrift,
    };
  }
}
