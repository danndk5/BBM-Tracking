

class AppStrings {
  // App Info
  static const String appName = 'BBM Tracking';
  static const String appVersion = '1.0.0';
  
  // Auth
  static const String login = 'Login';
  static const String noPekerja = 'Nomor Pekerja';
  static const String password = 'Password';
  static const String loginSuccess = 'Login berhasil';
  static const String loginFailed = 'Login gagal';
  static const String logout = 'Logout';
  
  // Trip
  static const String createTrip = 'Buat Trip Baru';
  static const String namaDriver = 'Nama Driver / Awak 1';
  static const String namaAwak2 = 'Nama Awak 2';
  static const String nomorKendaraan = 'Nomor Kendaraan';
  static const String spbuTujuan = 'SPBU Tujuan';
  static const String pilihSPBU = 'Pilih SPBU';
  
  // Delivery Status
  static const String berangkat = 'Berangkat';
  static const String sudahTiba = 'Sudah Tiba';
  static const String mulaiBongkar = 'Mulai Pembongkaran';
  static const String selesaiBongkar = 'Selesai Pembongkaran';
  static const String pulang = 'Pulang';
  static const String lanjutSPBU = 'Lanjut ke SPBU Berikutnya';
  
  // Messages
  static const String konfirmasiBerangkat = 'Konfirmasi berangkat?';
  static const String konfirmasiTiba = 'Konfirmasi sudah tiba di SPBU?';
  static const String konfirmasiMulaiBongkar = 'Mulai pembongkaran sekarang?';
  static const String konfirmasiSelesaiBongkar = 'Pembongkaran selesai?';
  static const String konfirmasiPulang = 'Konfirmasi selesai dan pulang?';
  
  // GPS
  static const String gpsAktif = 'GPS Aktif';
  static const String gpsTidakAktif = 'GPS Tidak Aktif';
  static const String aktifkanGPS = 'Aktifkan GPS';
  static const String lokasiTidakValid = 'Lokasi tidak valid, pastikan Anda di SPBU tujuan';
  
  // Sync
  static const String syncBerhasil = 'Data berhasil disinkronkan';
  static const String syncGagal = 'Gagal sinkronisasi data';
  static const String menungguSync = 'Menunggu sinkronisasi...';
  static const String dataOffline = 'Data tersimpan offline';
  
  // Errors
  static const String errorNetwork = 'Tidak ada koneksi internet';
  static const String errorServer = 'Server error, coba lagi nanti';
  static const String errorUnknown = 'Terjadi kesalahan';
  static const String fieldRequired = 'Field ini wajib diisi';
  
  // Dialog
  static const String ya = 'Ya';
  static const String tidak = 'Tidak';
  static const String ok = 'OK';
  static const String batal = 'Batal';
  static const String simpan = 'Simpan';
}