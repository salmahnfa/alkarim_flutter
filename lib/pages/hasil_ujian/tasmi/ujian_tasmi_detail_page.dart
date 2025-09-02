import 'package:alkarim/app_colors.dart';
import 'package:alkarim/info_row.dart';
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
          title: Text('Detail Ujian Tasmi'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Ujian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow('Tanggal', widget.item.tanggalUjian),
                    infoRow('Juz', widget.item.juz),

                    if (widget.item.nilaiDesimal.endsWith('.00'))...[
                      infoRow('Nilai', widget.item.nilai.toString())
                    ] else ...[
                      infoRow('Nilai', widget.item.nilaiDesimal),
                    ],

                    infoRow('Predikat', widget.item.nilaiHuruf),
                    infoRow('Status', widget.item.lulus == 1 ? 'Lulus' : 'Tidak Lulus', isLast: true),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Catatan Penguji',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow('Penguji', widget.item.penguji.user.nama),
                    infoRow('Catatan', widget.item.catatan ?? '-', isLast: true),
                  ],
                ),
              ),
            ]
          ),
        )
    );
  }
}