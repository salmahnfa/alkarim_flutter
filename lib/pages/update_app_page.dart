import 'package:alkarim/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'beranda/beranda_page.dart';

class UpdateApp extends StatelessWidget {
  final String? updateUrl;
  const UpdateApp({super.key, this.updateUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Required',
      home: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: AlertDialog(
            title: Text('Update Telah Tersedia', style: Theme.of(context).textTheme.titleLarge),
            content: const Text(
              'Versi baru aplikasi telah tersedia. Apakah kamu mau update sekarang?',
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (updateUrl != null && updateUrl!.isNotEmpty) {
                        await launchUrl(Uri.parse(updateUrl!),
                          mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pushReplacement(
                        MaterialPageRoute(builder: (_) => Beranda()),
                      );
                    },
                    child: const Text('Ya'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
