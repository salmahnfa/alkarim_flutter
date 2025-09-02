import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/models/login_response.dart';
import 'package:alkarim/pages/beranda/beranda_page.dart';

import 'package:flutter/material.dart';

import 'package:alkarim/app_colors.dart';
import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/auth_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      debugPrint('Email: $email');
      debugPrint('Password: $password');

      try {
        final res = await api.request<LoginResponse>(
          Endpoints.login,
          RequestType.POST,
          body: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
          fromJson: (json) => LoginResponse.fromJson(json),
        );

        final siswa = res.data.siswa;
        final token = res.data.token;

        await AuthHelper.saveToken(res.data.siswa.siswaId, res.data.token);
        await AuthHelper.saveUserData(res.data.siswa.siswaId, res.data.siswa.nama, res.data.siswa.email, res.data.siswa.program, res.data.siswa.isAsrama);

        await AuthHelper.setActiveAccount(siswa.siswaId);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Beranda()),
        );
      } catch (e) {
        debugPrint('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Email atau password salah'));
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Image.asset('assets/images/logo_no_background.png', height: 100),
                    //SizedBox(height: 32),
                    Text(
                        "Selamat datang!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        )
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Silakan masukkan email dan password untuk mengakses aplikasi.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ]
                )
              ),
              SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded, size: 24, color: AppColors.tertiary),
                        labelText: 'Email',
                        hintText: 'Masukkan email',
                        isDense: true,
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                        (value == null || !value.contains('@')) ? 'Email tidak valid' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_rounded, size: 24, color: AppColors.tertiary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                            size: 24,
                            color: AppColors.tertiary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        labelText: 'Password',
                        hintText: 'Masukkan password',
                        isDense: true,
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                      ),
                      obscureText: _isObscure,
                      validator: (value) =>
                      (value == null || value.length < 8) ? 'Password harus lebih dari 8 karakter' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.background,
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}

SnackBar selfSnackbar(String msg) {
  return SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 1),
  );
}