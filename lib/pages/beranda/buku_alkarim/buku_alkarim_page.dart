import 'dart:io';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/buku_alkarim_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class BukuAlKarimPage extends StatefulWidget {
  final int id;
  final String jilid;
  final int jumlahHalamanDilewati;

  const BukuAlKarimPage({required this.id, required this.jilid, required this.jumlahHalamanDilewati, super.key});

  @override
  State<BukuAlKarimPage> createState() => _BukuAlKarimPageState();
}

class _BukuAlKarimPageState extends State<BukuAlKarimPage> {
  bool _isLoading = true;
  File? _pdfFile;
  late PdfController _pdfController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Details> _details = [];
  int _currentPage = 1;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    fetchAndSetupBook();
  }

  Future<void> fetchAndSetupBook() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<BukuAlKarimResponse>(
      Endpoints.bukuAlKarim(widget.id),
      RequestType.GET,
      token: token,
      fromJson: (json) => BukuAlKarimResponse.fromJson(json),
    );

    final filePath = res.data.filePath;
    final fileName = filePath.split('/').last;
    final cacheDir = await getTemporaryDirectory();
    final file = File('${cacheDir.path}/$fileName');

    if (await file.exists()) {
      _pdfFile = file;
    } else {
      final response = await http.get(
        Uri.parse(filePath),
        headers: {'Authorization': 'Bearer $token'},
      );

      await file.writeAsBytes(response.bodyBytes);
      _pdfFile = file;
    }

    _pdfController = PdfController(
      document: PdfDocument.openFile(_pdfFile!.path),
    );

    _details = res.data.details;

    setState(() {
      _isLoading = false;
    });
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

  void toggleAudio(String audioPath) async {
    debugPrint('Audio URL: $audioPath');

    if (audioPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio tidak tersedia')),
      );
      return;
    }

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.stop();
        final localPath = await fetchAndSetupAudio(audioPath);
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(localPath)));
        await _audioPlayer.play();
      }

      setState(() {
        isPlaying = !isPlaying;
      });
    } catch (e) {
      print("Audio error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memutar audio')),
      );
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.jilid),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: _isLoading
            ? Center(child: CircularProgressIndicator())
          : _pdfFile == null
            ? Center(child: Text('Gagal memuat buku'))
          : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_details[_currentPage - 1].audio!.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 4),
                  child: ElevatedButton.icon(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text('Bagaimana bunyinya?'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(0, 44),
                      ),
                      onPressed: () => toggleAudio(_details[_currentPage - 1].audio!),
                    ),
                ),
              Flexible(
                fit: FlexFit.loose,
                child: ValueListenableBuilder<int>(
                  valueListenable: _pdfController.pageListenable,
                  builder: (context, currentPage, _) {
                    _currentPage = currentPage;

                    return PdfView(
                      controller: _pdfController,
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      onPageChanged: (page) {
                        if (isPlaying) {
                          _audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        }

                        setState(() {
                          _currentPage = page;
                        });
                      },
                    );
                  },
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: IntrinsicWidth(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        /*decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),*/
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left_rounded),
                              onPressed: () {
                                if (_currentPage > 1) {
                                  final prev = _currentPage - 1;
                                  _pdfController.jumpToPage(prev);
                                  setState(() => _currentPage = prev);
                                }
                              },
                            ),
                            const SizedBox(width: 20),
                            _currentPage <= widget.jumlahHalamanDilewati
                              ? Text('Halaman 1',
                                  style: TextStyle(fontSize: 16, color: AppColors.background),
                                )
                              : Text('Halaman ${_currentPage - widget.jumlahHalamanDilewati}',
                                  style: TextStyle(fontSize: 16),
                                ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: const Icon(Icons.chevron_right_rounded),
                              onPressed: () {
                                final totalPages = _pdfController.pagesCount;
                                if (totalPages != null && _currentPage < totalPages) {
                                  final next = _currentPage + 1;
                                  _pdfController.jumpToPage(next);
                                  setState(() => _currentPage = next);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
    );
  }
}