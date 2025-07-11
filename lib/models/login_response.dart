class LoginResponse {
  final bool success;
  final Data data;
  final String message;

  LoginResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  LoginResponse.fromJson(Map<String,dynamic> json)
     : success = json['success'],
       data = Data.fromJson(json['data']),
       message = json['message'];
}

class Data {
  final String token;
  final Siswa siswa;

  Data({
    required this.token,
    required this.siswa,
  });

  Data.fromJson(Map<String, dynamic> json)
     : token = json['token'],
       siswa = Siswa.fromJson(json['siswa']);
}

class Siswa {
  final int siswaId;
  final String nama;
  final String email;
  final String program;
  final bool isAsrama;

  Siswa({
    required this.siswaId,
    required this.nama,
    required this.email,
    required this.program,
    required this.isAsrama,
  });

  Siswa.fromJson(Map<String, dynamic> json)
    : siswaId = json['siswa_id'],
      nama = json['nama'],
      email = json['email'],
      program = json['program'],
      isAsrama = json['is_asrama'];
}