import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/checkbox_list.dart';
import 'package:alkarim/models/gemaqu_murojaah_save_response.dart';
import 'package:alkarim/models/surah_perjuz_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GemaQuMurojaahSurahFormPage extends StatefulWidget {
  final DateTime selectedDay;

  const GemaQuMurojaahSurahFormPage({required this.selectedDay, super.key});

  @override
  State<GemaQuMurojaahSurahFormPage> createState() => _GemaQuMurojaahSurahFormPageState();
}

class _GemaQuMurojaahSurahFormPageState extends State<GemaQuMurojaahSurahFormPage> {
  final _formKey = GlobalKey<FormState>();

  late Future<SurahPerjuzResponse> _future;
  String? _selectedJuz;

  List<bool> checkedList = [];
  List<int> selectedSurahIds = [];

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
    _future = fetchData('1');
  }

  Future<SurahPerjuzResponse> fetchData(String juz) async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SurahPerjuzResponse>(
      Endpoints.surahPerjuz(juz),
      RequestType.GET,
      token: token,
      fromJson: (json) => SurahPerjuzResponse.fromJson(json),
    );
    return res;
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
      body: SingleChildScrollView(
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
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedJuz = newValue;

                          if (newValue != null) {
                            final juz = int.tryParse(newValue) ?? 0;
                            if (juz >= 26 && juz <= 30) {
                              _future = fetchData(newValue);
                            }
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
                            if (int.parse(_selectedJuz!) >= 26 && int.parse(_selectedJuz!) <= 30)
                              FutureBuilder<SurahPerjuzResponse>(
                                future: _future,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Gagal memuat buku Al Karim'));
                                  } else if (!snapshot.hasData) {
                                    return Center(child: Text('Tidak ada data buku Al Karim'));
                                  }

                                  final items = snapshot.data!.data;
                                  if (checkedList.length != items.length) {
                                    checkedList = List.filled(items.length, false);
                                  }

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return CheckboxList(
                                        title: item.nama,
                                        isChecked: checkedList[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            checkedList[index] = value!;
                                            if (value) {
                                              selectedSurahIds.add(item.id);
                                            } else {
                                              selectedSurahIds.remove(item.id);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              )
                            else
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
      ),
    );
  }
}