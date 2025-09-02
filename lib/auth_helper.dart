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
    final siswaId = await getActiveSiswaId();
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
    final activeId = await getActiveSiswaId();
    if (activeId != null) {
      await clearToken(activeId);
      await _prefs.remove('activeIdKey');
    }
  }

  static Future<void> deleteAccount(int siswaId) async {
    await clearToken(siswaId);
    await _prefs.remove('user_$siswaId');

    final activeId = await getActiveSiswaId();
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

  /*static Future<void> addToken(String token) async {
    final tokensJson = await _secureStorage.read(key: 'tokensKey');
    List<String> tokens = tokensJson != null ? List<String>.from(List<String>.from(tokensJson.split(','))) : [];

    if (!tokens.contains(token)) {
      tokens.add(token);
      await _secureStorage.write(key: _tokensKey, value: tokens.join(','));
    }

    await _secureStorage.write(key: 'active_token', value: token);
  }

  static Future<List<String>> getTokens() async {
    final tokensJson = await _secureStorage.read(key: _tokensKey);
    if (tokensJson == null || tokensJson.isEmpty) return [];
    return tokensJson.split(',');
  }

  static Future<void> setActiveToken(String token) async {
    await _secureStorage.write(key: 'active_token', value: token);
  }

  static Future<String?> getActiveToken() async {
    return await _secureStorage.read(key: 'active_token');
  }

  static Future<void> removeToken(String token) async {
    final tokens = await getTokens();
    tokens.remove(token);

    await _secureStorage.write(key: _tokensKey, value: tokens.join(','));

    final activeToken = await getActiveToken();
    if (activeToken == token) {
      await _secureStorage.delete(key: 'active_token');
      if (tokens.isNotEmpty) {
        await setActiveToken(tokens.first);
      }
    }

    await _prefs.remove('${token}_siswaId');
    await _prefs.remove('${token}_nama');
    await _prefs.remove('${token}_email');
    await _prefs.remove('${token}_program');
    await _prefs.remove('${token}_isAsrama');
  }

  /*static Future<void> removeToken() async {
    await _secureStorage.delete(key: 'token');
  }*/

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> redirectIfLoggedOut(BuildContext context) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    }
  }

  static Future<void> saveLoginData(LoginResponse res) async {
    final data = res.data;
    final token = data.token;
    final siswa = data.siswa;
    
    await saveToken(token);
    
    await _prefs.setInt('${token}_siswaId', siswa.siswaId);
    await _prefs.setString('${token}_nama', siswa.nama);
    await _prefs.setString('${token}_email', siswa.email);
    await _prefs.setString('${token}_program', siswa.program);
    await _prefs.setBool('${token}_isAsrama', siswa.isAsrama);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  static Future<int?> getSiswaId() async {
    final token = await getToken();
    return token != null ? _prefs.getInt('${token}_siswaId') : null;
  }

  static Future<String?> getNamaSiswa() async {
    final token = await getToken();
    return token != null ? _prefs.getString('${token}_nama') : null;
  }

  static Future<String?> getEmailSiswa() async {
    final token = await getToken();
    return token != null ? _prefs.getString('${token}_email') : null;
  }

  static Future<String?> getProgram() async {
    final token = await getToken();
    return token != null ? _prefs.getString('${token}_program') : null;
  }

  static Future<bool?> getIsAsrama() async {
    final token = await getToken();
    return token != null ? _prefs.getBool('${token}_program') : null;
  }

  static Future<void> logout() async {
    final token = await getToken();
    //await removeToken();
    if (token != null) {
      await _prefs.remove('${token}_siswaId');
      await _prefs.remove('${token}_nama');
      await _prefs.remove('${token}_email');
      await _prefs.remove('${token}_program');
      await _prefs.remove('${token}_isAsrama');
    }
  }
}*/