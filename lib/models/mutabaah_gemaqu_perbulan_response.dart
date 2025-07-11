class MutabaahGemaQuPerbulanResponse {
  final bool success;
  final List<Data> data;
  final String message;

  MutabaahGemaQuPerbulanResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  MutabaahGemaQuPerbulanResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = (json['data'] as List)
          .map((item) => Data.fromJson(item))
          .toList(),
      message = json['message'];
}

class Data {
  final int tanggal;
  final bool murojaah;
  final bool bacaQuran;
  final bool bacaJilid;
  final String tipe;

  Data({
    required this.tanggal,
    required this.murojaah,
    required this.bacaQuran,
    required this.bacaJilid,
    required this.tipe,
  });

  Data.fromJson(Map<String, dynamic> json)
    : tanggal = json['tanggal'],
      murojaah = json['murojaah'],
      bacaQuran = json['tilawah'],
      bacaJilid = json['baca_jilid'],
      tipe = json['tipe'];
}