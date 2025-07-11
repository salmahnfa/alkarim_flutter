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

        await AuthHelper.saveLoginData(res);

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
        title: Text('Login Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded, size: 24, color: AppColors.tertiary),
                  labelText: 'Email',
                  hintText: 'Masukkan email',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                ),
                obscureText: _isObscure,
                validator: (value) =>
                  (value == null || value.length < 8) ? 'Password harus lebih dari 8 karakter' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Masuk'),
              )
            ],
          )
        ),
      )
    );
  }
}

SnackBar selfSnackbar(String msg) {
  return SnackBar(content: Text(msg));
}