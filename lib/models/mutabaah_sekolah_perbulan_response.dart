class MutabaahSekolahPerbulanResponse {
  final bool success;
  final List<Data> data;
  final String message;

  MutabaahSekolahPerbulanResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  MutabaahSekolahPerbulanResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data = (json['data'] as List)
            .map((item) => Data.fromJson(item))
            .toList(),
        message = json['message'];
}

class Data {
  final int tanggal;
  final Sekolah sekolah;
  final Asrama asrama;
  final String tipe;

  Data({
    required this.tanggal,
    required this.sekolah,
    required this.asrama,
    required this.tipe,
  });

  Data.fromJson(Map<String, dynamic> json)
      : tanggal = json['tanggal'],
        sekolah = Sekolah.fromJson(json['sekolah']),
        asrama = Asrama.fromJson(json['asrama']),
        tipe = json['tipe'];
}

class Sekolah {
  final bool bacaJilid;
  final bool tahfidz;
  final bool murojaah;
  final bool bacaQuran;
  final bool talaqqi;

  Sekolah({
    required this.bacaJilid,
    required this.tahfidz,
    required this.murojaah,
    required this.bacaQuran,
    required this.talaqqi,
  });

  Sekolah.fromJson(Map<String, dynamic> json)
    : bacaJilid = json['tahsin_jilid'],
      tahfidz = json['tahfidz'],
      murojaah = json['murojaah'],
      bacaQuran = json['tahsin_alquran'],
      talaqqi = json['talaqqi'];
}

class Asrama {
  final bool bacaJilid;
  final bool tahfidz;
  final bool murojaah;
  final bool bacaQuran;
  final bool talaqqi;

  Asrama({
    required this.bacaJilid,
    required this.tahfidz,
    required this.murojaah,
    required this.bacaQuran,
    required this.talaqqi,
  });

  Asrama.fromJson(Map<String, dynamic> json)
    : bacaJilid = json['tahsin_jilid'],
      tahfidz = json['tahfidz'],
      murojaah = json['murojaah'],
      bacaQuran = json['tahsin_alquran'],
      talaqqi = json['talaqqi'];
}