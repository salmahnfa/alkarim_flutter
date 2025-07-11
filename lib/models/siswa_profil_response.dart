class SiswaProfilResponse {
  final bool success;
  final Data data;
  final String message;

  SiswaProfilResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  SiswaProfilResponse.fromJson(Map<String,dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final int siswaId;
  final String nisn;
  final String nis;
  final String nama;
  final String email;
  final String unit;
  final String kelas;
  final String program;
  final bool isAsrama;
  final String grade;
  final String guruQuran;
  final String guruQuranGender;
  final String guruAsrama;
  final String guruAsramaGender;
  final String surahDihafal;
  final String tahsin;

  Data({
    required this.siswaId,
    required this.nisn,
    required this.nis,
    required this.nama,
    required this.email,
    required this.unit,
    required this.kelas,
    required this.program,
    required this.isAsrama,
    required this.grade,
    required this.guruQuran,
    required this.guruQuranGender,
    required this.guruAsrama,
    required this.guruAsramaGender,
    required this.surahDihafal,
    required this.tahsin,
  });

  Data.fromJson(Map<String, dynamic> json)
    : siswaId = json['siswa_id'],
      nisn = json['nisn'],
      nis = json['nis'],
      nama = json['nama'],
      email = json['email'],
      unit = json['unit'],
      kelas = json['kelas'],
      program = json['program'],
      isAsrama = json['is_asrama'],
      grade = json['grade'] ?? '',
      guruQuran = json['guru_quran'] ?? '',
      guruQuranGender = json['guru_quran_gender'] ?? '',
      guruAsrama = json['guru_asrama'] ?? '',
      guruAsramaGender = json['guru_asrama_gender'] ?? '',
      surahDihafal = json['surah_dihafal'] ?? '',
      tahsin = json['tahsin'] ?? '';
}