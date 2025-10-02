import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/checkbox_list.dart';
import 'package:alkarim/models/gemaqu_murojaah_save_response.dart';
import 'package:alkarim/models/surah_perjuz_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/gemaqu_murojaah_response.dart';

class GemaQuMurojaahSurahFormPage extends StatefulWidget {
  final DateTime selectedDay;

  const GemaQuMurojaahSurahFormPage({required this.selectedDay, super.key});

  @override
  State<GemaQuMurojaahSurahFormPage> createState() => _GemaQuMurojaahSurahFormPageState();
}

class _GemaQuMurojaahSurahFormPageState extends State<GemaQuMurojaahSurahFormPage> {
  final _formKey = GlobalKey<FormState>();

  late Future<GemaQuMurojaahSurahData> _future;
  String? _selectedJuz;

  List<bool> checkedList = [];
  List<int> selectedSurahIds = [];
  List<String> selectedSurahNames = [];

  int? selectedKeteranganIndex;
  List<String> keteranganJuz = [
    '1/4 juz ke-1',
    '1/4 juz ke-2',
    '1/4 juz ke-3',
    '1/4 juz ke-4',
    '1/2 juz ke-1',
    '1/2 juz ke-2',
    '1 juz'
  ];

  @override
  void initState() {
    super.initState();
    _future = _initFetch();
  }

  Future<GemaQuMurojaahSurahData> _initFetch() async {
    final data = await fetchData(null);

    final details = data.gemaQuMurojaah.data;
    if (details.status) {
      _selectedJuz = details.juz?.toString();
    } else {
      _selectedJuz ??= '1';
    }

    return data;
  }

  Future<GemaQuMurojaahSurahData> fetchData(String? juz) async {
    final token = await AuthHelper.getActiveToken();
    final tanggal = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final gemaQuMurojaah = await api.request<GemaQuMurojaahResponse>(
      Endpoints.mutabaahGemaQuMurojaah(tanggal),
      RequestType.GET,
      token: token,
      fromJson: (json) => GemaQuMurojaahResponse.fromJson(json),
    );

    final juzList = gemaQuMurojaah.data.surahPerJuz;

    if (_selectedJuz == null) {
      if (juzList != null && juzList.isNotEmpty) {
        _selectedJuz = juzList.first.juz.toString();
      } else {
        _selectedJuz = '1';
      }
    }

    final surahList = await api.request<SurahPerjuzResponse>(
      Endpoints.surahPerjuz(_selectedJuz!),
      RequestType.GET,
      token: token,
      fromJson: (json) => SurahPerjuzResponse.fromJson(json),
    );

    return GemaQuMurojaahSurahData(gemaQuMurojaah, surahList);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final tanggal = DateFormat('yyyy-MM-dd').format(widget.selectedDay);
      final juz = int.parse(_selectedJuz!);

      final Map<String, dynamic> body = {
        'tanggal': tanggal,
        'juz': juz,
      };

      if (juz >= 26 && juz <= 30) {
        body['surahs'] = selectedSurahIds;
      } else {
        body['keterangan_juz'] = keteranganJuz[selectedKeteranganIndex!];
      }

      try {
        await api.request<GemaQuMurojaahSaveResponse>(
          Endpoints.mutabaahGemaQuMurojaahSave,
          RequestType.POST,
          token: await AuthHelper.getActiveToken(),
          body: body,
          fromJson: (json) => GemaQuMurojaahSaveResponse.fromJson(json),
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
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Gagal memuat buku Al Karim'));
          } if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data buku Al Karim'));
          }

          final surahList = snapshot.data?.surahList.data ?? [];
          final details = snapshot.data?.gemaQuMurojaah.data;

          if (checkedList.isEmpty || checkedList.length != surahList.length) {
            checkedList = List.generate(surahList.length, (index) {
              final surah = surahList[index];
              return (details?.surahPerJuz ?? [])
                  .expand((spj) => spj.surahs)
                  .any((s) => s.id == surah.id);
            });
          }

          final allSelectedSurahs = (details?.surahPerJuz ?? [])
              .expand((spj) => spj.surahs)
              .toList();

          for (var surah in allSelectedSurahs) {
            if (!selectedSurahIds.contains(surah.id)) {
              selectedSurahIds.add(surah.id);
            }
            if (!selectedSurahNames.contains(surah.nama)) {
              selectedSurahNames.add(surah.nama);
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            labelText: 'Pilih Juz',
                          ),
                          value: _selectedJuz,
                          items: List.generate(30, (index) {
                            final value = (index + 1).toString();
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('Juz $value'),
                            );
                          }),
                          onChanged: (newValue) {
                            if (newValue == null) return;

                            setState(() {
                              final juz = int.tryParse(newValue) ?? 0;

                              if (juz >= 26 && juz <= 30) {
                                _selectedJuz = newValue;
                                _future = fetchData(newValue);
                              } else {
                                selectedKeteranganIndex = null;
                                selectedSurahIds.clear();
                                selectedSurahNames.clear();
                                checkedList.clear();

                                _selectedJuz = newValue;
                              }
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
                                child: _selectedJuz == null
                                    ? const SizedBox()
                                    : Text(
                                  'Juz $_selectedJuz',
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
                                  color: Colors.black12.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      children: [
                        if (_selectedJuz != null) ...[
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
                                if (int.parse(_selectedJuz!) >= 26 && int.parse(_selectedJuz!) <= 30) ...[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: surahList.length,
                                        itemBuilder: (context, index) {
                                          final item = surahList[index];
                                          return CheckboxList(
                                            title: item.nama,
                                            isChecked: checkedList[index],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                checkedList[index] = value ?? false;

                                                if (value == true) {
                                                  if (!selectedSurahIds.contains(surahList[index].id)) {
                                                    selectedSurahIds.add(surahList[index].id);
                                                  }
                                                } else {
                                                  selectedSurahIds.remove(surahList[index].id);
                                                }
                                              });
                                            },
                                          );
                                          },
                                      ),
                                      if (selectedSurahNames.isNotEmpty) ...[
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Surah yang dipilih:",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  for (var i = 0; i < surahList.length; i++)
                                                    if (checkedList[i])
                                                      Chip(
                                                        label: Text(surahList[i].nama),
                                                        onDeleted: () {
                                                          setState(() {
                                                            checkedList[i] = false; // otomatis uncheck checkbox
                                                          });
                                                        },
                                                      )
                                                ],
                                              ),
                                            ]
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ] else ...[
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: keteranganJuz.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxList(
                                        title: keteranganJuz[index],
                                        isChecked: selectedKeteranganIndex == index,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedKeteranganIndex = index;
                                            } else {
                                              selectedKeteranganIndex = null;
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  child: const Text('Simpan'),
                                )
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                ]
              ),
            ),
          );
        }
      ),
    );
  }
}

class GemaQuMurojaahSurahData {
  final GemaQuMurojaahResponse gemaQuMurojaah;
  final SurahPerjuzResponse surahList;

  GemaQuMurojaahSurahData(this.gemaQuMurojaah, this.surahList);
}