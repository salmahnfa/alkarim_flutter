class JuzResponse {
  final bool success;
  final List<Data> data;
  final String message;

  JuzResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  JuzResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = (json['data'] as List)
          .map((item) => Data.fromJson(item))
          .toList(),
      message = json['message'];
}

class Data {
  final String juz;
  final String surah;

  Data({
    required this.juz,
    required this.surah,
  });

  Data.fromJson(Map<String, dynamic> json)
    : juz = json['juz'],
      surah = json['surah'];
}