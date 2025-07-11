import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/buku_alkarim_jilid_response.dart';
import 'package:alkarim/models/gemaqu_baca_jilid_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GemaQuBacaJilidFormPage extends StatefulWidget {
  final DateTime selectedDay;

  const GemaQuBacaJilidFormPage({required this.selectedDay, super.key});

  @override
  State<GemaQuBacaJilidFormPage> createState() => _GemaQuBacaJilidPageState();
}

class _GemaQuBacaJilidPageState extends State<GemaQuBacaJilidFormPage> {
  late Future<BukuAlKarimJilidResponse> _future;
  final _formKey = GlobalKey<FormState>();
  final _halamanMulaiController = TextEditingController();
  final _halamanSelesaiController = TextEditingController();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

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
          await api.request<GemaQuBacaJilidResponse>(
            Endpoints.mutabaahGemaQuBacaJilid,
            RequestType.POST,
            token: AuthHelper.getToken(),
            body: {
              'tanggal': tanggal,
              'buku_alkarim_id': _selectedValue,
              'halaman_mulai': halamanMulai,
              'halaman_selesai': halamanSelesai,
            },
            fromJson: (json) => GemaQuBacaJilidResponse.fromJson(json),
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

  Future<BukuAlKarimJilidResponse> fetchData() async {
    final token = AuthHelper.getToken();
    final res = await api.request<BukuAlKarimJilidResponse>(
      Endpoints.bukuAlKarimJilid,
      RequestType.GET,
      token: token,
      fromJson: (json) => BukuAlKarimJilidResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FutureBuilder<BukuAlKarimJilidResponse>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Gagal memuat data jilid Al Karim'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('Tidak ada data jilid Al Karim'));
                  }

                  final items = snapshot.data?.data;
                  print('Jumlah Jilid: ${items?.length}');

                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                       labelText: 'Pilih Jilid',
                        border: OutlineInputBorder(),
                    ),
                    value: _selectedValue,
                    items: items!.map((item) {
                      return DropdownMenuItem<String>(
                        value: item.id.toString(),
                        child: Text(item.nama),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih jilid terlebih dahulu';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _halamanMulaiController,
                decoration: const InputDecoration(
                  labelText: 'Halaman Mulai',
                  hintText: '0',
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Halaman Selesai',
                  hintText: '0',
                  border: OutlineInputBorder(),
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
            ]
          ),
        ),
      ),
    );
  }
}