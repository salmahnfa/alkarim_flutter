class Endpoints {
  // login
  static const String login = 'login';

  // buku alkarim
  static const String bukuAlKarimJilid = 'buku-alkarim';
  static String bukuAlKarim(int id) => 'buku-alkarim/$id';

  // murottal
  static const String murottalSurahJuz = 'juz?murottal=true';
  static const String murottalAyatJuz = 'murottal-ayat/juz';
  static String surah(String juz) => 'surah/$juz';
  static String murottalSurah(String juz) => 'surah/$juz?murottal=true';
  static String murottalAyat(int id) => 'murottal-ayat/surah/$id';

  // asmaul husna & doa belajar
  static const String asmaulHusna = 'asmaul-husna';
  static const String doaBelajar = 'doa-belajar';

  // mutabaah gemaqu
  static String mutabaahGemaQuPerbulan(int month, int year) => 'siswa/mutabaah/ringkasan-perbulan/$month/$year';
  static String mutabaahGemaQuHarian(int year, int month, int day) => 'siswa/mutabaah/tanggal/$year-$month-$day';
  static const String mutabaahGemaQuBacaJilid = 'siswa/mutabaah/jilid/tanggal';
  static const String mutabaahGemaQuBacaQuran = 'siswa/mutabaah/tilawah/tanggal';
  static const String mutabaahGemaQuTahfidz = 'siswa/mutabaah/tahfidz/tanggal';
  static const String mutabaahGemaQuMurojaah = 'siswa/mutabaah/murojaah/tanggal';

  //mutabaah sekolah
  static String mutabaahSekolahPerbulan(int month, int year) => 'siswa/mutabaah/sekolah/ringkasan-perbulan/$month/$year';
  static String mutabaahSekolahHarian(int year, int month, int day) => 'siswa/mutabaah/sekolah/v2/tanggal/$year-$month-$day';
  static String mutabaahSekolahBacaJilidDetail(int id) => 'siswa/mutabaah/sekolah/tahsin/jilid/v2/$id';
  static String mutabaahSekolahBacaQuranDetail(int id) => 'siswa/mutabaah/sekolah/tahsin/alquran/v2/$id';
  static String mutabaahSekolahTahfidzDetail(int id) => 'siswa/mutabaah/sekolah/tahfidz/v2/$id';
  static String mutabaahSekolahMurojaahDetail(int id) => 'siswa/mutabaah/sekolah/murojaah/v2/$id';
  static String mutabaahSekolahTalaqqiDetail(int id) => 'siswa/mutabaah/sekolah/talaqqi/v2/$id';

  // hasil ujian
  static const String ujianNaikJilid = 'siswa/nilai/tahsin_jilid';
  static const String ujianTasmi = 'siswa/nilai/tasmi';
  static const String ujianTahfidz = 'siswa/nilai/tahfidz';
  static const String ujianTahsin = 'siswa/nilai/tahsin';
  static String ujianTahsinDetail(int id) => 'siswa/nilai/tahsin/detail/$id';

  // profil
  static const String profil = 'siswa/profile';
  static const String gantiPassword = 'siswa/change-password';
}