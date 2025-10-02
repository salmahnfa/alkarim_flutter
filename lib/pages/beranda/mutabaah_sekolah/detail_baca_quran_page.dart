import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../detail_mutabaah_list.dart';
import '../../../models/mutabaah_sekolah_detail_response.dart';

class DetailBacaAlquranPage extends StatefulWidget {
  final int id;

  const DetailBacaAlquranPage({required this.id, super.key});

  @override
  State<DetailBacaAlquranPage> createState() => _DetailBacaAlquranPageState();
}

class _DetailBacaAlquranPageState extends State<DetailBacaAlquranPage> {
  late Future<SekolahMutabaahDetailResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<SekolahMutabaahDetailResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SekolahMutabaahDetailResponse>(
      Endpoints.mutabaahSekolahBacaQuranDetail(widget.id),
      RequestType.GET,
      token: token,
      fromJson: (json) => SekolahMutabaahDetailResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mutabaah Baca Al Quran'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<SekolahMutabaahDetailResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat profil siswa'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data siswa'));
          }

          final items = snapshot.data!.data;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = fetchData();
              });
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return DetailMutabaahList(data: item);
              },
            )
          );
        },
      ),
    );
  }
}