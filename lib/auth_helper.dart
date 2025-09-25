import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static late SharedPreferences _prefs;

  static const String _tokensKey = 'auth_tokens';
  static const String _activeIdKey = 'active_siswa_id';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(int siswaId, String token) async {
    await _secureStorage.write(key: 'token_$siswaId', value: token);

    if (_prefs.getInt(_activeIdKey) == null) {
      await setActiveAccount(siswaId);
    }
  }

  static Future<String?> getToken(int siswaId) async {
    return await _secureStorage.read(key: 'token_$siswaId');
  }

  static Future<String?> getActiveToken() async {
    final siswaId = getActiveSiswaId();
    if (siswaId == null) return null;

    return await getToken(siswaId);
  }

  static Future<void> clearToken(int siswaId) async {
    await _secureStorage.delete(key: 'token_$siswaId');
  }

  static int? getActiveSiswaId() => _prefs.getInt(_activeIdKey);

  static Map<String, dynamic>? getActiveSiswaData() {
    final siswaId = getActiveSiswaId();
    if (siswaId == null) return null;

    return getUserData(siswaId);
  }

  static Future<void> setActiveAccount(int siswaId) async {
    await _prefs.setInt(_activeIdKey, siswaId);
  }

  static Future<void> saveUserData(int siswaId, String nama, String email, String program, bool isAsrama) async {
    await _prefs.setStringList('user_$siswaId', [
      nama,
      email,
      program,
      isAsrama.toString(),
    ]);
  }

  static Map<String, dynamic>? getUserData(int siswaId) {
    final data = _prefs.getStringList('user_$siswaId');
    if (data == null) return null;

    return {
      'nama': data[0],
      'email': data[1],
      'program': data[2],
      'isAsrama': data[3] == 'true',
    };
  }

  static Future<bool> isLoggedIn() async {
    final siswaId = getActiveSiswaId();
    if (siswaId == null) return false;
    final token = await getToken(siswaId);
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final activeId = getActiveSiswaId();
    if (activeId != null) {
      await clearToken(activeId);
      await _prefs.remove('activeIdKey');
    }
  }

  static Future<void> deleteAccount(int siswaId) async {
    await clearToken(siswaId);
    await _prefs.remove('user_$siswaId');

    final activeId = getActiveSiswaId();
    if (activeId == siswaId) {
      await _prefs.remove('activeIdKey');
    }
  }

  static Future<void> redirectIfLoggedOut(BuildContext context) async {
    if (!await isLoggedIn()) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  static Future<List<Map<String, dynamic>>> getAllAccounts() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('user_')).toList();
    List<Map<String, dynamic>> accounts = [];

    for (var key in keys) {
      final siswaId = int.parse(key.split('_')[1]);
      final data = getUserData(siswaId);
      if (data != null) {
        accounts.add({
          'siswaId': siswaId,
          ...data,
        });
      }
    }

    return accounts;
  }
}