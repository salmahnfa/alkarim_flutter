class GemaQuMurojaahResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuMurojaahResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuMurojaahResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final int qemaquMurojaahId;

  Data({
    required this.qemaquMurojaahId,
  });

  Data.fromJson(Map<String, dynamic> json)
    : qemaquMurojaahId = json['mutabaah_id'];
}