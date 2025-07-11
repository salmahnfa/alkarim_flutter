class GemaQuBacaJilidResponse {
  final bool success;
  final Data data;
  final String message;

  GemaQuBacaJilidResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  GemaQuBacaJilidResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final int qemaquBacaJilidId;

  Data({
    required this.qemaquBacaJilidId,
  });

  Data.fromJson(Map<String, dynamic> json)
    : qemaquBacaJilidId = json['mutabaah_jilid_id'];
}