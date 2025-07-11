import 'package:alkarim/api/endpoints.dart';
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
    final token = AuthHelper.getToken();
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
      ),
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Nama \n${data.nama}'),
                SizedBox(height: 8),
                Text('Email \n${data.email}'),
                SizedBox(height: 8),
                Text('NIS \n${data.nis}'),
                SizedBox(height: 8),
                Text('Unit \n${data.unit}'),
                SizedBox(height: 8),
                Text('Kelas \n${data.kelas}'),
                SizedBox(height: 8),
                Text('Guru Quran \n${data.guruQuran}'),
              ],
            ),
          );
        },
      ),
    );
  }
}