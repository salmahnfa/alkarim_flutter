import 'package:flutter/material.dart';

class UjianTasmiDetailPage extends StatefulWidget {
  final dynamic item;

  const UjianTasmiDetailPage({required this.item, super.key});

  @override
  State<UjianTasmiDetailPage> createState() => _UjianTasmiDetailPageState();
}

class _UjianTasmiDetailPageState extends State<UjianTasmiDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Ujian Naik Jilid'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tanggal Ujian: ${widget.item.tanggalUjian}'),
              Text('Juz yang Diuji: ${widget.item.juz}'),
              Text('Nilai: ${widget.item.nilai}'),
              Text('Predikat: ${widget.item.nilaiHuruf}'),
              Text('Status: ${widget.item.lulus == 1 ? 'Lulus' : 'Tidak Lulus'}'),
              Text('Guru Quran: ${widget.item.penguji.user.nama}'),
              Text('Catatan: ${widget.item.catatan ?? 'Tidak ada catatan'}')
            ]
          ),
        )
    );
  }
}