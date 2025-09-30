class BukuAlKarimJilidResponse {
  final bool success;
  final List<Data> data;
  final String message;

  BukuAlKarimJilidResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  BukuAlKarimJilidResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = (json['data'] as List)
          .map((item) => Data.fromJson(item))
          .toList(),
      message = json['message'];
}

class Data {
  final int id;
  final String nama;
  final String deskripsi;
  final int jumlahHalaman;
  final int jumlahHalamanDilewati;
  final String filePath;

  Data({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.jumlahHalaman,
    required this.jumlahHalamanDilewati,
    required this.filePath,
  });

  Data.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nama = json['nama'],
      deskripsi = json['deskripsi'],
      jumlahHalaman = json['jml_hal'],
      jumlahHalamanDilewati = json['jml_hal_dilewati'],
      filePath = json['file_path'];
}