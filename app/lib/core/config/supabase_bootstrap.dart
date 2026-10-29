import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_config.dart';

/// Inisialisasi Supabase sekali saat aplikasi dimulai.
///
/// Bila kredensial belum tersedia (mode mock), fungsi ini tidak melakukan
/// apa pun dan `Supabase.instance` tidak boleh dipakai.
Future<void> initSupabase() async {
  if (AppConfig.useMockBackend) {
    return;
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    // Supabase kini menyebut "anon key" sebagai "publishable key".
    publishableKey: AppConfig.supabaseAnonKey,
  );
}

/// Akses client Supabase. Hanya valid ketika [AppConfig.useMockBackend] false.
SupabaseClient get supabaseClient => Supabase.instance.client;
