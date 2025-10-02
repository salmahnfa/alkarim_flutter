import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/pages/beranda/buku_alkarim/buku_alkarim_page.dart';
import 'package:flutter/material.dart';

import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/models/buku_alkarim_jilid_response.dart';

import '../../../jilid_list.dart';

class BukuAlKarimJilidPage extends StatefulWidget {
  @override
  State<BukuAlKarimJilidPage> createState() => _BukuAlKarimJilidPageState();
}

class _BukuAlKarimJilidPageState extends State<BukuAlKarimJilidPage> {
  late Future<BukuAlKarimJilidResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<BukuAlKarimJilidResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

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
        title: Text('Buku Al Karim'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<BukuAlKarimJilidResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat buku Al Karim'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data buku Al Karim'));
          }

          final items = snapshot.data?.data;
          print('Jumlah Jilid: ${items?.length}');

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = fetchData();
              });
            },
            child: ListView.builder(
              itemCount: items?.length,
              itemBuilder: (context, index) {
                final item = items![index];
                return JilidList(
                  title: item.nama,
                  description: item.deskripsi,
                  halaman: item.jumlahHalaman,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BukuAlKarimPage(id: item.id, jilid: item.nama, jumlahHalamanDilewati: item.jumlahHalamanDilewati)),
                    );
                  },
                );
              },
            ),
          );
        },
      )
    );
  }
}