import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'info_row.dart';
import 'models/mutabaah_sekolah_detail_response.dart' as mutabaah;
import 'models/sekolah_baca_jilid_detail_response.dart' as baca_jilid;


class DetailMutabaahList extends StatelessWidget {
  final mutabaah.Data data;
  
  const DetailMutabaahList({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: getKelompokColor(data.tipeKelompok),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: Text(data.tipeKelompok),
                    )
                  ),
                  const SizedBox(height: 8),
                  infoRow('Tanggal', data.tanggal),
                  if (data.isHadir) ...[
                    if (data.inputSurah) ...[
                      if (data.surahMulai.nama == data.surahSelesai.nama) ...[
                        infoRow(
                          'Capaian',
                            data.surahMulai.ayat == data.surahSelesai.ayat
                            ? 'QS ${data.surahMulai.nama}: ${data.surahMulai.ayat}'
                            : 'QS ${data.surahMulai.nama}: ${data.surahMulai.ayat} - ${data.surahSelesai.ayat}'
                        )
                      ] else ...[
                        infoRow('Capaian', 'QS ${data.surahMulai.nama}: ${data.surahMulai.ayat} - ${data.surahSelesai.nama}: ${data.surahSelesai.ayat}'),
                      ]
                    ] else ...[
                      infoRow('Capaian', 'Halaman ${data.halamanMulai} - ${data.halamanSelesai}'),
                    ],
                    infoRow('Keterangan', toBeginningOfSentenceCase(data.keterangan!.toLowerCase()))
                  ] else ...[
                    infoRow('Keterangan', data.kehadiran)
                  ],
                  infoRow('Guru Quran', data.guruQuran),
                  infoRow('Catatan', data.catatan!, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailMutabaahBacaJilidList extends StatelessWidget {
  final baca_jilid.Data data;

  const DetailMutabaahBacaJilidList({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: getKelompokColor(data.tipeKelompok),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: Text(data.tipeKelompok),
                      )
                  ),
                  const SizedBox(height: 8),
                  infoRow('Tanggal', data.tanggal),
                  if (data.isHadir) ...[
                    infoRow('Jilid', data.buku),
                    if (data.halamanMulai != null && data.halamanSelesai != null) ...[
                      if (data.halamanMulai == data.halamanSelesai) ...[
                        infoRow('Capaian', 'Halaman $data.halamanMulai'),
                      ] else ...[
                        infoRow('Capaian', 'Halaman ${data.halamanMulai} - ${data.halamanSelesai}'),
                      ],
                      infoRow('Keterangan', toBeginningOfSentenceCase(data.keterangan!.toLowerCase()))
                    ]
                  ] else ...[
                    infoRow('Keterangan', data.kehadiran)
                  ],
                  infoRow('Guru Quran', data.guruQuran),
                  infoRow('Catatan', data.catatan!, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color getKelompokColor(String tipe) {
  switch (tipe) {
    case 'Sekolah':
      return Colors.yellow;
    case 'Pesantren Tahfidz':
      return Colors.green;
    case 'Akselerasi':
      return Colors.orange;
    case 'Matrikulasi':
      return Colors.red;
    default:
      return Colors.blue;
  }
}
