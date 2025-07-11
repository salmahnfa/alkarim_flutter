class MutabaahGemaQuHarianResponse {
  final bool success;
  final Data data;
  final String message;

  MutabaahGemaQuHarianResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  MutabaahGemaQuHarianResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final String tanggal;
  final BacaQuran bacaQuran;
  final BacaJilid bacaJilid;
  final Tahfidz tahfidz;
  final Murojaah murojaah;

  Data({
    required this.tanggal,
    required this.bacaQuran,
    required this.bacaJilid,
    required this.tahfidz,
    required this.murojaah,
  });

  Data.fromJson(Map<String, dynamic> json)
    : tanggal = json['tanggal'],
      bacaQuran = BacaQuran.fromJson(json['tilawah']),
      bacaJilid = BacaJilid.fromJson(json['baca_jilid']),
      tahfidz = Tahfidz.fromJson(json['tahfidz']),
      murojaah = Murojaah.fromJson(json['murojaah']);
}

class BacaQuran {
  final bool status;
  final String? text;

  BacaQuran({
    required this.status,
    required this.text,
  });

  BacaQuran.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      text = json['text'];
}

class BacaJilid {
  final bool status;
  final String? text;

  BacaJilid({
    required this.status,
    required this.text,
  });

  BacaJilid.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      text = json['text'];
}

class Tahfidz {
  final bool status;
  final String? text;

  Tahfidz({
    required this.status,
    required this.text,
  });

  Tahfidz.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      text = json['text'];
}

class Murojaah {
  final bool status;
  final String? text;

  Murojaah({
    required this.status,
    required this.text,
  });

  Murojaah.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      text = json['text'];
}
