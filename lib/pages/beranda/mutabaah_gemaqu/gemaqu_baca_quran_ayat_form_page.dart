import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/gemaqu_baca_quran_save_response.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../api/api_service.dart';
import '../../../api/endpoints.dart';
import '../../../models/gemaqu_baca_quran_response.dart';
import '../../../models/surah_response.dart';

class GemaQuBacaQuranAyatFormPage extends StatefulWidget {
  final DateTime selectedDay;

  const GemaQuBacaQuranAyatFormPage({required this.selectedDay, super.key});

  @override
  State<GemaQuBacaQuranAyatFormPage> createState() => _GemaQuBacaQuranAyatFormPageState();
}

class _GemaQuBacaQuranAyatFormPageState extends State<GemaQuBacaQuranAyatFormPage> {
  late Future<GemaQuBacaQuranAyatData> _future;
  final _formKey = GlobalKey<FormState>();
  final _searchControllerMulai = TextEditingController();
  final _searchControllerSelesai = TextEditingController();
  final _ayatMulaiController = TextEditingController();
  final _ayatSelesaiController = TextEditingController();
  String? _selectedSurahMulai;
  String? _selectedSurahSelesai;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  @override
  void dispose() {
    _searchControllerMulai.dispose();
    _searchControllerSelesai.dispose();
    _ayatMulaiController.dispose();
    _ayatSelesaiController.dispose();
    super.dispose();
  }

  Future<GemaQuBacaQuranAyatData> fetchData() async {
    final token = await AuthHelper.getActiveToken();
    final tanggal = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final surahList = await api.request<SurahResponse>(
      Endpoints.surah,
      RequestType.GET,
      token: token,
      fromJson: (json) => SurahResponse.fromJson(json),
    );

    final gemaQuBacaQuran = await api.request<GemaQuBacaQuranResponse>(
      Endpoints.mutabaahGemaQuBacaQuran(tanggal),
      RequestType.GET,
      token: token,
      fromJson: (json) => GemaQuBacaQuranResponse.fromJson(json)
    );

    return GemaQuBacaQuranAyatData(gemaQuBacaQuran, surahList);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final surahMulai = int.parse(_selectedSurahMulai!);
      final surahSelesai = int.parse(_selectedSurahSelesai!);
      final ayatMulai = int.parse(_ayatMulaiController.text);
      final ayatSelesai = int.parse(_ayatSelesaiController.text);
      final tanggal = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

      debugPrint('Ayat Mulai: $ayatMulai');
      debugPrint('Ayat Selesai: $ayatSelesai');

      try {
        await api.request<GemaQuBacaQuranSaveResponse>(
          Endpoints.mutabaahGemaQuBacaQuranSave,
          RequestType.POST,
          token: await AuthHelper.getActiveToken(),
          body: {
            'tanggal': tanggal,
            'surah_id_mulai': surahMulai,
            'ayat_mulai': ayatMulai,
            'surah_id_selesai': surahSelesai,
            'ayat_selesai': ayatSelesai,
          },
          fromJson: (json) => GemaQuBacaQuranSaveResponse.fromJson(json),
        );

        if (!mounted) return;
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MutabaahGemaQuPage()),
        );*/
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
        centerTitle: true,
        title: Text('Baca Al Quran'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Gagal memuat data jilid Al Karim'));
          }

          final surahList = snapshot.data?.surahList.data;
          final details = snapshot.data?.gemaQuBacaQuran.data;

          if (surahList == null || surahList.isEmpty) {
            return const Center(child: Text('Tidak ada data surah'));
          }

          if (details != null && details.status && _selectedSurahMulai == null && _selectedSurahSelesai == null) {
            _selectedSurahMulai = details.surahIdMulai.toString();
            _selectedSurahSelesai = details.surahIdSelesai.toString();
            _ayatMulaiController.text = details.ayatMulai.toString();
            _ayatSelesaiController.text = details.ayatSelesai.toString();
          }

          return SingleChildScrollView(
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
                            labelText: 'Pilih Surah Mulai',
                          ),
                          value: _selectedSurahMulai,
                          items: surahList.map((item) {
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
                                  surahList.firstWhere((item) => item.id.toString() == _selectedSurahMulai).nama,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                            ],
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _searchControllerMulai,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _searchControllerMulai,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    hintText: 'Cari surah',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (dropdownItem, searchValue) {
                              final text = (dropdownItem.child as Text).data ?? '';
                              return text.toLowerCase().contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) _searchControllerMulai.clear();
                          },
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 240,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
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
                          decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                            labelText: 'Pilih Surah Selesai',
                          ),
                          value: _selectedSurahSelesai,
                          items: surahList.map((item) {
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
                                  surahList.firstWhere((item) => item.id.toString() == _selectedSurahSelesai).nama,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
                            ],
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _searchControllerSelesai,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _searchControllerSelesai,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    hintText: 'Cari surah',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (dropdownItem, searchValue) {
                              final text = (dropdownItem.child as Text).data ?? '';
                              return text.toLowerCase().contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) _searchControllerSelesai.clear();
                          },
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 240,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
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
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _submitForm();

                              ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Data berhasil disimpan'));

                              Navigator.pop<DateTime>(context);
                            }
                          },

                          child: const Text('Simpan'),
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
          );
        }
      )
    );
  }
}

class GemaQuBacaQuranAyatData {
  final GemaQuBacaQuranResponse gemaQuBacaQuran;
  final SurahResponse surahList;

  GemaQuBacaQuranAyatData(this.gemaQuBacaQuran, this.surahList);
}