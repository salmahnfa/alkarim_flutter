class UjianNaikJilidResponse {
  final bool success;
  final Data data;
  final String message;

  UjianNaikJilidResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  UjianNaikJilidResponse.fromJson(Map<String,dynamic> json)
  : success = json['success'],
    data = Data.fromJson(json['data']),
    message = json['message'];
}

class Data {
  final int currentPage;
  final List<DataList> data;
  final String firstPageUrl;
  final int from;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String prevPageUrl;
  final int to;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
  });

  Data.fromJson(Map<String, dynamic> json)
  : currentPage = json['current_page'],
    data = (json['data'] as List)
      .map((item) => DataList.fromJson(item))
      .toList(),
    firstPageUrl = json['first_page_url'] ?? '',
    from = json['from'],
    nextPageUrl = json['next_page_url'] ?? '',
    path = json['path'],
    perPage = json['per_page'],
    prevPageUrl = json['prev_page_url'] ?? '',
    to = json['to'];
}

class DataList {
  final int id;
  final String tanggalUjian;
  final int guruQuranId;
  final int pengujiId;
  final Penguji penguji;
  final int tahsinLevelId;
  final String nilai;
  final String nilaiHuruf;
  final String? catatan;
  final int lulus;
  final TahsinLevel tahsinLevel;

  DataList({
    required this.id,
    required this.tanggalUjian,
    required this.guruQuranId,
    required this.pengujiId,
    required this.penguji,
    required this.tahsinLevelId,
    required this.nilai,
    required this.nilaiHuruf,
    required this.catatan,
    required this.lulus,
    required this.tahsinLevel,
  });

  DataList.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    tanggalUjian = json['tanggal_ujian'],
    guruQuranId = json['guru_quran_id'],
    pengujiId = json['penguji_id'],
    penguji = Penguji.fromJson(json['penguji']),
    tahsinLevelId = json['tahsin_level_id'],
    nilai = json['nilai'],
    nilaiHuruf = json['nilai_huruf'],
    catatan = json['catatan'],
    lulus = json['lulus'],
    tahsinLevel = TahsinLevel.fromJson(json['tahsin_level']);
}

class Penguji {
  final int id;
  final int userId;
  final User user;

  Penguji({
    required this.id,
    required this.userId,
    required this.user,
  });

  Penguji.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    userId = json['user_id'],
    user = User.fromJson(json['user']);
}

class User {
  final int id;
  final String nama;

  User({
    required this.id,
    required this.nama,
  });

  User.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    nama = json['nama'];
}

class TahsinLevel {
  final int id;
  final String nama;

  TahsinLevel({
    required this.id,
    required this.nama,
  });

  TahsinLevel.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    nama = json['nama'];
}