class GemaQuTahfidzResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuTahfidzResponse ({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuTahfidzResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data = Data.fromJson(json['data']),
        message = json['message'];
}

class Data {
  final String tanggal;
  final bool status;
  final String tipeInput;
  final int? juz;
  final String? keteranganJuz;
  final List<Surahs>? surahs;
  final bool inputSurah;
  final int halamanMulai;
  final int halamanSelesai;
  final int surahIdMulai;
  final int ayatMulai;
  final int surahIdSelesai;
  final int ayatSelesai;

  Data ({
    required this.tanggal,
    required this.status,
    required this.tipeInput,
    required this.juz,
    required this.keteranganJuz,
    required this.surahs,
    required this.inputSurah,
    required this.halamanMulai,
    required this.halamanSelesai,
    required this.surahIdMulai,
    required this.ayatMulai,
    required this.surahIdSelesai,
    required this.ayatSelesai,
  });

  Data.fromJson(Map<String, dynamic> json)
      : tanggal = json['tanggal'],
        status = json['status'],
        tipeInput = json['tipe_input'],
        juz = json['juz'],
        keteranganJuz = json['keterangan_juz'],
        surahs = (json['surahs'] as List? ?? [])
            .map((e) => Surahs.fromJson(e))
            .toList(),
        inputSurah = json['input_surah'],
        halamanMulai = json['halaman_mulai'],
        halamanSelesai = json['halaman_selesai'],
        surahIdMulai = json['surah_id_mulai'],
        ayatMulai = json['ayat_mulai'],
        surahIdSelesai = json['surah_id_selesai'],
        ayatSelesai = json['ayat_selesai'];
}

class Surahs {
  final int id;
  final String nama;

  Surahs ({
    required this.id,
    required this.nama,
  });

  Surahs.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nama = json['nama'];
}