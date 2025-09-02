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
    final activeId = await AuthHelper.getActiveSiswaId();

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

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          'Masuk',
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
    return Column(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRowWithIcon(
                icon: Icons.logout_rounded,
                label: '$_nama',
                value: '$_email',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
              _buildInfoRowWithIcon(
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
              _buildInfoRowWithIcon(
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
              _buildInfoRowWithIcon(
                  icon: Icons.switch_account_rounded,
                  label: 'Ganti Akun',
                  value: 'Ganti ke akun lain',
                  onTap: () => _showBottomSheet(
                    context,
                    {
                      /*'Ayat': (_) => GemaQuTahfidzAyatFormPage(selectedDay: getOnlyDate(_selectedDay)),
                      'Halaman': (_) => GemaQuTahfidzHalamanFormPage(selectedDay: getOnlyDate(_selectedDay)),*/
                    }
                  ),
              ),
              _buildInfoRowWithIcon(
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
                              final siswaId = await AuthHelper.getActiveSiswaId();
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
    );
  }
}

Widget _buildInfoRowWithIcon({
  required IconData icon,
  required String label,
  required String value,
  bool isLast = false,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(icon, color: Colors.blue, size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
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
                          color: Colors.grey[600]
                      ),
                    ),
                  ],
                ),
              ),
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