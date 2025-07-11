import 'package:alkarim/cardview.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah_page.dart';
import 'package:flutter/material.dart';

import 'package:alkarim/app_colors.dart';
import 'package:alkarim/pages/profil/profil_page.dart';
import 'package:alkarim/pages/hasil_ujian/hasil_ujian_page.dart';
import 'package:alkarim/pages/beranda/buku_alkarim/buku_alkarim_jilid_page.dart';
import 'package:alkarim/pages/beranda/murottal/murottal_page.dart';
import 'package:alkarim/pages/beranda/asmaul_husna_page.dart';
import 'package:alkarim/pages/beranda/doa_belajar_page.dart';

class Beranda extends StatefulWidget {
  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  var _selectedIndex = 0;

  static const List<String> _titles = [
    'Beranda',
    'Hasil Ujian',
    'Profil',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = BerandaPage();
      case 1:
        page = HasilUjianPage();
      case 2:
        page = ProfilPage();
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          //color: Colors.white,
          child: page
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.primary,
          selectedLabelStyle: TextStyle(fontSize: 12, color: AppColors.primary),
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Beranda'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.description_rounded),
                label: 'Hasil Ujian'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded),
                label: 'Profil'
            ),
          ]
      ),
    );
  }
}

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButtonWithLabel(
              icon: Icons.star_rounded,
              iconColor: AppColors.secondary,
              buttonColor: AppColors.secondary[200]!,
              label: 'Buku \nAl Karim',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BukuAlKarimJilidPage()),
                );
              },
            ),
            IconButtonWithLabel(
              icon: Icons.headphones_rounded,
              iconColor: AppColors.primary,
              buttonColor: AppColors.primary[200]!,
              label: 'Murottal\n',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MurottalPage()),
                );
              }
            ),
            IconButtonWithLabel(
              icon: Icons.anchor_rounded,
              iconColor: AppColors.secondary,
              buttonColor: AppColors.secondary[200]!,
              label: 'Asmaul \nHusna',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AsmaulHusnaPage()),
                );
              }
            ),
            IconButtonWithLabel(
              icon: Icons.book_rounded,
              iconColor: AppColors.primary,
              buttonColor: AppColors.primary[200]!,
              label: 'Doa \nBelajar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DoaBelajarPage()),
                );
              }
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CardView(
                title: 'GemaQu',
                description: 'Kegiatan quran mandiri',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MutabaahGemaQuPage()),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CardView(
                title: 'Mutabaah',
                description: 'Kegiatan quran bersama ustadz/ah',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MutabaahSekolahPage()),
                  );
                },
              )
            )
          ],
        ),
      ],
    );
  }
}

class IconButtonWithLabel extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final String label;
  final VoidCallback onPressed;

  const IconButtonWithLabel({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.buttonColor,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, size: 32, color: iconColor),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
