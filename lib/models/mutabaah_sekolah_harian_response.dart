class MutabaahSekolahHarianResponse {
  final bool success;
  final Data data;
  final String message;

  MutabaahSekolahHarianResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  MutabaahSekolahHarianResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      data = Data.fromJson(json['data']),
      message = json['message'];
}

class Data {
  final String tanggal;
  final bool isAsrama;
  final MutabaahSekolah mutabaahSekolah;
  final MutabaahAsrama mutabaahAsrama;

  Data({
    required this.tanggal,
    required this.isAsrama,
    required this.mutabaahSekolah,
    required this.mutabaahAsrama,
  });

  Data.fromJson(Map<String, dynamic> json)
    : tanggal = json['tanggal'],
      isAsrama = json['is_asrama'],
      mutabaahSekolah = MutabaahSekolah.fromJson(json['mutabaah_sekolah']),
      mutabaahAsrama = MutabaahAsrama.fromJson(json['mutabaah_asrama']);
}

class MutabaahSekolah {
  final BacaJilid bacaJilid;
  final Tahfidz tahfidz;
  final Murojaah murojaah;
  final BacaQuran bacaQuran;
  final Talaqqi talaqqi;

  MutabaahSekolah({
    required this.bacaJilid,
    required this.tahfidz,
    required this.murojaah,
    required this.bacaQuran,
    required this.talaqqi,
  });

  MutabaahSekolah.fromJson(Map<String, dynamic> json)
    : bacaJilid = BacaJilid.fromJson(json['baca_jilid']),
      tahfidz = Tahfidz.fromJson(json['tahfidz']),
      murojaah = Murojaah.fromJson(json['murojaah']),
      bacaQuran = BacaQuran.fromJson(json['tahsin']),
      talaqqi = Talaqqi.fromJson(json['talaqqi']);
}

class MutabaahAsrama {
  final BacaJilid bacaJilid;
  final Tahfidz tahfidz;
  final Murojaah murojaah;
  final BacaQuran bacaQuran;
  final Talaqqi talaqqi;

  MutabaahAsrama({
    required this.bacaJilid,
    required this.tahfidz,
    required this.murojaah,
    required this.bacaQuran,
    required this.talaqqi,
  });

  MutabaahAsrama.fromJson(Map<String, dynamic> json)
    : bacaJilid = BacaJilid.fromJson(json['baca_jilid']),
      tahfidz = Tahfidz.fromJson(json['tahfidz']),
      murojaah = Murojaah.fromJson(json['murojaah']),
      bacaQuran = BacaQuran.fromJson(json['tahsin']),
      talaqqi = Talaqqi.fromJson(json['talaqqi']);
}

class BacaJilid {
  final bool status;
  final bool isHadir;
  final bool isWarning;
  final String? kehadiran;
  final String? text;
  final int? id;

  BacaJilid({
    required this.status,
    required this.isHadir,
    required this.isWarning,
    required this.kehadiran,
    required this.text,
    required this.id,
  });

  BacaJilid.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      isHadir = json['is_hadir'],
      isWarning = json['is_warning'],
      kehadiran = json['kehadiran'],
      text = json['text'],
      id = json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '');
}

class Tahfidz {
  final bool status;
  final bool isHadir;
  final bool isWarning;
  final String? kehadiran;
  final String? text;
  final int? id;

  Tahfidz({
    required this.status,
    required this.isHadir,
    required this.isWarning,
    required this.kehadiran,
    required this.text,
    required this.id,
  });

  Tahfidz.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      isHadir = json['is_hadir'],
      isWarning = json['is_warning'],
      kehadiran = json['kehadiran'],
      text = json['text'],
      id = json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '');
}

class Murojaah {
  final bool status;
  final bool isHadir;
  final bool isWarning;
  final String? kehadiran;
  final String? text;
  final int? id;

  Murojaah({
    required this.status,
    required this.isHadir,
    required this.isWarning,
    required this.kehadiran,
    required this.text,
    required this.id,
  });

  Murojaah.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      isHadir = json['is_hadir'],
      isWarning = json['is_warning'],
      kehadiran = json['kehadiran'],
      text = json['text'],
      id = json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '');
}

class BacaQuran {
  final bool status;
  final bool isHadir;
  final bool isWarning;
  final String? kehadiran;
  final String? text;
  final int? id;

  BacaQuran({
    required this.status,
    required this.isHadir,
    required this.isWarning,
    required this.kehadiran,
    required this.text,
    required this.id,
  });

  BacaQuran.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      isHadir = json['is_hadir'],
      isWarning = json['is_warning'],
      kehadiran = json['kehadiran'],
      text = json['text'],
      id = json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '');
}

class Talaqqi {
  final bool status;
  final bool isHadir;
  final bool isWarning;
  final String? kehadiran;
  final String? text;
  final int? id;

  Talaqqi({
    required this.status,
    required this.isHadir,
    required this.isWarning,
    required this.kehadiran,
    required this.text,
    required this.id,
  });

  Talaqqi.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      isHadir = json['is_hadir'],
      isWarning = json['is_warning'],
      kehadiran = json['kehadiran'],
      text = json['text'],
      id = json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '');
}