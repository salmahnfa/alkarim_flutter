import 'package:flutter/material.dart';

import 'package:alkarim/auth_helper.dart';
import 'package:alkarim/pages/login_page.dart';
import 'package:alkarim/pages/profil/lihat_profil_page.dart';
import 'package:alkarim/pages/profil/ganti_password_page.dart';

import '../../account_list.dart';
import '../../app_colors.dart';
import '../beranda/beranda_page.dart';

class ProfilPage extends StatefulWidget {
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String? _nama;
  String? _email;
  int? _activeId;
  List<Map<String, dynamic>> _accounts = [];

  @override
  void initState() {
    super.initState();

    print(AuthHelper.getActiveSiswaId());
    print(AuthHelper.getActiveSiswaData());

    _loadSiswa();
    _loadAccounts();
  }

  Future<void> _loadSiswa() async {
    final activeData = AuthHelper.getActiveSiswaData();

    setState(() {
      _nama = activeData?['nama'];
      _email = activeData?['email'];
    });
  }

  Future<void> _loadAccounts() async {
    final accounts = await AuthHelper.getAllAccounts();
    final activeId = AuthHelper.getActiveSiswaId();

    setState(() {
      _accounts = accounts;
      _activeId = activeId;
    });
  }

  void _showBottomSheet(BuildContext context, Map<String, WidgetBuilder> pages) async {
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
                    'Pilih Akun',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ..._accounts.map((account) {
              return AccountList(
                title: account['nama'],
                description: account['email'],
                isActive: account['siswaId'] == _activeId,
                onTap: () async {
                  await AuthHelper.setActiveAccount(account['siswaId']);

                  setState(() {
                    _activeId = account['siswaId'];
                    _nama = account['nama'];
                    _email = account['email'];
                  });

                  Navigator.pop(context);
                }
              );
            }),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await AuthHelper.logout();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        'Tambah Akun',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            child: ListTile(
              dense: true,
              //visualDensity: VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              title: Text(
                '$_nama',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                '$_email',
                style: TextStyle(
                   fontSize: 13,
                   color: Colors.grey[600]
                ),
              ),
              trailing: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  _nama!.isNotEmpty ? _nama![0].toUpperCase() : '',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoTile(
                    icon: Icons.person,
                    label: 'Lihat Profil',
                    value: 'Akun dan data siswa',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LihatProfilPage()),
                      );
                    }
                ),
                _buildInfoTile(
                    icon: Icons.key_rounded,
                    label: 'Ganti Password',
                    value: 'Ganti password dengan yang baru',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GantiPasswordPage()),
                      );
                    }
                ),
                _buildInfoTile(
                  icon: Icons.switch_account_rounded,
                  label: 'Ganti Akun',
                  value: 'Ganti ke akun lain',
                  onTap: () => _showBottomSheet(context, {}),
                ),
                _buildInfoTile(
                  icon: Icons.logout_rounded,
                  label: 'Keluar',
                  value: 'Keluar dari akun',
                  isLast: true,
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
                                final siswaId = AuthHelper.getActiveSiswaId();
                                await AuthHelper.deleteAccount(siswaId!);

                                final accounts = await AuthHelper.getAllAccounts();

                                if (accounts.isNotEmpty) {
                                  final nextAccount = accounts.first;
                                  final nextSiswaId = nextAccount['siswaId'];

                                  await AuthHelper.setActiveAccount(nextSiswaId);

                                  if (!context.mounted) return;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => Beranda()),
                                        (route) => false,
                                  );
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginPage()),
                                        (route) => false,
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInfoTile({
  required IconData icon,
  required String label,
  required String value,
  bool isLast = false,
  VoidCallback? onTap,
}) {
  return Column(
    children: [
      ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: VisualDensity(vertical: -4),
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary, size: 18)
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: onTap != null
          ? Icon(Icons.chevron_right, color: Colors.grey[400])
          : null,
      ),
      if (!isLast) Divider(thickness: 0.5, color: Colors.grey[200]),
    ],
  );
}