class SurahPerayatResponse {
  final bool success;
  final Data data;
  final String message;

  SurahPerayatResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  SurahPerayatResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final Surah surah;
  final List<Murottal> murottal;

  Data({
    required this.surah,
    required this.murottal,
  });

  Data.fromJson(Map<String, dynamic> json)
    : surah = Surah.fromJson(json['surah']),
      murottal = (json['murottal'] as List)
        .map((item) => Murottal.fromJson(item))
        .toList();
}

class Surah {
  final int id;
  final String nama;
  final int jumlahAyat;

  Surah({
    required this.id,
    required this.nama,
    required this.jumlahAyat,
  });

  Surah.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nama = json['nama'],
      jumlahAyat = json['jumlah_ayat'];
}

class Murottal {
  final String ayat;
  final int ayatMulai;
  final int? ayatSelesai;
  final List<String> filePath;

  Murottal({
    required this.ayat,
    required this.ayatMulai,
    required this.ayatSelesai,
    required this.filePath,
  });

  Murottal.fromJson(Map<String, dynamic> json)
    : ayat = json['ayat'],
      ayatMulai = json['ayat_mulai'],
      ayatSelesai = json['ayat_selesai'],
      filePath = List<String>.from(json['file_path']);
}