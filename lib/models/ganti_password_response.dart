class GantiPasswordResponse {
  final bool success;
  final Data data;
  final String message;

  GantiPasswordResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GantiPasswordResponse.fromJson(Map<String,dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final String token;

  Data({
    required this.token,
  });

  Data.fromJson(Map<String, dynamic> json)
    : token = json['token'] ?? '';
}