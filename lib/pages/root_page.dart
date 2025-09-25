import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth_helper.dart';
import '../main.dart';
import 'beranda/beranda_page.dart';
import 'login_page.dart';

class RootPage extends StatefulWidget {
  final VersionInfo versionInfo;
  const RootPage({super.key, required this.versionInfo});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.versionInfo.showPopup) {
        _showUpdateDialog(context, widget.versionInfo.versionStatus, widget.versionInfo.updateUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthHelper.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == true ? Beranda() : LoginPage();
      },
    );
  }
}

void _showUpdateDialog(BuildContext context, bool status, String? url) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Pembaruan Tersedia'),
      content: Text(
        status
        ? 'Versi aplikasi terbaru sudah tersedia. Apakah mau update aplikasi sekarang?'
        : 'Versi aplikasi terbaru sudah tersedia. Silakan update aplikasi untuk melanjutkan.',
      ),
      actions: [
        status
        ? TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('Nanti'),
          )
        : const SizedBox.shrink(),
        TextButton(
          onPressed: () async {
            if (url != null) {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}
