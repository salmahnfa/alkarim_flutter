class GemaQuBacaQuranResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuBacaQuranResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuBacaQuranResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final String tanggal;
  final bool status;
  final String? tipeInput;
  final int halamanMulai;
  final int halamanSelesai;
  final int? jumlahHalaman;
  final int? surahIdMulai;
  final String? surahMulai;
  final int? ayatMulai;
  final int? surahIdSelesai;
  final String? surahSelesai;
  final int? ayatSelesai;
  final String? bukuAlKarim;

  Data({
    required this.tanggal,
    required this.status,
    required this.tipeInput,
    required this.halamanMulai,
    required this.halamanSelesai,
    required this.jumlahHalaman,
    required this.surahIdMulai,
    required this.surahMulai,
    required this.ayatMulai,
    required this.surahIdSelesai,
    required this.surahSelesai,
    required this.ayatSelesai,
    required this.bukuAlKarim,
  });

  Data.fromJson(Map<String, dynamic> json)
    : tanggal = json['tanggal'],
      status = json['status'],
      tipeInput = json['tipe_input'],
      halamanMulai = json['halaman_mulai'],
      halamanSelesai = json['halaman_selesai'],
      jumlahHalaman = json['jumlah_halaman'],
      surahIdMulai = json['surah_id_mulai'],
      surahMulai = json['surah_mulai'],
      ayatMulai = json['ayat_mulai'],
      surahIdSelesai = json['surah_id_selesai'],
      surahSelesai = json['surah_selesai'],
      ayatSelesai = json['ayat_selesai'],
      bukuAlKarim = json['buku_alkarim'];
}