import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/gemaqu_murojaah_response.dart';
import 'package:alkarim/models/surah_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GemaQuMurojaahAyatFormPage extends StatefulWidget {
  final DateTime selectedDay;

  const GemaQuMurojaahAyatFormPage({required this.selectedDay, super.key});

  @override
  State<GemaQuMurojaahAyatFormPage> createState() => _GemaQuMurojaahAyatFormPageState();
}

class _GemaQuMurojaahAyatFormPageState extends State<GemaQuMurojaahAyatFormPage> {
  late Future<SurahResponse> _futureSurahMulai;
  late Future<SurahResponse> _futureSurahSelesai;
  final _formKey = GlobalKey<FormState>();
  final _ayatMulaiController = TextEditingController();
  final _ayatSelesaiController = TextEditingController();
  String? _selectedJuzMulai;
  String? _selectedJuzSelesai;
  String? _selectedSurahMulai;
  String? _selectedSurahSelesai;

  @override
  void initState() {
    super.initState();
    _futureSurahMulai = fetchData('1');
    _futureSurahSelesai = fetchData('1');
  }

  @override
  void dispose() {
    _ayatMulaiController.dispose();
    _ayatSelesaiController.dispose();
    super.dispose();
  }

  Future<SurahResponse> fetchData(String juz) async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SurahResponse>(
      Endpoints.surah(juz),
      RequestType.GET,
      token: token,
      fromJson: (json) => SurahResponse.fromJson(json),
    );
    return res;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final juzMulai = int.parse(_selectedJuzMulai!);
      final surahMulai = int.parse(_selectedSurahMulai!);
      final surahSelesai = int.parse(_selectedSurahSelesai!);
      final ayatMulai = int.parse(_ayatMulaiController.text);
      final ayatSelesai = int.parse(_ayatSelesaiController.text);
      final tanggal = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

      debugPrint('Ayat Mulai: $ayatMulai');
      debugPrint('Ayat Selesai: $ayatSelesai');

      try {
        await api.request<GemaQuMurojaahResponse>(
          Endpoints.mutabaahGemaQuMurojaah,
          RequestType.POST,
          token: await AuthHelper.getActiveToken(),
          body: {
            'tanggal': tanggal,
            'juz': juzMulai,
            'surah_id_mulai': surahMulai,
            'ayat_mulai': ayatMulai,
            'surah_id_selesai': surahSelesai,
            'ayat_selesai': ayatSelesai,
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
                    DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                        isDense: true,
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                        labelText: 'Pilih Juz Mulai',
                      ),
                      value: _selectedJuzMulai,
                      items: List.generate(30, (index) {
                        final value = (index + 1).toString();
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('Juz $value'),
                        );
                      }),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedJuzMulai = newValue;
                          _selectedSurahMulai = null;
                          _futureSurahMulai = fetchData(newValue!);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih juz terlebih dahulu';
                        }
                        return null;
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.zero,
                      ),
                      customButton: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _selectedJuzMulai == null
                                ? const SizedBox()
                                : Text(
                              'Juz $_selectedJuzMulai',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                        ],
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<SurahResponse>(
                      future: _futureSurahMulai,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Gagal memuat data juz'));
                        } else if (!snapshot.hasData) {
                          return Center(child: Text('Tidak ada data juz'));
                        }

                        final items = snapshot.data?.data;
                        print('Jumlah Surah: ${items?.length}');

                        return DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                            labelText: 'Pilih Surah Mulai',
                          ),
                          value: _selectedSurahMulai,
                          items: items!.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.id.toString(),
                              child: Text(item.nama),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSurahMulai = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih surah terlebih dahulu';
                            }
                            return null;
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.zero,
                          ),
                          customButton: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _selectedSurahMulai == null
                                    ? const SizedBox()
                                    : Text(
                                  items.firstWhere((item) => item.id.toString() == _selectedSurahMulai).nama,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                            ],
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 240,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ayatMulaiController,
                      decoration: InputDecoration(
                        isDense: true,
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                        labelText: 'Ayat Mulai',
                        hintText: '0',
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
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        isDense: true,
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                        labelText: 'Pilih Juz Selesai',
                      ),
                      value: _selectedJuzSelesai,
                      items: List.generate(30, (index) {
                        final value = (index + 1).toString();
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('Juz $value'),
                        );
                      }),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedJuzSelesai = newValue;
                          _selectedSurahSelesai = null;
                          _futureSurahSelesai = fetchData(newValue!);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih juz terlebih dahulu';
                        }
                        return null;
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.zero,
                      ),
                      customButton: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _selectedJuzSelesai == null
                                ? const SizedBox()
                                : Text(
                              'Juz $_selectedJuzSelesai',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                        ],
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<SurahResponse>(
                      future: _futureSurahSelesai,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Gagal memuat data juz'));
                        } else if (!snapshot.hasData) {
                          return Center(child: Text('Tidak ada data juz'));
                        }

                        final items = snapshot.data?.data;
                        print('Jumlah Surah: ${items?.length}');

                        return DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                            labelText: 'Pilih Surah Selesai',
                          ),
                          value: _selectedSurahSelesai,
                          items: items!.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.id.toString(),
                              child: Text(item.nama),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSurahSelesai = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih surah terlebih dahulu';
                            }
                            return null;
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.zero,
                          ),
                          customButton: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _selectedSurahSelesai == null
                                    ? const SizedBox()
                                    : Text(
                                  items.firstWhere((item) => item.id.toString() == _selectedSurahSelesai).nama,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                            ],
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 240,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ayatSelesaiController,
                      decoration: InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                      labelText: 'Ayat Selesai',
                      hintText: '0',
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