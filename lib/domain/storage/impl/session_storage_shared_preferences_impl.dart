/*
import 'dart:convert';
import 'package:burgundy_budgeting_app/domain/storage/session_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorageSharedPreferencesImpl implements SessionStorage {
  final String sessionDetailsKey = 'sessionDetailsKey';

  late final SharedPreferences _localStorage;

  @override
  Future<SessionStorage> init() async {
    _localStorage = await SharedPreferences.getInstance();
    return this;
  }

  @override
  Future<void> saveSessionDetails(SessionDetails data) async {
    await _localStorage.setString(
        sessionDetailsKey, json.encode(data.toJson()));
  }

  @override
  SessionDetails? getSessionDetails() {
    var response = _localStorage.getString(sessionDetailsKey);
    if (response != null) {
      return SessionDetails.fromJson(json.decode(response));
    }
  }

  @override
  Future<void> deleteSessionDetails() async {
    await _localStorage.remove(sessionDetailsKey);
  }
}
*/
