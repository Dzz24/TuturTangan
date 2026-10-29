/// Konfigurasi aplikasi.
///
/// Kredensial dibaca dari `--dart-define` sehingga tidak pernah ikut
/// ter-commit dan build tidak gagal saat kredensial belum tersedia.
///
/// Menjalankan dengan Supabase:
/// ```
/// flutter run -d edge ^
///   --dart-define=SUPABASE_URL=https://xxx.supabase.co ^
///   --dart-define=SUPABASE_ANON_KEY=eyJ...
/// ```
///
/// Tanpa kedua nilai tersebut aplikasi otomatis memakai backend tiruan
/// (mock) sehingga UI dapat dikembangkan tanpa jaringan.
class AppConfig {
  const AppConfig._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  /// `true` bila kredensial Supabase belum diisi.
  static bool get useMockBackend =>
      supabaseUrl.isEmpty || supabaseAnonKey.isEmpty;
}
