class AsmaulHusnaResponse {
  final bool success;
  final Data data;
  final String message;

  AsmaulHusnaResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  AsmaulHusnaResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data = Data.fromJson(json['data']),
        message = json['message'];
}

class Data {
  final String file;
  final String? audio;

  Data({
    required this.file,
    required this.audio,
  });

  Data.fromJson(Map<String, dynamic> json)
      : file = json['file'],
        audio = json['audio'];
}