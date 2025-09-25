import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/item_list.dart';
import 'package:alkarim/models/mutabaah_gemaqu_harian_response.dart';
import 'package:alkarim/models/mutabaah_gemaqu_perbulan_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_baca_jilid_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_baca_quran_ayat_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_baca_quran_halaman_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_murojaah_ayat_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_murojaah_halaman_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_murojaah_surah_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_tahfidz_ayat_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_tahfidz_halaman_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MutabaahGemaQuPage extends StatefulWidget {
  @override
  State<MutabaahGemaQuPage> createState() => _MutabaahGemaQuPageState();
}

class _MutabaahGemaQuPageState extends State<MutabaahGemaQuPage> {
  final DateFormat dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
  late Future<MutabaahGemaQuPerbulanResponse> _future;
  late Future<MutabaahGemaQuHarianResponse> _dailyFuture;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _future = fetchData();
    _dailyFuture = fetchHarianData();
  }

  Future<MutabaahGemaQuPerbulanResponse> fetchData() async {
    final token = await AuthHelper.getActiveToken();

    if (token == null) {
      throw Exception('Pengguna perlu login ulang untuk melanjutkan.');
    }

    final focusedMonth = _focusedDay.month;
    final focusedYear = _focusedDay.year;
    print('Selected Month: $focusedMonth');
    print('Selected Year: $focusedYear');

    final res = await api.request<MutabaahGemaQuPerbulanResponse>(
      Endpoints.mutabaahGemaQuPerbulan(focusedMonth, focusedYear),
      RequestType.GET,
      token: token,
      fromJson: (json) => MutabaahGemaQuPerbulanResponse.fromJson(json),
    );
    return res;
  }

  Future<MutabaahGemaQuHarianResponse> fetchHarianData() async {
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

    final res = await api.request<MutabaahGemaQuHarianResponse>(
      Endpoints.mutabaahGemaQuHarian(selectedYear, selectedMonth, selectedDay),
      RequestType.GET,
      token: token,
      fromJson: (json) => MutabaahGemaQuHarianResponse.fromJson(json),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('GemaQu'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  FutureBuilder<MutabaahGemaQuPerbulanResponse>(
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
                                /*todayDecoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),*/
                                /*selectedDecoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),*/
                              ),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  final tipe = mutabaahMap[getOnlyDate(day)];

                                  Color color;
                                  if (tipe == 'sebagian') {
                                    color = AppColors.secondary.withValues(alpha: 0.7);
                                  } else if (tipe == 'lengkap') {
                                    color = AppColors.primary.withValues(alpha: 0.7);
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
                                },
                                /*todayBuilder: (context, day, focusedDay) {
                                  // cek apakah day sama dengan DateTime.now() hanya tanggalnya
                                  final isToday = isSameDay(day, DateTime.now());

                                  return Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,      // BOLD untuk hari ini
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },*/
                              ),
                            ),
                            //const SizedBox(height: 10),
                          ]
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<MutabaahGemaQuHarianResponse>(
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
                print('Data: ${data.bacaJilid.text}');

                return Container(
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
                      _buildInfoRowWithIcon(
                        icon: Icons.book_rounded,
                        iconColor: data.bacaJilid.status ? AppColors.primary : AppColors.textPrimary,
                        label: 'Baca Jilid',
                        value: '${data.bacaJilid.text}',
                        onTap: () {
                          Navigator.push(
                            context,
                            data.bacaJilid.status
                              ? MaterialPageRoute(builder: (_) => GemaQuBacaJilidFormPage(isNotEmpty: true, selectedDay: getOnlyDate(_selectedDay)))
                              : MaterialPageRoute(builder: (_) => GemaQuBacaJilidFormPage(isNotEmpty: false, selectedDay: getOnlyDate(_selectedDay)))
                          );
                        },
                      ),
                      _buildInfoRowWithIcon(
                        icon: CupertinoIcons.book_fill,
                        iconColor: data.bacaQuran.status ? AppColors.primary : AppColors.textPrimary,
                        label: 'Baca Al Quran',
                        value: '${data.bacaQuran.text}',
                        onTap: () {
                          if (data.bacaQuran.status) {
                            Navigator.push(
                              context,
                              data.bacaQuran.tipeInput == 'halaman'
                                ? MaterialPageRoute(builder: (_) => GemaQuBacaQuranHalamanFormPage(selectedDay: getOnlyDate(_selectedDay)))
                                : MaterialPageRoute(builder: (_) => GemaQuBacaQuranAyatFormPage(selectedDay: getOnlyDate(_selectedDay)))
                            );
                          } else {
                            _showBottomSheet(
                              context,
                              {
                                'Ayat': (_) => GemaQuBacaQuranAyatFormPage(selectedDay: getOnlyDate(_selectedDay)),
                                'Halaman': (_) => GemaQuBacaQuranHalamanFormPage(selectedDay: getOnlyDate(_selectedDay)),
                              }
                            );
                          }
                        }
                      ),
                      _buildInfoRowWithIcon(
                        icon: Icons.add,
                        iconColor: data.tahfidz.status ? AppColors.primary : AppColors.textPrimary,
                        label: 'Tahfidz',
                        value: '${data.tahfidz.text}',
                        onTap: () {
                          if (data.tahfidz.status) {
                            Navigator.push(
                              context,
                              data.tahfidz.tipeInput == 'halaman'
                                ? MaterialPageRoute(builder: (_) => GemaQuTahfidzHalamanFormPage(selectedDay: getOnlyDate(_selectedDay)))
                                : MaterialPageRoute(builder: (_) => GemaQuTahfidzAyatFormPage(selectedDay: getOnlyDate(_selectedDay)))
                            );
                          } else {
                            _showBottomSheet(
                              context, 
                              {
                                'Ayat': (_) => GemaQuTahfidzAyatFormPage(selectedDay: getOnlyDate(_selectedDay)),
                                'Halaman': (_) => GemaQuTahfidzHalamanFormPage(selectedDay: getOnlyDate(_selectedDay)),
                              }
                            );
                          }
                        }
                      ),
                      _buildInfoRowWithIcon(
                        icon: Icons.replay_rounded,
                        iconColor: data.murojaah.status ? AppColors.primary : AppColors.textPrimary,
                        label: 'Murojaah',
                        value: '${data.murojaah.text}',
                        isLast: true,
                        onTap: () {
                          if (data.murojaah.status) {
                            Navigator.push(
                              context,
                              data.bacaQuran.tipeInput == 'halaman'
                                ? MaterialPageRoute(builder: (_) => GemaQuMurojaahHalamanFormPage(selectedDay: getOnlyDate(_selectedDay)))
                                : MaterialPageRoute(builder: (_) => GemaQuMurojaahAyatFormPage(selectedDay: getOnlyDate(_selectedDay)))
                            );
                          } else {
                            _showBottomSheet(
                              context,
                              {
                                'Ayat': (_) => GemaQuMurojaahAyatFormPage(selectedDay: getOnlyDate(_selectedDay)),
                                'Surah': (_) => GemaQuMurojaahSurahFormPage(selectedDay: getOnlyDate(_selectedDay)),
                                'Halaman': (_) => GemaQuMurojaahHalamanFormPage(selectedDay: getOnlyDate(_selectedDay)),
                              }
                            );
                          }
                        },
                      ),
                    ]
                  ),
                );
              }
            )
          ],
        ),
      )
    );
  }
}

DateTime getOnlyDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

void _showBottomSheet(BuildContext context, Map<String, WidgetBuilder> pages) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipe Input',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih tipe input yang ingin dimasukkan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...pages.entries.map((entry) {
            return ItemList(
              title: entry.key,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: entry.value),
                );
              }
            );
          }),
          const SizedBox(height: 24),
        ],
      )
    ),
  );
}

Widget _buildInfoRowWithIcon({
  required IconData icon,
  required Color iconColor,
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
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
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
