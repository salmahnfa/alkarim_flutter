import 'package:alkarim/app_colors.dart';
import 'package:alkarim/info_row.dart';
import 'package:flutter/material.dart';

class UjianTahfidzDetailPage extends StatefulWidget {
  final dynamic item;

  const UjianTahfidzDetailPage({required this.item, super.key});

  @override
  State<UjianTahfidzDetailPage> createState() => _UjianTahfidzDetailPageState();
}

class _UjianTahfidzDetailPageState extends State<UjianTahfidzDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Ujian Tahfidz'),
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
                  if (widget.item.nilai != null)...[
                    infoRow('Juz', widget.item.juz.toString()),

                    if (widget.item.nilaiDesimal.endsWith('.00'))...[
                      infoRow('Nilai', widget.item.nilai.toString())
                    ] else ...[
                      infoRow('Nilai', widget.item.nilaiDesimal),
                    ],

                    infoRow('Predikat', widget.item.nilaiHuruf, isLast: true),
                  ] else ...[
                    infoRow('Juz', widget.item.juz.toString(), isLast: true),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Detail Nilai',
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Surah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nilai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.item.surahs.length,
                    itemBuilder: (context, index) {
                      final surahs = widget.item.surahs[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(surahs.nama),
                        subtitle: Text('Nilai: ${surahs.nilai ?? '-'}'),
                      );
                    }
                  )
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}