import 'package:alkarim/api/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alkarim/app_colors.dart';
import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/models/ganti_password_response.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:alkarim/auth_helper.dart';

class GantiPasswordPage extends StatefulWidget {
  @override
  State<GantiPasswordPage> createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      debugPrint('Password Baru: ${_newPasswordController.text}');
      debugPrint('Konfirmasi Password: ${_confirmPasswordController.text}');

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        if (token == null || token.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Sesi login sudah habis, silakan login kembali.'));
            await AuthHelper.redirectIfLoggedOut(context);
          }
          return;
        }

        final res = await api.request<GantiPasswordResponse>(
          Endpoints.gantiPassword,
          RequestType.POST,
          token: token,
          body: {
            'password': _newPasswordController.text,
            'password_confirmation': _confirmPasswordController.text,
          },
          fromJson: (json) => GantiPasswordResponse.fromJson(json),
        );

        await AuthHelper.logout();

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      } catch (e) {
        debugPrint('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Gagal mengubah password'));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Ganti Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )
              ),
              SizedBox(height: 8),
              Text(
                "Masukkan password baru dan konfirmasi untuk memperbarui akun.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                          prefixIcon: Icon(Icons.lock_rounded, size: 24, color: AppColors.tertiary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                              size: 24,
                              color: AppColors.tertiary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordObscure = !_isPasswordObscure;
                              });
                            },
                          ),
                          labelText: 'Password Baru',
                        ),
                        obscureText: _isPasswordObscure,
                        validator: (value) =>
                        (value == null || value.length < 8) ? 'Password harus lebih dari 8 karakter' : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                          prefixIcon: Icon(Icons.lock_rounded, size: 24, color: AppColors.tertiary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordObscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                              size: 24,
                              color: AppColors.tertiary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                              });
                            },
                          ),
                          labelText: 'Konfirmasi Password Baru',
                        ),
                        obscureText: _isConfirmPasswordObscure,
                        validator: (value) =>
                        (value == null || value.length < 8) ? 'Password harus lebih dari 8 karakter' : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Ganti Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}

SnackBar selfSnackbar(String msg) {
  return SnackBar(content: Text(msg));
}