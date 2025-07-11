class UjianTahsinResponse {
  final bool success;
  final Data data;
  final String message;

  UjianTahsinResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  UjianTahsinResponse.fromJson(Map<String, dynamic> json)
  : success = json['success'],
    data = Data.fromJson(json['data']),
    message = json['message'];
}

class Data {
  final String tahunAjaran;
  final NilaiPtsGasal? nilaiPtsGasal;
  final NilaiPasGasal? nilaiPasGasal;
  final NilaiPtsGenap? nilaiPtsGenap;
  final NilaiPasGenap? nilaiPasGenap;

  Data({
    required this.tahunAjaran,
    required this.nilaiPtsGasal,
    required this.nilaiPasGasal,
    required this.nilaiPtsGenap,
    required this.nilaiPasGenap,
  });

  Data.fromJson(Map<String, dynamic> json)
  : tahunAjaran = json['tahun_ajaran'],
    nilaiPtsGasal = json['nilai_pts_gasal'] != null
      ? NilaiPtsGasal.fromJson(json['nilai_pts_gasal'])
      : null,
    nilaiPasGasal = json['nilai_pas_gasal'] != null
      ? NilaiPasGasal.fromJson(json['nilai_pas_gasal'])
      : null,
    nilaiPtsGenap = json['nilai_pts_genap'] != null
      ? NilaiPtsGenap.fromJson(json['nilai_pts_genap'])
      : null,
    nilaiPasGenap = json['nilai_pas_genap'] != null
      ? NilaiPasGenap.fromJson(json['nilai_pas_genap'])
      : null;
}

class NilaiPtsGasal {
  final int id;
  final String tahunAjaran;
  final String semester;
  final String tipeUjian;
  final int guruQuranId;
  final int pengujiId;

  NilaiPtsGasal({
    required this.id,
    required this.tahunAjaran,
    required this.semester,
    required this.tipeUjian,
    required this.guruQuranId,
    required this.pengujiId,
  });

  NilaiPtsGasal.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    tahunAjaran = json['tahun_ajaran'],
    semester = json['semester'],
    tipeUjian = json['tipe_ujian'],
    guruQuranId = json['guru_quran_id'],
    pengujiId = json['penguji_id'];
}

class NilaiPasGasal {
  final int id;
  final String tahunAjaran;
  final String semester;
  final String tipeUjian;
  final int guruQuranId;
  final int pengujiId;

  NilaiPasGasal({
    required this.id,
    required this.tahunAjaran,
    required this.semester,
    required this.tipeUjian,
    required this.guruQuranId,
    required this.pengujiId,
  });

  NilaiPasGasal.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    tahunAjaran = json['tahun_ajaran'],
    semester = json['semester'],
    tipeUjian = json['tipe_ujian'],
    guruQuranId = json['guru_quran_id'],
    pengujiId = json['penguji_id'];
}

class NilaiPtsGenap {
  final int id;
  final String tahunAjaran;
  final String semester;
  final String tipeUjian;
  final int guruQuranId;
  final int pengujiId;

  NilaiPtsGenap({
    required this.id,
    required this.tahunAjaran,
    required this.semester,
    required this.tipeUjian,
    required this.guruQuranId,
    required this.pengujiId,
  });

  NilaiPtsGenap.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    tahunAjaran = json['tahun_ajaran'],
    semester = json['semester'],
    tipeUjian = json['tipe_ujian'],
    guruQuranId = json['guru_quran_id'],
    pengujiId = json['penguji_id'];
}

class NilaiPasGenap {
  final int id;
  final String tahunAjaran;
  final String semester;
  final String tipeUjian;
  final int guruQuranId;
  final int pengujiId;

  NilaiPasGenap({
    required this.id,
    required this.tahunAjaran,
    required this.semester,
    required this.tipeUjian,
    required this.guruQuranId,
    required this.pengujiId,
  });

  NilaiPasGenap.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    tahunAjaran = json['tahun_ajaran'],
    semester = json['semester'],
    tipeUjian = json['tipe_ujian'],
    guruQuranId = json['guru_quran_id'],
    pengujiId = json['penguji_id'];
}