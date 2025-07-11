import 'dart:io';

import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/doa_belajar_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DoaBelajarPage extends StatefulWidget {
  @override
  State<DoaBelajarPage> createState() => _DoaBelajarPageState();
}

class _DoaBelajarPageState extends State<DoaBelajarPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<File> fetchData() async {
    final token = AuthHelper.getToken();
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

    if (await file.exists()) {
      return file;
    } else {
      final response = await http.get(
        Uri.parse(filePath),
        headers: {'Authorization': 'Bearer $token'},
      );

      await file.writeAsBytes(response.bodyBytes);
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doa Belajar'),
      ),
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
                return SfPdfViewer.file(snapshot.data!);
              }
            }
        )
    );
  }
}