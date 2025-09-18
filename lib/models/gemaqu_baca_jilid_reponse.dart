class GemaQuBacaJilidResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuBacaJilidResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuBacaJilidResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final String tanggal;
  final bool status;
  final int halamanMulai;
  final int halamanSelesai;
  final int jumlahHalaman;
  final String bukuAlKarim;
  int? bukuAlKarimId;

  Data({
    required this.tanggal,
    required this.status,
    required this.halamanMulai,
    required this.halamanSelesai,
    required this.jumlahHalaman,
    required this.bukuAlKarim,
    this.bukuAlKarimId,
  });

  Data.fromJson(Map<String, dynamic> json)
    : tanggal = json['tanggal'],
      status = json['status'],
      halamanMulai = json['halaman_mulai'],
      halamanSelesai = json['halaman_selesai'],
      jumlahHalaman = json['jumlah_halaman'],
      bukuAlKarim = json['buku_alkarim'],
      bukuAlKarimId = json['buku_alkarim_id'];
}