import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:alkarim/pages/login_page.dart';
import 'package:alkarim/pages/beranda/beranda_page.dart';
import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await AuthHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
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
        home: FutureBuilder<bool>(
          future: AuthHelper.isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return Beranda();
            } else {
              return LoginPage();
            }
          }
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}