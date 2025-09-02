import 'dart:io';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/item_list.dart';
import 'package:alkarim/models/surah_response.dart';
import 'package:alkarim/pages/beranda/murottal/murottal_ayat_page.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class MurottalSurahPage extends StatefulWidget {
  final String type;
  final String juz;

  const MurottalSurahPage({required this.type, required this.juz, super.key});

  @override
  State<MurottalSurahPage> createState() => _MurottalSurahPageState();
}

class _MurottalSurahPageState extends State<MurottalSurahPage> {
  late Future<SurahResponse> _future;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _future = fetchData();
    _initAudioSession();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  Future<SurahResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SurahResponse>(
      Endpoints.murottalSurah(widget.juz),
      RequestType.GET,
      token: token,
      fromJson: (json) => SurahResponse.fromJson(json),
    );
    return res;
  }

  Future<String> fetchAndSetupAudio(String url) async {
    final token = AuthHelper.getActiveToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    final audioName = url.split('/').last;
    final cacheDir = await getTemporaryDirectory();
    final audioPath = '${cacheDir.path}/$audioName';

    final audio = File(audioPath);
    await audio.writeAsBytes(response.bodyBytes);

    return audioPath;
  }

  Future<void> playAudio(String url, String title) async {
    try {
      final audioPath = await fetchAndSetupAudio(url);
      await _player.setAudioSource(AudioSource.uri(Uri.file(audioPath)));
      await _player.play();
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memutar audio')),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah Murottal'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<SurahResponse>(
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
                return ItemList(
                  title: item.nama,
                  description: '${item.jumlahAyat} ayat • ${item.arti}',
                  showArrow: widget.type == 'SURAH' ? false : true,
                  onTap: () {
                    if (widget.type == 'AYAT') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MurottalAyatPage(id: item.id)),
                      );
                    } else {
                      if (item.filePath?.isNotEmpty == true) {
                        playAudio(item.filePath!, item.nama);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Audio tidak tersedia')),
                        );
                      }
                    }
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