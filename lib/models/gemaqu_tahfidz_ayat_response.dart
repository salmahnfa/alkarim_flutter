class GemaQuTahfidzAyatResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuTahfidzAyatResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuTahfidzAyatResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data = Data.fromJson(json['data']),
        message = json['message'];
}

class Data {
  final int qemaquTahfidzAyatId;

  Data({
    required this.qemaquTahfidzAyatId,
  });

  Data.fromJson(Map<String, dynamic> json)
      : qemaquTahfidzAyatId = json['mutabaah_id'];
}