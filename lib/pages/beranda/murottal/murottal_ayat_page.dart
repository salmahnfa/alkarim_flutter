import 'dart:io';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/jilid_list.dart';
import 'package:alkarim/models/surah_perayat_response.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class MurottalAyatPage extends StatefulWidget {
  final int id;

  const MurottalAyatPage({required this.id, super.key});

  @override
  State<MurottalAyatPage> createState() => _MurottalAyatPageState();
}

class _MurottalAyatPageState extends State<MurottalAyatPage> {
  late Future<SurahPerayatResponse> _future;
  final _player = AudioPlayer();
  String? _currentTitle;
  bool _isPlaying = false;

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

  Future<SurahPerayatResponse> fetchData() async {
    final token = AuthHelper.getToken();
    final res = await api.request<SurahPerayatResponse>(
      Endpoints.murottalAyat(widget.id),
      RequestType.GET,
      token: token,
      fromJson: (json) => SurahPerayatResponse.fromJson(json),
    );
    return res;
  }

  Future<String> fetchAndSetupAudio(String url) async {
    final token = AuthHelper.getToken();
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

      setState(() {
        _currentTitle = title;
        _isPlaying = true;
      });

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => _isPlaying = false);
        }
      });
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
        title: Text('Murottal'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<SurahPerayatResponse>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Gagal memuat buku Al Karim'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('Tidak ada data buku Al Karim'));
                  }

                  final items = snapshot.data?.data.murottal;
                  print('Jumlah Jilid: ${items?.length}');

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _future = fetchData();
                      });
                    },
                    child: ListView.builder(
                      itemCount: items?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = items![index];
                        return JilidList(
                          title: item.ayat,
                          description: '',
                          onTap: () {
                            if (item.filePath.isNotEmpty == true) {
                              playAudio(item.filePath.first, item.ayat);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Audio tidak tersedia')),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              )
            ),
          ),
          if (_currentTitle != null)
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (_isPlaying) {
                        await _player.pause();
                      } else {
                        await _player.play();
                      }
                      setState(() => _isPlaying = !_isPlaying);
                    },
                  ),
                  Expanded(
                    child: Text(
                      _currentTitle ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}