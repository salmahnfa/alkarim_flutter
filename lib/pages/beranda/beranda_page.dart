import 'package:alkarim/card_with_icon.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/mutabaah_sekolah_page.dart';
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
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Container(
          padding: const EdgeInsets.all(16),
          child: page
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.background,
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
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtonWithLabel(
                icon: Icons.star_rounded,
                iconColor: AppColors.secondary,
                buttonColor: AppColors.background,
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
                buttonColor: AppColors.background,
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
                buttonColor: AppColors.background,
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
                buttonColor: AppColors.background,
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
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CardWithIcon(
                title: 'GemaQu',
                description: 'Capaian kegiatan Quran mandiri',
                icon: Icons.note_add_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MutabaahGemaQuPage()),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CardWithIcon(
                title: 'Mutabaah',
                description: 'Capaian kegiatan Quran di sekolah',
                icon: Icons.school_rounded,
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
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: buttonColor,
            ),
            child: Icon(icon, size: 32, color: iconColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
