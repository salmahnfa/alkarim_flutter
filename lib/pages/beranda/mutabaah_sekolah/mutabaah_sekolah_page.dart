import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/buku_alkarim_jilid_response.dart';
import 'package:alkarim/models/gemaqu_baca_jilid_reponse.dart';
import 'package:alkarim/models/mutabaah_sekolah_harian_response.dart';
import 'package:alkarim/models/mutabaah_sekolah_perbulan_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_baca_jilid_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_baca_quran_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_murojaah_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_tahfidz_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_talaqqi_page.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MutabaahSekolahPage extends StatefulWidget {
  @override
  State<MutabaahSekolahPage> createState() => _MutabaahSekolahPageState();
}

class _MutabaahSekolahPageState extends State<MutabaahSekolahPage> with SingleTickerProviderStateMixin {
  final DateFormat dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
  late Future<MutabaahSekolahPerbulanResponse> _future;
  late Future<MutabaahSekolahHarianResponse> _dailyFuture;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _future = fetchData();
    _dailyFuture = fetchHarianData();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<MutabaahSekolahPerbulanResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final focusedMonth = _focusedDay.month;
    final focusedYear = _focusedDay.year;
    print('Selected Month: $focusedMonth');
    print('Selected Year: $focusedYear');

    final res = await api.request<MutabaahSekolahPerbulanResponse>(
      Endpoints.mutabaahSekolahPerbulan(focusedMonth, focusedYear),
      RequestType.GET,
      token: token,
      fromJson: (json) => MutabaahSekolahPerbulanResponse.fromJson(json),
    );
    return res;
  }

  Future<MutabaahSekolahHarianResponse> fetchHarianData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final selected = _selectedDay;
    final selectedDay = selected.day;
    final selectedMonth = selected.month;
    final selectedYear = selected.year;
    print('Selected Day: $selectedDay');
    print('Selected Month: $selectedMonth');
    print('Selected Year: $selectedYear');

    final res = await api.request<MutabaahSekolahHarianResponse>(
      Endpoints.mutabaahSekolahHarian(selectedYear, selectedMonth, selectedDay),
      RequestType.GET,
      token: token,
      fromJson: (json) => MutabaahSekolahHarianResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mutabaah'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                children: [
                  FutureBuilder<MutabaahSekolahPerbulanResponse>(
                    future: _future,
                    builder: (context, snapshot) {
                      print('Connection State: ${snapshot.connectionState}');
                      print('Has Data: ${snapshot.hasData}');
                      print('Has Error: ${snapshot.hasError}');
                      print('Error: ${snapshot.error}');

                      if (snapshot.hasError) {
                        return Center(child: Text('Gagal memuat profil siswa'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('Tidak ada data siswa'));
                      }

                      final mutabaahMap = <DateTime, String>{};
                      for (var item in snapshot.data!.data) {
                        final tanggal = item.tanggal;
                        final tipe = item.tipe;
                        final dateKey = DateTime(_focusedDay.year, _focusedDay.month, tanggal);

                        print('Memasukkan: $dateKey → $tipe');

                        mutabaahMap[getOnlyDate(dateKey)] = tipe;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            TableCalendar(
                              locale: 'id_ID',
                              firstDay: DateTime.utc(2025, 01, 01),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: _focusedDay,
                              calendarFormat: CalendarFormat.month,
                              headerStyle: HeaderStyle(
                                titleCentered: true,
                                formatButtonVisible: false,
                              ),
                              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                  _dailyFuture = fetchHarianData();
                                });
                              },
                              onPageChanged: (focusedDay) {
                                setState(() {
                                  _focusedDay = focusedDay;
                                  _future = fetchData();
                                });
                              },
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  final tipe = mutabaahMap[getOnlyDate(day)];

                                  Color color;
                                  if (tipe == 'sebagian') {
                                    color = AppColors.secondary;
                                  } else if (tipe == 'lengkap') {
                                    color = Colors.green;
                                  } else {
                                    return null;
                                  }

                                  return Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }
                              ),
                            ),
                            //const SizedBox(height: 10),
                          ]
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(dateFormat.format(_selectedDay)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(41),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Sekolah'),
                        Tab(text: 'Asrama'),
                      ],
                      labelColor: Colors.white,
                      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                      indicator: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.all(4),
                      dividerColor: Colors.transparent,
                    ),
                  ),
                  FutureBuilder<MutabaahSekolahHarianResponse>(
                      future: _dailyFuture,
                      builder: (context, snapshot) {
                        print('Connection State: ${snapshot.connectionState}');
                        print('Has Data: ${snapshot.hasData}');
                        print('Has Error: ${snapshot.hasError}');
                        print('Error: ${snapshot.error}');

                        if (snapshot.connectionState == ConnectionState.waiting &&
                            snapshot.hasData == false) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Gagal memuat data siswa'));
                        } else if (!snapshot.hasData) {
                          return Center(child: Text('Tidak ada data siswa'));
                        }

                        final data = snapshot.data!.data;

                        return Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 16)),
                            SizedBox(
                              height: 340,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  buildCardViews(context, data.mutabaahSekolah),
                                  buildCardViews(context, data.mutabaahAsrama),
                                ],
                              ),
                            ),
                          ]
                        );
                      }
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
          ]
        ),
      ),
    );
  }
}

DateTime getOnlyDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

