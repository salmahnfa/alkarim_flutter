class UjianTahfidzResponse {
  final bool success;
  final Data data;
  final String message;

  UjianTahfidzResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  UjianTahfidzResponse.fromJson(Map<String,dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final int id;
  final List<Juzs> juzs;

  Data({
    required this.id,
    required this.juzs,
  });

  Data.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      juzs = (json['juzs'] as List)
        .map((item) => Juzs.fromJson(item))
        .toList();
}

class Juzs {
  final int juz;
  final bool isCompleted;
  final bool inputSurah;
  final int halamanMulai;
  final int halamanSelesai;
  final List<Surahs> surahs;
  final int? nilai;
  final String? nilaiDesimal;
  final String? nilaiHuruf;

  Juzs({
    required this.juz,
    required this.isCompleted,
    required this.inputSurah,
    required this.halamanMulai,
    required this.halamanSelesai,
    required this.surahs,
    required this.nilai,
    required this.nilaiDesimal,
    required this.nilaiHuruf,
  });

  Juzs.fromJson(Map<String, dynamic> json)
    : juz = json['juz'],
      isCompleted = json['is_complete'],
      inputSurah = json['input_surah'],
      halamanMulai = json['halaman_mulai'] ?? 0,
      halamanSelesai = json['halaman_selesai'] ?? 0,
      surahs = (json['surahs'] as List)
        .map((item) => Surahs.fromJson(item))
        .toList(),
      nilai = json['nilai'],
      nilaiDesimal = json['nilai_decimal'],
      nilaiHuruf = json['nilai_huruf'];
}

class Surahs {
  final int id;
  final String nama;
  final int? nilai;
  final String? nilaiDesimal;
  final String? nilaiHuruf;

  Surahs({
    required this.id,
    required this.nama,
    required this.nilai,
    required this.nilaiDesimal,
    required this.nilaiHuruf,
  });

  Surahs.fromJson(Map<String, dynamic> json)
    : id = json['surah_id'],
      nama = json['surah_nama'],
      nilai = json['nilai'],
      nilaiDesimal = json['nilai_decimal'],
      nilaiHuruf = json['nilai_huruf'];
}