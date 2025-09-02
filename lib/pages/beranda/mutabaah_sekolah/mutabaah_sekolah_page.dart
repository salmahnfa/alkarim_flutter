import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/mutabaah_sekolah_harian_response.dart';
import 'package:alkarim/models/mutabaah_sekolah_perbulan_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_baca_jilid_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_baca_quran_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_murojaah_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_tahfidz_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_sekolah/detail_talaqqi_page.dart';
import 'package:alkarim/pages/login_page.dart';
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

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
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
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  final tipe = mutabaahMap[getOnlyDate(day)];

                                  Color color;
                                  if (tipe == 'sebagian') {
                                    color = Colors.red;
                                  } else if (tipe == 'lengkap') {
                                    color = Colors.deepPurpleAccent;
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
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Sekolah'),
                      Tab(text: 'Asrama'),
                    ],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                  ),
                  FutureBuilder<MutabaahSekolahHarianResponse>(
                      future: _dailyFuture,
                      builder: (context, snapshot) {
                        print('Connection State: ${snapshot.connectionState}');
                        print('Has Data: ${snapshot.hasData}');
                        print('Has Error: ${snapshot.hasError}');
                        print('Error: ${snapshot.error}');

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
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
        icon: Icons.book_rounded,
        label: 'Baca Jilid',
        value: '${mutabaah.bacaJilid.text}',
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
        icon: Icons.book_rounded,
        label: 'Baca Al Quran',
        value: '${mutabaah.bacaQuran.text}',
        onTap: () {
          if (mutabaah.bacaQuran.status) {
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
        icon: Icons.book_rounded,
        label: 'Tahfidz',
        value: '${mutabaah.tahfidz.text}',
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
        icon: Icons.book_rounded,
        label: 'Murojaah',
        value: '${mutabaah.murojaah.text}',
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
        icon: Icons.book_rounded,
        label: 'Talaqqi',
        value: '${mutabaah.talaqqi.text}',
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
  Color? iconBackground,
  required String label,
  String? value,
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
            crossAxisAlignment: CrossAxisAlignment.center, // icon + text center
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconBackground ?? Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(icon, color: Colors.blue, size: 18),
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