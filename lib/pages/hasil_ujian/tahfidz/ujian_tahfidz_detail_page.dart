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
                  if (widget.item.juz != 0)...[
                    if (widget.item.juz >= 1 && widget.item.juz < 26 ) ...[
                      infoRow('Ujian', 'Juz ${widget.item.juz}'),
                      infoRow('Nilai Bawaan', (widget.item.nilaiBawaan.nilai!.isEmpty ? '-' : widget.item.nilaiBawaan.nilai!)),
                      infoRow('Nilai Ziyadah', widget.item.nilaiZiyadah.nilai ?? '-'),
                      infoRow('Nilai Murojaah', (widget.item.nilaiMurojaah.nilai!.isEmpty ? '-' : widget.item.nilaiMurojaah.nilai!), isLast: (widget.item.isCompleted ? false : true)),

                      /*if (!widget.item.nilaiBawaan.isCompleted) ...[
                        infoRow('Keterangan', widget.item.nilaiBawaan.text)
                      ],

                      if (!widget.item.nilaiZiyadah.isCompleted) ...[
                        infoRow('Keterangan', widget.item.nilaiZiyadah.text)
                      ],

                      if (!widget.item.nilaiMurojaah.isCompleted) ...[
                        infoRow('Keterangan', widget.item.nilaiMurojaah.text)
                      ]*/
                    ] else ...[
                      infoRow('Ujian', 'Juz ${widget.item.juz}', isLast: true),
                    ]
                  ] else ...[
                    infoRow('Surah', widget.item.title, isLast: true)
                  ],
                ],
              ),
            ),
            SizedBox(height: 24),
            if (widget.item.juz > 25 && widget.item.juz <= 30) ...[
              Text(
                'Detail Nilai',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Table(
                //border: TableBorder.all(color: Colors.white),
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1)
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Surah', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Nilai Bawaan', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Nilai Ziyadah', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Nilai Murojaah', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                  for (final surah in widget.item.surahs) TableRow(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(surah.nama),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          (widget.item.nilaiBawaan.nilai.isEmpty) ? '-' : widget.item.nilaiBawaan.nilai,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          (widget.item.nilaiZiyadah.nilai.isEmpty) ? '-' : widget.item.nilaiZiyadah.nilai,
                          textAlign: TextAlign.center,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          (widget.item.nilaiMurojaah.nilai.isEmpty) ? '-' : widget.item.nilaiMurojaah.nilai,
                          textAlign: TextAlign.center,
                        )
                      )
                    ]
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 24),
            /*if (widget.item.juz > 25 && widget.item.juz <= 30) ...[
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
            ],*/
          ],
        ),
      ),
    );
  }
}