import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/ujian_tahsin_response.dart';
import 'package:alkarim/pages/hasil_ujian/tahsin/ujian_tahsin_detail_page.dart';
import 'package:flutter/material.dart';

class UjianTahsinPage extends StatefulWidget {
  @override
  State<UjianTahsinPage> createState() => _UjianTahsinPageState();
}

class _UjianTahsinPageState extends State<UjianTahsinPage> {
  late Future<UjianTahsinResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<UjianTahsinResponse> fetchData() async {
    final token = AuthHelper.getToken();
    final res = await api.request<UjianTahsinResponse>(
      Endpoints.ujianTahsin,
      RequestType.GET,
      token: token,
      fromJson: (json) => UjianTahsinResponse.fromJson(json),
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
            return Center(child: Text('Gagal memuat profil siswa'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data siswa'));
          }

          final items = snapshot.data?.data;

          if (items == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = fetchData();
              });
            },
            child: Column(
              children: [
                if (items.nilaiPtsGasal != null)
                  ListTile(
                    title: Text('Nilai PTS Gasal'),
                      subtitle: Text('Hasil penilaian tengah semester gasal'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UjianTahsinDetailPage(id: items.nilaiPtsGasal?.id)),
                      );
                    }
                  ),
                if (items.nilaiPasGasal != null)
                  ListTile(
                    title: Text('Nilai PAS Gasal'),
                    subtitle: Text('Hasil penilaian akhir semester gasal'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UjianTahsinDetailPage(id: items.nilaiPasGasal?.id)),
                      );
                    }
                  ),
                if (items.nilaiPtsGenap != null)
                  ListTile(
                      title: Text('Nilai PTS Genap'),
                      subtitle: Text('Hasil penilaian tengah semester genap'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UjianTahsinDetailPage(id: items.nilaiPtsGenap?.id)),
                        );
                      }
                  ),
                if (items.nilaiPasGenap != null)
                  ListTile(
                      title: Text('Nilai PAS Genap'),
                      subtitle: Text('Hasil penilaian akhir semester genap'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UjianTahsinDetailPage(id: items.nilaiPasGenap?.id)),
                        );
                      }
                  ),
              ],
            ),
          );
        }
      )
    );
  }
}