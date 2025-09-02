import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/item_list.dart';
import 'package:alkarim/jilid_list.dart';
import 'package:alkarim/models/juz_response.dart';
import 'package:alkarim/pages/beranda/murottal/murottal_surah_page.dart';
import 'package:flutter/material.dart';

class MurottalJuzPage extends StatefulWidget {
  final String type;

  const MurottalJuzPage({required this.type, super.key});

  @override
  State<MurottalJuzPage> createState() => _MurottalJuzPageState();
}

class _MurottalJuzPageState extends State<MurottalJuzPage> {
  late Future<JuzResponse> _future;

  @override
  void initState() {
    super.initState();

    _future = fetchData(widget.type);
  }

  Future<JuzResponse> fetchData(String type) async {
    final token = await AuthHelper.getActiveToken();
    final endpoint = type == 'SURAH' ? Endpoints.murottalSurahJuz : Endpoints.murottalAyatJuz;

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<JuzResponse>(
      endpoint,
      RequestType.GET,
      token: token,
      fromJson: (json) => JuzResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juz Murottal'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<JuzResponse>(
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
          print('Jumlah Juz: ${items?.length}');

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = fetchData(widget.type);
              });
            },
            child: ListView.builder(
              itemCount: items?.length,
              itemBuilder: (context, index) {
                final item = items![index];
                return ItemList(
                  title: 'Juz ${item.juz}',
                  description: item.surah,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MurottalSurahPage(type: widget.type, juz: item.juz)),
                    );
                  },
                );
              },
            ),
          );
        }
      )
    );
  }
}