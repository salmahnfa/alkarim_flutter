class GemaQuBacaQuranResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuBacaQuranResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuBacaQuranResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final int qemaquBacaQuranId;

  Data({
    required this.qemaquBacaQuranId,
  });

  Data.fromJson(Map<String, dynamic> json)
    : qemaquBacaQuranId = json['mutabaah_tilawah_id'];
}