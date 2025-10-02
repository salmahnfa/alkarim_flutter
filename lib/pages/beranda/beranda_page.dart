import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/card_with_icon.dart';
import 'package:alkarim/models/siswa_pencapaian_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/mutabaah_gemaqu_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/mutabaah_sekolah_page.dart';
import 'package:alkarim/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'package:alkarim/theme/app_colors.dart';
import 'package:alkarim/pages/profil/profil_page.dart';
import 'package:alkarim/pages/hasil_ujian/hasil_ujian_page.dart';
import 'package:alkarim/pages/beranda/buku_alkarim/buku_alkarim_jilid_page.dart';
import 'package:alkarim/pages/beranda/murottal/murottal_page.dart';
import 'package:alkarim/pages/beranda/asmaul_husna_page.dart';
import 'package:alkarim/pages/beranda/doa_belajar_page.dart';

import '../../api/api_service.dart';
import '../../api/endpoints.dart';

class Beranda extends StatefulWidget {
  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  var _selectedIndex = 0;

  static const List<String> _titles = [
    '',
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
      appBar: _selectedIndex == 0
        ? null
        : AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(_titles[_selectedIndex]),
          ),
          centerTitle: false,
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
          child: page
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
            backgroundColor: AppColors.background,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppColors.primary[800],
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary[800]
            ),
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary.withValues(alpha: 0.7)
            ),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
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
      ),
    );
  }
}

class BerandaPage extends StatefulWidget {
  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<SiswaPencapaianResponse> _future;
  String? _nama;

  @override
  void initState() {
    super.initState();
    
    _loadSiswa();
    _future = fetchData();
  }

  Future<void> _loadSiswa() async {
    final activeData = AuthHelper.getActiveSiswaData();

    setState(() {
      _nama = activeData?['nama'];
    });
  }

  Future<SiswaPencapaianResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final res = await api.request<SiswaPencapaianResponse>(
      Endpoints.pencapaian,
      RequestType.GET,
      token: token,
      fromJson: (json) => SiswaPencapaianResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.4,
                child: Transform.translate(
                  offset: const Offset(0, -232),
                  child: Image.asset(
                    'assets/images/header.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assalamualaikum,',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      ),
                  ),
                  Text(
                   '$_nama',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButtonWithLabel(
                  icon: Icons.star_rounded,
                  iconColor: AppColors.secondary[700]!,
                  buttonColor: AppColors.secondary.withValues(alpha: 0.1),
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
                  iconColor: AppColors.primary[700]!,
                  buttonColor: AppColors.primary.withValues(alpha: 0.1),
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
                  iconColor: AppColors.secondary[700]!,
                  buttonColor: AppColors.secondary.withValues(alpha: 0.1),
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
                  iconColor: AppColors.primary[700]!,
                  buttonColor: AppColors.primary.withValues(alpha: 0.1),
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
        ),
        SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: CardWithIcon(
                  title: 'GemaQu',
                  description: 'Capaian kegiatan Quran mandiri',
                  icon: Icons.home_rounded,
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
                  icon: Icons.home_repair_service_rounded,
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
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Pencapaian bulan ini",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<SiswaPencapaianResponse>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } if (snapshot.hasError) {
              debugPrint('Future error: ${snapshot.error}');
              debugPrint('Stack trace: ${snapshot.stackTrace}');
              return Center(child: Text('Gagal memuat halaman'));
            } if (!snapshot.hasData) {
              return Center(child: Text('Tidak ada data siswa'));
            }
            
            final data = snapshot.data!.data;
            
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _future = fetchData();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoBox(
                        label: data.ziyadah.surahMulai.isNotEmpty ? 'Menghafal' : 'Belum ada data ziyadah',
                        value: data.ziyadah.surahMulai.isNotEmpty ? '${data.ziyadah.surahMulai}: ${data.ziyadah.ayatMulai} - ${data.ziyadah.surahSelesai}: ${data.ziyadah.ayatSelesai}' : ''),
                      const SizedBox(width: 8),
                      InfoBox(
                        label: data.murojaah.isNotEmpty ? 'Murojaah' : 'Belum ada data murojaah',
                        value: data.murojaah.isNotEmpty ? 'Juz ${data.murojaah}' : ''),
                      const SizedBox(width: 8),
                      InfoBox(
                        label: data.tilawah.isNotEmpty ? 'Membaca' : 'Belum ada data tilawah',
                        value: data.tilawah.isNotEmpty ? 'Juz ${data.tilawah}' : ''),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}

class InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const InfoBox({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(text: '$label '),
              TextSpan(
                text: value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
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
          child: CircleAvatar(
              radius: 28,
              backgroundColor: buttonColor,
              child: Icon(icon, color: iconColor, size: 32)
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

Widget buildInfoBox(Data data) {
  return Expanded(  
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        "Ziyadah dari ${data.ziyadah.surahMulai}:${data.ziyadah.ayatMulai} - "
            "${data.ziyadah.surahSelesai}:${data.ziyadah.ayatSelesai}",
      ),
    ),
  );
}

