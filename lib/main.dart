import 'package:alkarim/models/version_check_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';

import 'api/api_service.dart';
import 'api/endpoints.dart';
import 'pages/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await AuthHelper.init();

  final versionInfo = await _checkForUpdate();

  runApp(MyApp(versionInfo: versionInfo));
}

class VersionInfo {
  final bool showPopup;
  final bool versionStatus;
  final String? updateUrl;
  VersionInfo({required this.showPopup, required this.versionStatus, this.updateUrl});
}

Future<VersionInfo> _checkForUpdate() async {
  final info = await PackageInfo.fromPlatform();
  final version = info.buildNumber.toString();

  final token = await AuthHelper.getActiveToken();

  final res = await api.request<VersionCheckResponse>(
    Endpoints.versionCheck(version),
    RequestType.GET,
    token: token,
    fromJson: (json) => VersionCheckResponse.fromJson(json),
  );

  return VersionInfo(
    showPopup: res.data.showPopup,
    versionStatus: res.data.versionStatus,
    updateUrl: res.data.playstoreLink,
  );
}

class MyApp extends StatelessWidget {
  final VersionInfo versionInfo;
  const MyApp({super.key, required this.versionInfo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al Karim',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
          bodyMedium: GoogleFonts.poppins(color: AppColors.textPrimary),
          bodySmall: GoogleFonts.poppins(color: AppColors.textPrimary),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        splashColor: Colors.transparent,
      ),
      home: RootPage(versionInfo: versionInfo),
    );
  }
}