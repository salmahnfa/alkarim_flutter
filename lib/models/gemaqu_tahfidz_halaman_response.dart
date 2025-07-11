class GemaQuTahfidzHalamanResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuTahfidzHalamanResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuTahfidzHalamanResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data = Data.fromJson(json['data']),
        message = json['message'];
}

class Data {
  final int qemaquTahfidzHalamanId;

  Data({
    required this.qemaquTahfidzHalamanId,
  });

  Data.fromJson(Map<String, dynamic> json)
      : qemaquTahfidzHalamanId = json['mutabaah_id'];
}