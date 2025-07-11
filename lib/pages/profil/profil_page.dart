import 'package:flutter/material.dart';

import 'package:alkarim/app_colors.dart';
import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:alkarim/pages/profil/lihat_profil_page.dart';
import 'package:alkarim/pages/profil/ganti_password_page.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilList(
          icon: Icons.person_2_rounded,
          title: 'Lihat Profil',
          description: 'Lihat profilmu',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LihatProfilPage()),
            );
          }
        ),
        ProfilList(
          icon: Icons.key_rounded,
          title: 'Ganti Password',
          description: 'Ganti password baru',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GantiPasswordPage()),
            );
          }
        ),
        ProfilList(
          icon: Icons.switch_account_rounded,
          title: 'Ganti Akun',
          description: 'Ganti ke akun lain',
        ),
        ProfilList(
          icon: Icons.logout_rounded,
          title: 'Keluar',
          description: 'Keluar dari akun',
          onTap: () async {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Keluar'),
                  content: Text('Apakah kamu yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      child: Text('Batal'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Keluar'),
                      onPressed: () async {
                        AuthHelper.logout();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class ProfilList extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const ProfilList({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Icon(icon, size: 24, color: AppColors.tertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ),
          Icon(Icons.chevron_right_rounded, size: 24, color: AppColors.tertiary),
        ],
      ),
    );
  }
}