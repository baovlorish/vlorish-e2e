import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String TOKEN_KEY = 'SESSION';
  static String STATE_KEY = 'STATE';

  static Future<void> _saveString(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> _loadString(String key, String nullValue) async {
    var prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(key);
    if (value == null) {
      return nullValue;
    } else {
      return value;
    }
  }

  static void saveSession(String sessionId) {
    _saveString(TOKEN_KEY, sessionId);
  }

  static Future<String> loadSession() {
    return _loadString(TOKEN_KEY, '');
  }
}
