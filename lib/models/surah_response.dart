class SurahResponse {
  final bool success;
  final List<Data> data;
  final String message;

  SurahResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  SurahResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = (json['data'] as List)
        .map((item) => Data.fromJson(item))
        .toList(),
      message = json['message'];
}

class Data {
  final int id;
  final String nama;
  final String namaArab;
  final String arti;
  final String tipe;
  final int jumlahAyat;
  final int? juz;
  final int? durasi;
  final String? filePath;

  Data({
    required this.id,
    required this.nama,
    required this.namaArab,
    required this.arti,
    required this.tipe,
    required this.jumlahAyat,
    required this.juz,
    required this.durasi,
    required this.filePath,
  });

  Data.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nama = json['nama'],
      namaArab = json['nama_arab'],
      arti = json['arti'],
      tipe = json['tipe'],
      jumlahAyat = json['jml_ayat'],
      juz = json['juz'],
      durasi = json['durasi'],
      filePath = json['file_path'];
}