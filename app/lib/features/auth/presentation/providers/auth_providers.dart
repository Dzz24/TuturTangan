import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/supabase_bootstrap.dart';
import '../../data/auth_repository.dart';
import '../../data/mock_auth_repository.dart';
import '../../data/models/app_user.dart';
import '../../data/supabase_auth_repository.dart';

/// Status sesi aplikasi.
sealed class AuthState {
  const AuthState();
}

/// Sesi masih dipulihkan saat aplikasi dibuka.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Belum ada sesi aktif.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Ada sesi aktif.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final AppUser user;
}

/// Memilih implementasi repository sesuai ketersediaan kredensial.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (AppConfig.useMockBackend) {
    return MockAuthRepository();
  }
  return SupabaseAuthRepository(supabaseClient);
});

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Mengatur alur autentikasi (FR-001, FR-002, FR-003).
///
/// Metode `signIn`/`signUp` sengaja **tidak** mengubah state menjadi
/// [AuthLoading]; layar yang menampilkan indikator loading sendiri. Dengan
/// begitu router tidak melempar pengguna kembali ke splash saat submit.
class AuthController extends Notifier<AuthState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    Future<void>.microtask(_restoreSession);
    return const AuthLoading();
  }

  Future<void> _restoreSession() async {
    final user = _repository.currentUser;
    state = user == null
        ? const AuthUnauthenticated()
        : AuthAuthenticated(user);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _repository.signIn(email: email, password: password);
    state = AuthAuthenticated(user);
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final user = await _repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
    state = AuthAuthenticated(user);
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthUnauthenticated();
  }

  Future<void> sendPasswordReset(String email) {
    return _repository.sendPasswordReset(email);
  }
}

/// Pengguna yang sedang login, atau `null`.
final currentUserProvider = Provider<AppUser?>((ref) {
  final state = ref.watch(authControllerProvider);
  return state is AuthAuthenticated ? state.user : null;
});
