class SekolahBacaJilidDetailResponse {
  final bool success;
  final List<Data> data;
  final String message;

  SekolahBacaJilidDetailResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  SekolahBacaJilidDetailResponse.fromJson(Map<String, dynamic> json)
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
  final String buku;
  final int? halamanMulai;
  final int? halamanSelesai;
  final String guruQuran;
  final String? keterangan;
  final String? catatan;

  Data({
    required this.status,
    required this.isLanjut,
    required this.isHadir,
    required this.isWarning,
    required this.kehadiran,
    required this.tipeKelompok,
    required this.tanggal,
    required this.buku,
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
      kehadiran = json['kehadiran'],
      tipeKelompok = json['tipe_kelompok'],
      tanggal = json['tanggal'],
      buku = json['buku'],
      halamanMulai = json['halaman_mulai'],
      halamanSelesai = json['halaman_selesai'],
      guruQuran = json['guru_quran'],
      keterangan = json['keterangan'],
      catatan = json['catatan'] ?? '-';
}