import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/juz_response.dart';
import 'package:flutter/material.dart';

class GemaQuTahfidzAyatFormPage extends StatefulWidget {
  final DateTime selectedDay;

  const GemaQuTahfidzAyatFormPage({required this.selectedDay, super.key});

  @override
  State<GemaQuTahfidzAyatFormPage> createState() => _GemaQuTahfidzAyatFormPageState();
}

class _GemaQuTahfidzAyatFormPageState extends State<GemaQuTahfidzAyatFormPage> {
  late Future<JuzResponse> _future;
  final _formKey = GlobalKey<FormState>();
  final _ayatMulaiController = TextEditingController();
  final _ayatSelesaiController = TextEditingController();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  @override
  void dispose() {
    _ayatMulaiController.dispose();
    _ayatSelesaiController.dispose();
    super.dispose();
  }

  Future<JuzResponse> fetchData() async {
    final token = AuthHelper.getToken();
    final res = await api.request<JuzResponse>(
      Endpoints.bukuAlKarimJilid,
      RequestType.GET,
      token: token,
      fromJson: (json) => JuzResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Ayat Tahfidz'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
              children: [
                FutureBuilder<JuzResponse>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Gagal memuat data jilid Al Karim'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('Tidak ada data jilid Al Karim'));
                    }

                    final items = snapshot.data?.data;
                    print('Jumlah Juz: ${items?.length}');

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Jilid',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedValue,
                      items: items!.map((item) {
                        return DropdownMenuItem<String>(
                          value: item.juz,
                          child: Text(item.juz),
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
                    controller: _ayatMulaiController,
                    decoration: const InputDecoration(
                      labelText: 'Ayat Mulai',
                      hintText: '0',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ayat mulai tidak boleh kosong';
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
                  controller: _ayatSelesaiController,
                  decoration: const InputDecoration(
                    labelText: 'Ayat Selesai',
                    hintText: '0',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ayat selesai tidak boleh kosong';
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
                  onPressed: null,
                  child: const Text('Simpan'),
                )
              ]
          ),
        ),
      ),
    );
  }
}