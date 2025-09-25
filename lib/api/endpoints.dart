class Endpoints {
  // login
  static const String login = 'login';

  // version check
  static String versionCheck(String version) => 'check-version/$version';

  // pencapaian
  static const String pencapaian = 'siswa/dashboard2';

  // buku alkarim
  static const String bukuAlKarimJilid = 'buku-alkarim';
  static String bukuAlKarim(int id) => 'buku-alkarim/$id';

  // murottal
  static const String murottalSurahJuz = 'juz?murottal=true';
  static const String murottalAyatJuz = 'murottal-ayat/juz';
  static String surahPerjuz(String juz) => 'surah/$juz';
  static String murottalSurah(String juz) => 'surah/$juz?murottal=true';
  static String murottalAyat(int id) => 'murottal-ayat/surah/$id';

  // asmaul husna & doa belajar
  static const String asmaulHusna = 'asmaul-husna';
  static const String doaBelajar = 'doa-belajar';

  // mutabaah gemaqu
  static const String surah = 'surah';
  static String mutabaahGemaQuPerbulan(int month, int year) => 'siswa/mutabaah/ringkasan-perbulan/$month/$year';
  static String mutabaahGemaQuHarian(int year, int month, int day) => 'siswa/mutabaah/tanggal/$year-$month-$day';
  static String mutabaahGemaQuBacaJilid(String date) => 'siswa/mutabaah/jilid/tanggal/$date';
  static String mutabaahGemaQuBacaQuran(String date) => 'siswa/mutabaah/tilawah/tanggal/$date';
  static String mutabaahGemaQuTahfidz(String date) => 'siswa/mutabaah/tahfidz/tanggal/$date';
  static String mutabaahGemaQuMurojaah(String date) => 'siswa/mutabaah/murojaah/tanggal/$date';
  static const String mutabaahGemaQuBacaJilidSave = 'siswa/mutabaah/jilid/tanggal';
  static const String mutabaahGemaQuBacaQuranSave = 'siswa/mutabaah/tilawah/tanggal';
  static const String mutabaahGemaQuTahfidzSave = 'siswa/mutabaah/tahfidz/tanggal';
  static const String mutabaahGemaQuMurojaahSave = 'siswa/mutabaah/murojaah/tanggal';

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