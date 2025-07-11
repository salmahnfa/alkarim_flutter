import 'package:flutter/material.dart';

class UjianTahfidzDetailPage extends StatefulWidget {
  final dynamic item;

  const UjianTahfidzDetailPage({required this.item, super.key});

  @override
  State<UjianTahfidzDetailPage> createState() => _UjianTahfidzDetailPageState();
}

class _UjianTahfidzDetailPageState extends State<UjianTahfidzDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Ujian Naik Jilid'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Juz yang Diuji: ${widget.item.juz}'),
                  Text('Nilai: ${widget.item.nilai}'),
                  Text('Predikat: ${widget.item.nilaiHuruf}'),
                  const SizedBox(height: 16),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.item.surahs.length,
                    itemBuilder: (context, index) {
                      final surahs = widget.item.surahs[index];
                      return ListTile(
                        title: Text(surahs.nama),
                        subtitle: Text('Nilai: ${surahs.nilai ?? '-'}'),
                      );
                    }
                  )
                ]
            ),
          ),
        )
    );
  }
}