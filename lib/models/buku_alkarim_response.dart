class BukuAlKarimResponse {
  final bool success;
  final Data data;
  final String message;

  BukuAlKarimResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  BukuAlKarimResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final int id;
  final String nama;
  final String kategori;
  final int posisi;
  final String deskripsi;
  final int jumlahHalaman;
  final String filePath;
  final String? createdAt;
  final String? updatedAt;
  final List<Details> details;

  Data({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.posisi,
    required this.deskripsi,
    required this.jumlahHalaman,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
  });

  Data.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nama = json['nama'],
      kategori = json['kategori'],
      posisi = json['posisi'],
      deskripsi = json['deskripsi'],
      jumlahHalaman = json['jml_hal'],
      filePath = json['file_path'],
      createdAt = json['created_at'],
      updatedAt = json['updated_at'],
      details = List<Details>.from(json['details'].map((x) => Details.fromJson(x)));
}

class Details {
  final int id;
  final int bukuAlKarimId;
  final int halaman;
  final String filePath;
  final String? audio;
  final String createdAt;
  final String updatedAt;

  Details({
    required this.id,
    required this.bukuAlKarimId,
    required this.halaman,
    required this.filePath,
    required this.audio,
    required this.createdAt,
    required this.updatedAt,
  });

  Details.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      bukuAlKarimId = json['buku_alkarim_id'],
      halaman = json['halaman'],
      filePath = json['file_path'],
      audio = json['audio'],
      createdAt = json['created_at'],
      updatedAt = json['updated_at'];
}