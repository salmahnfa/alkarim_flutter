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
                    infoRow('Juz', widget.item.juz, isLast: widget.item.predikat != null ? false : true),

                    if (widget.item.predikat != null) ...[
                      infoRow('Predikat', capitalizeWords(widget.item.predikat), isHighlighted: true, isLast: true),
                    ],
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

String capitalizeWords(String text) {
  return text
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) => word.isNotEmpty
      ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
      : '')
      .join(' ');
}