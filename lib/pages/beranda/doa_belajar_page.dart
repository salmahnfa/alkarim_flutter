import 'dart:io';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/doa_belajar_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class DoaBelajarPage extends StatefulWidget {
  @override
  State<DoaBelajarPage> createState() => _DoaBelajarPageState();
}

class _DoaBelajarPageState extends State<DoaBelajarPage> {
  File? _pdfFile;
  late PdfControllerPinch _pdfController;
  late Future<File> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<File> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<DoaBelajarResponse>(
      Endpoints.doaBelajar,
      RequestType.GET,
      token: token,
      fromJson: (json) => DoaBelajarResponse.fromJson(json),
    );

    final filePath = res.data.file;
    final fileName = filePath.split('/').last;
    final cacheDir = await getTemporaryDirectory();
    final file = File('${cacheDir.path}/$fileName');

    if (!await file.exists()) {
      final response = await http.get(
        Uri.parse(filePath),
        headers: {'Authorization': 'Bearer $token'},
      );

      await file.writeAsBytes(response.bodyBytes);
    }

    _pdfFile = file;
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(_pdfFile!.path),
    );
    return _pdfFile!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doa Belajar'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<File>(
        future: fetchData(),
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
          } else {
            return PdfViewPinch(
              controller: _pdfController,
              padding: 0,
            );
          }
        }
      )
    );
  }
}