import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/info_row.dart';
import 'package:alkarim/models/ujian_tahsin_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:alkarim/utils/string_extensions.dart';

class UjianTahsinDetailPage extends StatefulWidget {
  final dynamic id;

  const UjianTahsinDetailPage({required this.id, super.key});

  @override
  State<UjianTahsinDetailPage> createState() => _UjianTahsinDetailPageState();
}

class _UjianTahsinDetailPageState extends State<UjianTahsinDetailPage> {
  late Future<UjianTahsinDetailResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<UjianTahsinDetailResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<UjianTahsinDetailResponse>(
      Endpoints.ujianTahsinDetail(widget.id),
      RequestType.GET,
      token: token,
      fromJson: (json) => UjianTahsinDetailResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Ujian Tahsin'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          print('Connection State: ${snapshot.connectionState}');
          print('Has Data: ${snapshot.hasData}');
          print('Has Error: ${snapshot.hasError}');
          print('Error: ${snapshot.error}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat nilai siswa'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data siswa'));
          }

          final item = snapshot.data?.data;
          print(item!.lulus == 1 ? 'Lulus' : 'Tidak Lulus');

          if (item == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = fetchData();
              });
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Ujian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoRow('Tahun Ajaran', item.tahunAjaran),
                        infoRow('Semester', item.semester.capitalizeWords),
                        infoRow('Jenis Ujian', item.tipeUjian.capitalizeWords),
                        infoRow('Nilai', item.nilai.toString()),
                        infoRow('Status', item.lulus == 1 ? 'Lulus' : 'Tidak Lulus', isHighlighted: true, isLast: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Catatan Penguji',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoRow('Guru Quran', item.guruQuran.user.nama),
                        infoRow('Catatan', item.catatan ?? 'Tidak ada catatan', isLast: true),
                      ],
                    ),
                  ),
                ]
              ),
            )
          );
        }
      )
    );
  }
}