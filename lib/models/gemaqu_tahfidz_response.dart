class GemaQuTahfidzResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuTahfidzResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuTahfidzResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final int qemaquTahfidzId;

  Data({
    required this.qemaquTahfidzId,
  });

  Data.fromJson(Map<String, dynamic> json)
      : qemaquTahfidzId = json['mutabaah_id'];
}