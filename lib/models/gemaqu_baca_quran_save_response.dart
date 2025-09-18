class GemaQuBacaQuranSaveResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuBacaQuranSaveResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuBacaQuranSaveResponse.fromJson(Map<String, dynamic> json)
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