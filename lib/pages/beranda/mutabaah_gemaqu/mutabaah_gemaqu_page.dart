import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/cardview.dart';
import 'package:alkarim/models/mutabaah_gemaqu_harian.dart';
import 'package:alkarim/models/mutabaah_gemaqu_perbulan_response.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_baca_jilid_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_baca_quran_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_tahfidz_ayat_form_page.dart';
import 'package:alkarim/pages/beranda/mutabaah_gemaqu/gemaqu_tahfidz_halaman_form_page.dart';
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
    final token = AuthHelper.getToken();

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
    final token = AuthHelper.getToken();

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
        title: Text('GemaQu'),
      ),
      body: SingleChildScrollView(
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
                            //print('day + type: $day $tipe');
        
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
                      const SizedBox(height: 10),
                    ]
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
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
        
                return Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(16),
                      child: Text(dateFormat.format(_selectedDay)),
                    ),
                    CardView(
                      title: 'Baca Jilid',
                      description: '${data.bacaJilid.text}',
                      onTap: () {
                        Navigator.push(
                          context,
                          data.bacaJilid.status
                            ? MaterialPageRoute(builder: (_) => MutabaahGemaQuPage())
                            : MaterialPageRoute(builder: (_) => GemaQuBacaJilidFormPage(selectedDay: getOnlyDate(_selectedDay)))
                        );
                      },
                    ),
                    CardView(
                      title: 'Baca Al Quran',
                      description: '${data.bacaQuran.text}',
                      onTap: () {
                        Navigator.push(
                          context,
                          data.bacaQuran.status
                            ? MaterialPageRoute(builder: (_) => MutabaahGemaQuPage())
                            : MaterialPageRoute(builder: (_) => GemaQuBacaQuranFormPage(selectedDay: getOnlyDate(_selectedDay)))
                        );
                      },
                    ),
                    CardView(
                      title: 'Tahfidz',
                      description: '${data.tahfidz.text}',
                      onTap: () => _showBottomSheet(context, _selectedDay),
                    ),
                    CardView(
                      title: 'Murojaah',
                      description: '${data.murojaah.text}',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MutabaahGemaQuPage()),
                        );
                      },
                    ),
                  ]
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

void _showBottomSheet(BuildContext context, DateTime selectedDay) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 32,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CardView(
            title: 'Surah & Ayat',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GemaQuTahfidzAyatFormPage(selectedDay: getOnlyDate(selectedDay))),
              );
            }
          ),
          CardView(
            title: 'Halaman',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GemaQuTahfidzHalamanFormPage(selectedDay: getOnlyDate(selectedDay))),
              );
            }
          ),
          SizedBox(height: 24),
        ],
      )
    ),
  );
}