class UjianTahsinDetailResponse {
  final bool success;
  final Data data;
  final String message;

  UjianTahsinDetailResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  UjianTahsinDetailResponse.fromJson(Map<String, dynamic> json)
  : success = json['success'],
    data = Data.fromJson(json['data']),
    message = json['message'];
}

class Data {
  final int id;
  final int siswaId;
  final String tahunAjaran;
  final String semester;
  final String tipeUjian;
  final int guruQuranId;
  final int nilai;
  final String nilaiHuruf;
  final String? catatan;
  final int lulus;
  final GuruQuran guruQuran;

  Data({
    required this.id,
    required this.siswaId,
    required this.tahunAjaran,
    required this.semester,
    required this.tipeUjian,
    required this.guruQuranId,
    required this.nilai,
    required this.nilaiHuruf,
    required this.catatan,
    required this.lulus,
    required this.guruQuran,
  });

  Data.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    siswaId = json['siswa_id'],
    tahunAjaran = json['tahun_ajaran'],
    semester = json['semester'],
    tipeUjian = json['tipe_ujian'],
    guruQuranId = json['guru_quran_id'],
    nilai = json['nilai'],
    nilaiHuruf = json['nilai_huruf'],
    catatan = json['catatan'],
    lulus = json['lulus'],
    guruQuran = GuruQuran.fromJson(json['guru_quran']);
}

class GuruQuran {
  final int id;
  final int userId;
  final User user;

  GuruQuran({
    required this.id,
    required this.userId,
    required this.user,
  });

  GuruQuran.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    userId = json['user_id'],
    user = User.fromJson(json['user']);
}

class User {
  final int id;
  final String nama;

  User({
    required this.id,
    required this.nama,
  });

  User.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    nama = json['nama'];
}