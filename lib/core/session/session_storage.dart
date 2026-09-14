import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/network/session.dart';

// Persists the SalesSession across app restarts. A field sales associate
// shouldn't have to re-enter their PIN every time they open the app —
// only on explicit logout or if the stored session is missing/invalid.
class SessionStorage {
  static const _keyUserId = "session_user_id";
  static const _keyRole = "session_role";
  static const _keyVerified = "session_verified";
  static const _keyToken = "session_token";

  static Future<void> save(SalesSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, session.userId);
    await prefs.setString(_keyRole, session.role);
    await prefs.setBool(_keyVerified, session.verified);
    await prefs.setString(_keyToken, session.token);
  }

  // Loads any persisted session into the GetIt-registered SalesSession
  // singleton. Called once at app startup, before runApp.
  static Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final session = GetIt.I<SalesSession>();
    session.userId = prefs.getString(_keyUserId) ?? "";
    session.role = prefs.getString(_keyRole) ?? "";
    session.verified = prefs.getBool(_keyVerified) ?? false;
    session.token = prefs.getString(_keyToken) ?? "";
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyVerified);
    await prefs.remove(_keyToken);
    GetIt.I<SalesSession>().clear();
  }
}