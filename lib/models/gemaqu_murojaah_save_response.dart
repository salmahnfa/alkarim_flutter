class GemaQuMurojaahSaveResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuMurojaahSaveResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuMurojaahSaveResponse.fromJson(Map<String, dynamic> json)
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