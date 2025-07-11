import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/jilid_list.dart';
import 'package:alkarim/models/ujian_naik_jilid_response.dart';
import 'package:alkarim/pages/hasil_ujian/naik_jilid/ujian_naik_jilid_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/api/api_service.dart';

class UjianNaikJilidPage extends StatefulWidget {
  @override
  State<UjianNaikJilidPage> createState() => _UjianNaikJilidPageState();
}

class _UjianNaikJilidPageState extends State<UjianNaikJilidPage> {
  late Future<UjianNaikJilidResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<UjianNaikJilidResponse> fetchData() async {
    final token = AuthHelper.getToken();
    final res = await api.request<UjianNaikJilidResponse>(
      Endpoints.ujianNaikJilid,
      RequestType.GET,
      token: token,
      fromJson: (json) => UjianNaikJilidResponse.fromJson(json),
    );
    return res;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ujian Naik Jilid'),
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
          print('Jumlah data: ${items?.length}');

          if (items == null || items.isEmpty) {
            return Center(child: Text('Data tidak tersedia'));
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
                  description: item.tahsinLevel.nama,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UjianNaikJilidDetailPage(item: item)),
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