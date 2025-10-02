import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/info_row.dart';
import 'package:flutter/material.dart';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/siswa_profil_response.dart';

class LihatProfilPage extends StatefulWidget {
  @override
  State<LihatProfilPage> createState() => _LihatProfilPageState();
}

class _LihatProfilPageState extends State<LihatProfilPage> {
  late Future<SiswaProfilResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<SiswaProfilResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SiswaProfilResponse>(
      Endpoints.profil,
      RequestType.GET,
      token: token,
      fromJson: (json) => SiswaProfilResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Siswa'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<SiswaProfilResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat profil siswa'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data siswa'));
          }

          final data = snapshot.data!.data;

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
                    'Informasi Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
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
                            /*SizedBox(height: 16),*/
                            infoRow('Nama', data.nama),
                            infoRow('Email', data.email, isLast: true),
                          ],
                        ),
                      ),
                      /*Positioned(
                        top: -32,
                        left: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                          child: Text(
                            data.nama[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )*/
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Data Siswa',
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
                        infoRow('NIS', data.nis),
                        infoRow('Unit', data.unit),
                        infoRow('Kelas', data.kelas),
                        infoRow('Guru Quran', data.guruQuran, isLast: !data.isAsrama),
                        if (data.isAsrama) ...[
                          infoRow(data.guruAsramaGender == 'L' ? 'Musyrif' : 'Musyrifah', data.guruQuran, isLast: true),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}