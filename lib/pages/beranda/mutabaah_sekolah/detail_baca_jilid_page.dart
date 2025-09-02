import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/info_row.dart';
import 'package:alkarim/models/sekolah_baca_jilid_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../detail_mutabaah_list.dart';

class DetailBacaJilidPage extends StatefulWidget {
  final int id;

  const DetailBacaJilidPage({required this.id, super.key});

  @override
  State<DetailBacaJilidPage> createState() => _DetailBacaJilidPageState();
}

class _DetailBacaJilidPageState extends State<DetailBacaJilidPage> {
  late Future<SekolahBacaJilidDetailResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<SekolahBacaJilidDetailResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SekolahBacaJilidDetailResponse>(
      Endpoints.mutabaahSekolahBacaJilidDetail(widget.id),
      RequestType.GET,
      token: token,
      fromJson: (json) => SekolahBacaJilidDetailResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mutabaah Baca Jilid'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<SekolahBacaJilidDetailResponse>(
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
                print(item);
                return DetailMutabaahBacaJilidList(data: item);
              },
            )
          );
        },
      ),
    );
  }
}