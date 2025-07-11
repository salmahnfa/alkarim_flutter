import 'package:alkarim/api/api_service.dart';
import 'package:alkarim/api/endpoints.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/models/mutabaah_sekolah_perbulan_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MutabaahSekolahPage extends StatefulWidget {
  @override
  State<MutabaahSekolahPage> createState() => _MutabaahSekolahPageState();
}

class _MutabaahSekolahPageState extends State<MutabaahSekolahPage> {
  final DateFormat dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
  late Future<MutabaahSekolahPerbulanResponse> _future;
  //late Future<MutabaahGemaQuHarianResponse> _dailyFuture;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _future = fetchData();
    //_dailyFuture = fetchHarianData();
  }

  Future<MutabaahSekolahPerbulanResponse> fetchData() async {
    final token = AuthHelper.getToken();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mutabaah'),
      ),
      body: Column(
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
                          //_dailyFuture = fetchHarianData();
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
            }
          )
        ]
      ),
    );
  }
}

DateTime getOnlyDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}