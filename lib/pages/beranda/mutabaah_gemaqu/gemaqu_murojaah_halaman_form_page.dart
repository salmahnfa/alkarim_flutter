import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/gemaqu_murojaah_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GemaQuMurojaahHalamanFormPage extends StatefulWidget {
  final DateTime selectedDay;

  const GemaQuMurojaahHalamanFormPage({required this.selectedDay, super.key});

  @override
  State<GemaQuMurojaahHalamanFormPage> createState() => _GemaQuMurojaahHalamanFormPageState();
}

class _GemaQuMurojaahHalamanFormPageState extends State<GemaQuMurojaahHalamanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _halamanMulaiController = TextEditingController();
  final _halamanSelesaiController = TextEditingController();

  @override
  void dispose() {
    _halamanMulaiController.dispose();
    _halamanSelesaiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final halamanMulai = int.parse(_halamanMulaiController.text);
      final halamanSelesai = int.parse(_halamanSelesaiController.text);
      final tanggal = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

      debugPrint('Halaman Mulai: $halamanMulai');
      debugPrint('Halaman Selesai: $halamanSelesai');

      if (halamanMulai > halamanSelesai) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Halaman mulai harus lebih kecil dari halaman selesai'))
        );
        return;
      } else {
        try {
          await api.request<GemaQuMurojaahResponse>(
            Endpoints.mutabaahGemaQuMurojaah,
            RequestType.POST,
            token: await AuthHelper.getActiveToken(),
            body: {
              'tanggal': tanggal,
              'halaman_mulai': halamanMulai,
              'halaman_selesai': halamanSelesai,
            },
            fromJson: (json) => GemaQuMurojaahResponse.fromJson(json),
          );

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MutabaahGemaQuPage()),
          );
        } catch (e) {
          debugPrint('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Data gagal disimpan'));
        }
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
            children: [
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
                      controller: _halamanMulaiController,
                      decoration: InputDecoration(
                        isDense: true,
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                        labelText: 'Halaman Mulai',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Halaman mulai tidak boleh kosong';
                        }

                        final number = int.tryParse(value);
                        if (number == null) {
                          return 'Masukkan angka yang valid';
                        }

                        if (number < 1) {
                          return 'Masukkan angka yang valid';
                        }

                        return null;
                      }
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _halamanSelesaiController,
                      decoration: InputDecoration(
                        isDense: true,
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                        labelText: 'Halaman Selesai',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Halaman selesai tidak boleh kosong';
                        }

                        final number = int.tryParse(value);
                        if (number == null) {
                          return 'Masukkan angka yang valid';
                        }

                        if (number < 1) {
                          return 'Masukkan angka yang valid';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Simpan'),
                    )
                  ],
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}