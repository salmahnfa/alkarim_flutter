import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/buku_alkarim_jilid_response.dart';
import 'package:alkarim/models/gemaqu_baca_jilid_save_response.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/gemaqu_baca_jilid_reponse.dart';
import '../../../utils/validators.dart';

class GemaQuBacaJilidFormPage extends StatefulWidget {
  final bool isNotEmpty;
  final DateTime selectedDay;

  const GemaQuBacaJilidFormPage({required this.isNotEmpty, required this.selectedDay, super.key});

  @override
  State<GemaQuBacaJilidFormPage> createState() => _GemaQuBacaJilidPageState();
}

class _GemaQuBacaJilidPageState extends State<GemaQuBacaJilidFormPage> {
  late Future<GemaQuBacaJilidData> _future;
  final _formKey = GlobalKey<FormState>();
  final _halamanMulaiController = TextEditingController();
  final _halamanSelesaiController = TextEditingController();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _future = fetchData().then((resp) {
      final details = resp.gemaQuBacaJilid.data;
      if (details.status) {
        _selectedValue = details.bukuAlKarimId.toString();
        _halamanMulaiController.text = details.halamanMulai.toString();
        _halamanSelesaiController.text = details.halamanSelesai.toString();
      }

      return resp;
    });
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
          await api.request<GemaQuBacaJilidSaveResponse>(
            Endpoints.mutabaahGemaQuBacaJilidSave,
            RequestType.POST,
            token: await AuthHelper.getActiveToken(),
            body: {
              'tanggal': tanggal,
              'buku_alkarim_id': _selectedValue,
              'halaman_mulai': halamanMulai,
              'halaman_selesai': halamanSelesai,
            },
            fromJson: (json) => GemaQuBacaJilidSaveResponse.fromJson(json),
          );

          if (!mounted) return;
          //Navigator.pop(context, tanggal);
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
  }

  Future<GemaQuBacaJilidData> fetchData() async {
    final token = await AuthHelper.getActiveToken();
    final tanggal = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    final jilidList = await api.request<BukuAlKarimJilidResponse>(
      Endpoints.bukuAlKarimJilid,
      RequestType.GET,
      token: token,
      fromJson: (json) => BukuAlKarimJilidResponse.fromJson(json),
    );

    final gemaQuBacaJilid = await api.request<GemaQuBacaJilidResponse>(
      Endpoints.mutabaahGemaQuBacaJilid(tanggal),
      RequestType.GET,
      token: token,
      fromJson: (json) => GemaQuBacaJilidResponse.fromJson(json),
    );

    return GemaQuBacaJilidData(gemaQuBacaJilid, jilidList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Baca Jilid'),
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

          final items = snapshot.data?.jilidList.data;

          if (items == null || items.isEmpty) {
            return const Center(child: Text('Tidak ada data jilid Al Karim'));
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
                          isExpanded: true,
                          decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.tertiary, width: 2)),
                            labelText: 'Pilih Jilid',
                          ),
                          value: _selectedValue,
                          items: items.map((item) {
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
                          validator: (value) =>
                          value == null || value.isEmpty
                            ? 'Pilih jilid terlebih dahulu'
                            : null,
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.zero,
                          ),
                          customButton: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _selectedValue == null
                                    ? const SizedBox()
                                    : Text(
                                  items.firstWhere((item) => item.id.toString() == _selectedValue).nama,
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
                        const SizedBox(height: 16),
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
                          validator: (v) => Validators.requiredNumber(v,
                              fieldName: 'Halaman Mulai', min: 1),
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
                          validator: (v) => Validators.requiredNumber(v,
                            fieldName: 'Halaman selesai',
                            min: int.tryParse(_halamanMulaiController.text) ?? 1),
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

                              Navigator.pop<DateTime>(context, widget.selectedDay);
                            }
                          },
                          child: const Text('Simpan'),
                        )
                      ],
                    ),
                  )
                ]
              ),
            ),
          );
        }
      ),
    );
  }
}

class GemaQuBacaJilidData {
  final GemaQuBacaJilidResponse gemaQuBacaJilid;
  final BukuAlKarimJilidResponse jilidList;
  GemaQuBacaJilidData(this.gemaQuBacaJilid, this.jilidList);
}