Widget buildCardViews(BuildContext context, dynamic mutabaah) {
  return Column(
    children: [
      _buildInfoRowWithIcon(
        icon: mutabaah.bacaJilid.kehadiran == 'Tidak Hadir' ? CupertinoIcons.xmark : Icons.book_rounded,
        iconColor: !mutabaah.bacaJilid.status
            ? AppColors.textPrimary
            : mutabaah.bacaJilid.kehadiran == 'Izin' || mutabaah.bacaJilid.kehadiran == 'Sakit'
              ? Colors.blue
              : mutabaah.bacaJilid.kehadiran == "Tidak Hadir"
                  ? Colors.red
                  : AppColors.primary,
        label: 'Baca Jilid',
        value: '${mutabaah.bacaJilid.text}',
        showArrow: mutabaah.bacaJilid.status,
        onTap: () {
          if (mutabaah.bacaJilid.status) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailBacaJilidPage(id: mutabaah.bacaJilid.id!))
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Belum ada data yang dimasukkan'));
          }
        },
      ),
      _buildInfoRowWithIcon(
        icon: mutabaah.bacaQuran.kehadiran == 'Tidak Hadir' ? CupertinoIcons.xmark : CupertinoIcons.book_fill,
        iconColor: !mutabaah.bacaQuran.status
          ? AppColors.textPrimary
          : mutabaah.bacaQuran.kehadiran == 'Izin' || mutabaah.bacaQuran.kehadiran == 'Sakit'
            ? Colors.blue
            : mutabaah.bacaQuran.kehadiran == "Tidak Hadir"
              ? Colors.red
              : AppColors.primary,
        label: 'Baca Al Quran',
        value: '${mutabaah.bacaQuran.text}',
        showArrow: mutabaah.bacaQuran.status || mutabaah.bacaQuran.isWarning ,
        onTap: () {
          if (mutabaah.bacaQuran.status || mutabaah.bacaQuran.isWarning) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailBacaAlquranPage(id: mutabaah.bacaQuran.id!))
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Belum ada data yang dimasukkan'));
          }
        },
      ),
      _buildInfoRowWithIcon(
        icon: mutabaah.tahfidz.kehadiran == 'Tidak Hadir' ? CupertinoIcons.xmark : Icons.add,
        iconColor: !mutabaah.tahfidz.status
          ? AppColors.textPrimary
          : mutabaah.tahfidz.kehadiran == 'Izin' || mutabaah.tahfidz.kehadiran == 'Sakit'
            ? Colors.blue
            : mutabaah.tahfidz.kehadiran == "Tidak Hadir"
              ? Colors.red
              : AppColors.primary,
        label: 'Tahfidz',
        value: '${mutabaah.tahfidz.text}',
        showArrow: mutabaah.tahfidz.status,
        onTap: () {
          if (mutabaah.tahfidz.status) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailTahfidzPage(id: mutabaah.tahfidz.id!))
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Belum ada data yang dimasukkan'));
          }
        },
      ),
      _buildInfoRowWithIcon(
        icon: mutabaah.murojaah.kehadiran == 'Tidak Hadir' ? CupertinoIcons.xmark : Icons.replay,
        iconColor: !mutabaah.murojaah.status
          ? AppColors.textPrimary
          : mutabaah.murojaah.kehadiran == 'Izin' || mutabaah.murojaah.kehadiran == 'Sakit'
            ? Colors.blue
            : mutabaah.murojaah.kehadiran == "Tidak Hadir"
              ? Colors.red
              : AppColors.primary,
        label: 'Murojaah',
        value: '${mutabaah.murojaah.text}',
        showArrow: mutabaah.murojaah.status,
        onTap: () {
          if (mutabaah.murojaah.status) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailMurojaahPage(id: mutabaah.murojaah.id!))
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Belum ada data yang dimasukkan'));
          }
        },
      ),
      _buildInfoRowWithIcon(
        icon: mutabaah.talaqqi.kehadiran == 'Tidak Hadir' ? CupertinoIcons.xmark : CupertinoIcons.speaker_1_fill,
        iconColor: !mutabaah.talaqqi.status
          ? AppColors.textPrimary
          : mutabaah.talaqqi.kehadiran == 'Izin' || mutabaah.talaqqi.kehadiran == 'Sakit'
            ? Colors.blue
            : mutabaah.talaqqi.kehadiran == "Tidak Hadir"
              ? Colors.red
              : AppColors.primary,
        label: 'Talaqqi',
        value: '${mutabaah.talaqqi.text}',
        showArrow: mutabaah.talaqqi.status,
        isLast: true,
        onTap: () {
          if (mutabaah.talaqqi.status) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailTalaqqiPage(id: mutabaah.talaqqi.id!))
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(selfSnackbar('Belum ada data yang dimasukkan'));
          }
        },
      ),
    ],
  );
}

Widget _buildInfoRowWithIcon({
  required IconData icon,
  required Color iconColor,
  required String label,
  String? value,
  required bool showArrow,
  bool isLast = false,
  VoidCallback? onTap,
}) {
  final hasValue = value != null && value.isNotEmpty;

  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 16,
                  backgroundColor: iconColor.withValues(alpha: 0.1),
                  child: Icon(icon, color: iconColor.withValues(alpha: 0.7), size: 18)
              ),
              SizedBox(width: 12),
              Expanded(
                child: hasValue
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                )
                    : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              if (showArrow) ...[
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
              ],
            ],
          ),

          if (!isLast) ...[
            SizedBox(height: 8),
            Divider(thickness: 0.5, color: Colors.grey[200]),
          ]
        ],
      ),
    ),
  );
}

class FetchAllData {
  final GemaQuBacaJilidResponse gemaQuBacaJilid;
  final BukuAlKarimJilidResponse jilidList;
  FetchAllData(this.gemaQuBacaJilid, this.jilidList);
}