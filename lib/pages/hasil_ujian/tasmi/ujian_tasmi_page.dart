import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/jilid_list.dart';
import 'package:alkarim/models/ujian_tasmi_response.dart';
import 'package:alkarim/pages/hasil_ujian/tasmi/ujian_tasmi_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/api/api_service.dart';

class UjianTasmiPage extends StatefulWidget {
  @override
  State<UjianTasmiPage> createState() => _UjianTasmiPageState();
}

class _UjianTasmiPageState extends State<UjianTasmiPage> {
  late Future<UjianTasmiResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<UjianTasmiResponse> fetchData() async {
    final token = AuthHelper.getToken();
    final res = await api.request<UjianTasmiResponse>(
      Endpoints.ujianTasmi,
      RequestType.GET,
      token: token,
      fromJson: (json) => UjianTasmiResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ujian Tasmi'),
        ),
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
                return Center(child: Text('Gagal memuat profil siswa'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Tidak ada data siswa'));
              }

              final items = snapshot.data?.data.data;
              print('Jumlah ujian: ${items?.length}');

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
                      return JilidList(
                          title: item.tanggalUjian,
                          description: item.juz,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => UjianTasmiDetailPage(item: item)),
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