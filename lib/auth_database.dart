import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDatabase {
  AuthDatabase._();

  static final AuthDatabase instance = AuthDatabase._();

  static const String _usersKey = 'users_auth_v1';

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<Map<String, String>> _readUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);

    if (raw == null || raw.isEmpty) {
      return <String, String>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return <String, String>{};
    }

    return decoded.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  Future<void> _writeUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<bool> registerUser({
    required String username,
    required String password,
  }) async {
    final cleanUser = username.trim().toLowerCase();
    final users = await _readUsers();

    if (users.containsKey(cleanUser)) {
      return false;
    }

    users[cleanUser] = hashPassword(password);
    await _writeUsers(users);

    return true;
  }

  Future<bool> loginUser({
    required String username,
    required String password,
  }) async {
    final cleanUser = username.trim().toLowerCase();
    final users = await _readUsers();
    final storedHash = users[cleanUser];

    if (storedHash == null) {
      return false;
    }

    return storedHash == hashPassword(password);
  }
}
