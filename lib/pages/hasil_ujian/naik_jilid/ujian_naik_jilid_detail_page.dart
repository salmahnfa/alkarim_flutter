import 'package:flutter/material.dart';

class UjianNaikJilidDetailPage extends StatefulWidget {
  final dynamic item;

  const UjianNaikJilidDetailPage({required this.item, super.key});

  @override
  State<UjianNaikJilidDetailPage> createState() => _UjianNaikJilidDetailPageState();
}

class _UjianNaikJilidDetailPageState extends State<UjianNaikJilidDetailPage> {
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
            Text('Jilid yang Diuji: ${widget.item.tahsinLevel.nama}'),
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