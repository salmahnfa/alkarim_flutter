class SekolahMutabaahDetailResponse {
  final bool success;
  final List<Data> data;
  final String message;

  SekolahMutabaahDetailResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  SekolahMutabaahDetailResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = (json['data'] as List)
        .map((item) => Data.fromJson(item))
        .toList(),
      message = json['message'];
}

class Data {
  final bool status;
  final bool isLanjut;
  final bool isHadir;
  final bool isWarning;
  final String tipeKelompok;
  final String kehadiran;
  final String tanggal;
  final bool inputSurah;
  final SurahMulai surahMulai;
  final SurahSelesai surahSelesai;
  final int halamanMulai;
  final int halamanSelesai;
  final String guruQuran;
  final String? keterangan;
  final String? catatan;

  Data({
    required this.status,
    required this.isLanjut,
    required this.isHadir,
    required this.isWarning,
    required this.tipeKelompok,
    required this.kehadiran,
    required this.tanggal,
    required this.inputSurah,
    required this.surahMulai,
    required this.surahSelesai,
    required this.halamanMulai,
    required this.halamanSelesai,
    required this.guruQuran,
    required this.keterangan,
    required this.catatan,
  });

  Data.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      isLanjut = json['is_lanjut'],
      isHadir = json['is_hadir'],
      isWarning = json['is_warning'],
      tipeKelompok = json['tipe_kelompok'],
      kehadiran = json['kehadiran'],
      tanggal = json['tanggal'],
      inputSurah = json['input_surah'],
      surahMulai = SurahMulai.fromJson(json['surah_mulai']),
      surahSelesai = SurahSelesai.fromJson(json['surah_selesai']),
      halamanMulai = json['halaman_mulai'],
      halamanSelesai = json['halaman_selesai'],
      guruQuran = json['guru_quran'],
      keterangan = json['keterangan'],
      catatan = json['catatan'] ?? '-';
}

class SurahMulai {
  final int id;
  final int juz;
  final String nama;
  final int ayat;

  SurahMulai({
    required this.id,
    required this.juz,
    required this.nama,
    required this.ayat,
  });

  SurahMulai.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      juz = json['juz'],
      nama = json['nama'],
      ayat = json['ayat'];
}

class SurahSelesai {
  final int id;
  final int juz;
  final String nama;
  final int ayat;

  SurahSelesai({
    required this.id,
    required this.juz,
    required this.nama,
    required this.ayat,
  });

  SurahSelesai.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      juz = json['juz'],
      nama = json['nama'],
      ayat = json['ayat'];
}