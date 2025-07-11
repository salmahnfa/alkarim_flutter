import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alkarim/pages/login_page.dart';
import 'package:alkarim/models/login_response.dart';

class AuthHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  static Future<void> removeToken() async {
    await _prefs.remove('token');
  }

  static Future<bool> isLoggedIn() async {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> redirectIfLoggedOut(BuildContext context) async {
    final token = getToken();

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

    await _prefs.setString('token', token);
    await _prefs.setInt('${token}_siswaId', siswa.siswaId);
    await _prefs.setString('${token}_nama', siswa.nama);
    await _prefs.setString('${token}_email', siswa.email);
    await _prefs.setString('${token}_program', siswa.program);
    await _prefs.setBool('${token}_isAsrama', siswa.isAsrama);
  }

  static String? getToken() {
    return _prefs.getString('token');
  }

  static int? getSiswaId() {
    final token = getToken();
    return token != null ? _prefs.getInt('${token}_siswaId') : null;
  }

  static String? getNama() {
    final token = getToken();
    return token != null ? _prefs.getString('${token}_nama') : null;
  }

  static String? getEmail() {
    final token = getToken();
    return token != null ? _prefs.getString('${token}_email') : null;
  }

  static String? getProgram() {
    final token = getToken();
    return token != null ? _prefs.getString('${token}_program') : null;
  }

  static bool? getIsAsrama() {
    final token = getToken();
    return token != null ? _prefs.getBool('${token}_program') : null;
  }

  static Future<void> logout() async {
    final token = getToken();
    await _prefs.remove('token');
    await _prefs.remove('${token}_siswaId');
    await _prefs.remove('${token}_nama');
    await _prefs.remove('${token}_email');
  }
}