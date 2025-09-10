import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/item_list.dart';
import 'package:alkarim/models/ujian_tahfidz_response.dart';
import 'package:alkarim/pages/hasil_ujian/tahfidz/ujian_tahfidz_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/api/api_service.dart';

class UjianTahfidzPage extends StatefulWidget {
  @override
  State<UjianTahfidzPage> createState() => _UjianTahfidzPageState();
}

class _UjianTahfidzPageState extends State<UjianTahfidzPage> {
  late Future<UjianTahfidzResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<UjianTahfidzResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<UjianTahfidzResponse>(
      Endpoints.ujianTahfidz,
      RequestType.GET,
      token: token,
      fromJson: (json) => UjianTahfidzResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ujian Tahfidz'),
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

              final items = snapshot.data?.data.juzs;
              print('Jumlah Jilid: ${items?.length}');

              if (items == null || items.isEmpty) {
                return const Center(child: Text('Data tidak tersedia'));
              }

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
                      return ItemList(
                          title: '${item.title}',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => UjianTahfidzDetailPage(item: item)),
                            );
                          }
                      );
                    }
                ),
              );
            }
        )
    );
  }
}