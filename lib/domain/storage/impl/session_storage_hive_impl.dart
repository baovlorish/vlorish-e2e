import 'dart:convert';
import 'package:burgundy_budgeting_app/domain/service/foreign_session_service.dart';
import 'package:burgundy_budgeting_app/domain/storage/session_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SessionStorageHiveImpl implements SessionStorage {
  final String _sessionDetailsKey = 'sessionDetailsKey';
  final String _foreignSessionDetailsKey = 'foreignSessionDetailsKey';
  late final Box<dynamic> _box;

  @override
  Future<SessionStorage> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(
      'session_details_box',
    );
    return this;
  }

  @override
  Future<void> saveSessionDetails(SessionDetails data) async {
    await _box.put(_sessionDetailsKey, json.encode(data.toJson()));
  }

  @override
  SessionDetails? getSessionDetails() {
    var response = _box.get(_sessionDetailsKey);
    if (response != null) {
      return SessionDetails.fromJson(json.decode(response));
    }
    return null;
  }

  @override
  Future<void> deleteSessionDetails() async {
    await _box.delete(_sessionDetailsKey);
  }

  @override
  Future<void> saveForeignSessionDetails(ForeignSessionParams data) async {
    await _box.put(_foreignSessionDetailsKey, json.encode(data.toJson()));
  }

  @override
  ForeignSessionParams? getForeignSessionDetails() {
    var response = _box.get(_foreignSessionDetailsKey);
    if (response != null) {
      return ForeignSessionParams.fromJson(json.decode(response));
    }
    return null;
  }

  @override
  Future<void> deleteForeignSessionDetails() async {
    await _box.delete(_foreignSessionDetailsKey);
  }
}
