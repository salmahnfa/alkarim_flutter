import 'dart:io';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/item_list.dart';
import 'package:alkarim/models/surah_perayat_response.dart';
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

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
    _initAudioSession();

    _player.positionStream.listen((pos) {
      setState(() => _currentPosition = pos);
    });
    _player.durationStream.listen((dur) {
      setState(() => _totalDuration = dur ?? Duration.zero);
    });
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  Future<SurahPerayatResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SurahPerayatResponse>(
      Endpoints.murottalAyat(widget.id),
      RequestType.GET,
      token: token,
      fromJson: (json) => SurahPerayatResponse.fromJson(json),
    );
    return res;
  }

  Future<String> fetchAndSetupAudio(String url) async {
    final token = await AuthHelper.getActiveToken();
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
      setState(() {
        _currentTitle = title;
      });

      await _player.stop();

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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
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
        title: Text('Murottal Ayat'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
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
                    print('Jumlah Ayat: ${items?.length}');

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
                          return ItemList(
                            title: item.ayat,
                            showArrow: false,
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
            ],
          ),
          if (_currentTitle != null)
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        StreamBuilder<bool>(
                          stream: _player.playingStream,
                          builder: (context, snapshot) {
                            final isPlaying = snapshot.data ?? false;
                            return IconButton(
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_fill_rounded,
                                size: 42,
                                color: AppColors.secondary,
                              ),
                              onPressed: () async {
                                if (isPlaying) {
                                  await _player.pause();
                                } else {
                                  // Kalau sudah completed, reset posisi
                                  if (_player.playerState.processingState == ProcessingState.completed) {
                                    await _player.seek(Duration.zero);
                                  }
                                  await _player.play();
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _currentTitle ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: _totalDuration.inMilliseconds > 0
                            ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                            : 0,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(AppColors.secondary),
                        minHeight: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}