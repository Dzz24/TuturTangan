import 'models/app_user.dart';

/// Kesalahan autentikasi dengan pesan siap tampil ke pengguna.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Kontrak lapisan data autentikasi (FR-001, FR-002, FR-003).
///
/// Dua implementasi tersedia: [MockAuthRepository] untuk pengembangan tanpa
/// jaringan dan `SupabaseAuthRepository` untuk backend sebenarnya.
abstract interface class AuthRepository {
  /// Pengguna yang sedang login, atau `null` bila belum ada sesi.
  AppUser? get currentUser;

  /// Perubahan status sesi (login/logout).
  Stream<AppUser?> get authStateChanges;

  /// FR-002 — masuk dengan email dan kata sandi.
  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  /// FR-001 — daftar akun baru beserta peran.
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  });

  /// FR-002 — mengakhiri sesi.
  Future<void> signOut();

  /// FR-003 — mengirim tautan reset kata sandi.
  Future<void> sendPasswordReset(String email);
}
