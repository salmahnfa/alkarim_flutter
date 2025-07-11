import 'package:alkarim/cardview.dart';
import 'package:alkarim/pages/hasil_ujian/naik_jilid/ujian_naik_jilid_page.dart';
import 'package:alkarim/pages/hasil_ujian/tahfidz/ujian_tahfidz_page.dart';
import 'package:alkarim/pages/hasil_ujian/tahsin/ujian_tahsin_page.dart';
import 'package:alkarim/pages/hasil_ujian/tasmi/ujian_tasmi_page.dart';
import 'package:flutter/material.dart';

class HasilUjianPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CardView(
                title: 'Tahsin',
                description: 'Ujian membaca Al Quran',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UjianTahsinPage()),
                  );
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: CardView(
                title: 'Tahfidz',
                description: 'Ujian hafalan Al Quran',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UjianTahfidzPage()),
                  );
                }
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CardView(
                title: 'Tasmi',
                description: 'Ujian hafalan Al Quran perjuz',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UjianTasmiPage()),
                  );
                }
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: CardView(
                title: 'Naik Jilid',
                description: 'Ujian kenaikan jilid Al Karim',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UjianNaikJilidPage()),
                  );
                }
              ),
            ),
          ],
        )
      ],
    );
  }
}