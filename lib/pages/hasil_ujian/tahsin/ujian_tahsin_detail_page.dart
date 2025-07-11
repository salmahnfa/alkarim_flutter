import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/ujian_tahsin_detail_response.dart';
import 'package:flutter/material.dart';

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
    final token = AuthHelper.getToken();
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
            return Center(child: Text('Gagal memuat nilai ujian siswa'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data nilai ujian siswa'));
          }

          final item = snapshot.data?.data;

          if (item == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = fetchData();
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tahun Ajaran: ${item.tahunAjaran}'),
                Text('Semester: ${item.semester}'),
                Text('Tipe Ujian: ${item.tipeUjian}'),
                Text('Kelancaran: ${item.kelancaran}'),
                Text('Makhroj: ${item.makhroj}'),
                Text('Tajwid: ${item.tajwid}'),
                Text('Status: ${item.lulus == 1 ? 'Lulus' : 'Tidak Lulus'}'),
                Text('Penguji: ${item.penguji.user.nama}'),
                Text('Catatan: ${item.catatan ?? 'Tidak ada catatan'}')
              ]
            )
          );
        }
      )
    );
  }
}