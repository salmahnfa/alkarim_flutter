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

  Data({
    required this.id,
    required this.nama
  });

  Data.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      nama = json['nama'];
}