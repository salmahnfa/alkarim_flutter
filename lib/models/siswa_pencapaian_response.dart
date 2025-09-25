class SiswaPencapaianResponse {
  final bool success;
  final Data data;
  final String message;

  SiswaPencapaianResponse ({
    required this.success,
    required this.data,
    required this.message,
  });

  SiswaPencapaianResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final bool ziyadahStatus;
  final Ziyadah ziyadah;
  final bool murojaahStatus;
  final String murojaah;
  final bool tilawahStatus;
  final String tilawah;

  Data ({
    required this.ziyadahStatus,
    required this.ziyadah,
    required this.murojaahStatus,
    required this.murojaah,
    required this.tilawahStatus,
    required this.tilawah,
  });

  Data.fromJson(Map<String, dynamic> json)
    : ziyadahStatus = json['ziyadah_status'],
      ziyadah = Ziyadah.fromJson(json['ziyadah']),
      murojaahStatus = json['murojaah_status'],
      murojaah = json['murojaah'],
      tilawahStatus = json['tilawah_status'],
      tilawah = json['tilawah'];
}

class Ziyadah {
  final String surahMulai;
  final int ayatMulai;
  final String surahSelesai;
  final int ayatSelesai;

  Ziyadah ({
    required this.surahMulai,
    required this.ayatMulai,
    required this.surahSelesai,
    required this.ayatSelesai,
  });

  Ziyadah.fromJson(Map<String, dynamic> json)
    : surahMulai = json['surat_mulai'],
      ayatMulai = json['ayat_mulai'],
      surahSelesai = json['surat_selesai'],
      ayatSelesai = json['ayat_selesai'];
}