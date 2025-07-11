import 'dart:io';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/buku_alkarim_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class BukuAlKarimPage extends StatefulWidget {
  final int id;

  const BukuAlKarimPage({required this.id, super.key});

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
    final token = AuthHelper.getToken();
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

  void toggleAudio(String audioPath) async {
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
        title: Text('Buku Al Karim'),
      ),
      body: _isLoading
            ? Center(child: CircularProgressIndicator())
          : _pdfFile == null
            ? Center(child: Text('Gagal memuat buku'))
          : Column(
            children: [
              if (_details[_currentPage - 1].audio!.isNotEmpty)
                ElevatedButton.icon(
                  icon:Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text('Play Audio'),
                  onPressed: () => toggleAudio(_details[_currentPage - 1].audio!),
                ),
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: _pdfController.pageListenable,
                  builder: (context, currentPage, _) {
                    _currentPage = currentPage; // update current page here

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
            ],
          ),
    );
  }
}