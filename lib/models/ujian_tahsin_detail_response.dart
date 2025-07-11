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
  final String tahunAjaran;
  final String semester;
  final String tipeUjian;
  final int guruQuranId;
  final int pengujiId;
  final int kelancaran;
  final String kelancaranHuruf;
  final int makhroj;
  final String makhrojHuruf;
  final int tajwid;
  final String tajwidHuruf;
  final String? catatan;
  final int lulus;
  final Penguji penguji;

  Data({
    required this.id,
    required this.tahunAjaran,
    required this.semester,
    required this.tipeUjian,
    required this.guruQuranId,
    required this.pengujiId,
    required this.kelancaran,
    required this.kelancaranHuruf,
    required this.makhroj,
    required this.makhrojHuruf,
    required this.tajwid,
    required this.tajwidHuruf,
    required this.catatan,
    required this.lulus,
    required this.penguji,
  });

  Data.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    tahunAjaran = json['tahun_ajaran'],
    semester = json['semester'],
    tipeUjian = json['tipe_ujian'],
    guruQuranId = json['guru_quran_id'],
    pengujiId = json['penguji_id'],
    kelancaran = json['kelancaran'],
    kelancaranHuruf = json['kelancaran_huruf'],
    makhroj = json['makhroj'],
    makhrojHuruf = json['makhroj_huruf'],
    tajwid = json['tajwid'],
    tajwidHuruf = json['tajwid_huruf'],
    catatan = json['catatan'],
    lulus = json['lulus'],
    penguji = Penguji.fromJson(json['penguji']);
}

class Penguji {
  final int id;
  final int userId;
  final User user;

  Penguji({
    required this.id,
    required this.userId,
    required this.user,
  });

  Penguji.fromJson(Map<String, dynamic> json)
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