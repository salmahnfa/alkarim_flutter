class GemaQuTahfidzSaveResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuTahfidzSaveResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuTahfidzSaveResponse.fromJson(Map<String, dynamic> json)
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