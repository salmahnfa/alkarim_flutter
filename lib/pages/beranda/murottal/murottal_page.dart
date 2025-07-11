import 'package:alkarim/cardview.dart';
import 'package:alkarim/pages/beranda/murottal/murottal_juz_page.dart';
import 'package:flutter/material.dart';

class MurottalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Murottal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CardView(
                    title: 'Murottal Surah',
                    description: 'Murottal diputar persurah',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MurottalJuzPage(type: "SURAH")),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardView(
                    title: 'Murottal Ayat',
                    description: 'Murottal diputar perayat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MurottalJuzPage(type: "AYAT")),
                      );
                    },
                  )
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}