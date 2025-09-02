import 'package:alkarim/app_colors.dart';
import 'package:alkarim/card_with_icon.dart';
import 'package:alkarim/pages/beranda/murottal/murottal_juz_page.dart';
import 'package:flutter/material.dart';

class MurottalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Murottal'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CardWithIcon(
                    title: 'Murottal Surah',
                    description: 'Murottal diputar persurah',
                    icon: Icons.play_arrow_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MurottalJuzPage(type: "SURAH")),
                      );
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CardWithIcon(
                    title: 'Murottal Ayat',
                    description: 'Murottal diputar perayat',
                    icon: Icons.play_arrow_rounded,
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