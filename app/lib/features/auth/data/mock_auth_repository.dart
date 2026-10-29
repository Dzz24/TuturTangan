import 'dart:async';

import 'auth_repository.dart';
import 'models/app_user.dart';

/// Backend autentikasi tiruan untuk pengembangan tanpa Supabase.
///
/// Akun demo:
///   email    : demo@tuturtangan.id
///   password : demo1234
class MockAuthRepository implements AuthRepository {
  MockAuthRepository() {
    _accounts['demo@tuturtangan.id'] = _MockAccount(
      password: 'demo1234',
      user: const AppUser(
        id: 'mock-user-0001',
        email: 'demo@tuturtangan.id',
        fullName: 'Pengguna Demo',
        role: UserRole.pengguna,
      ),
    );
  }

  static const Duration _latency = Duration(milliseconds: 350);

  final Map<String, _MockAccount> _accounts = {};
  final StreamController<AppUser?> _authChanges =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;
  int _sequence = 1;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> get authStateChanges => _authChanges.stream;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);

    final key = email.trim().toLowerCase();
    final account = _accounts[key];

    if (account == null) {
      throw const AuthException('Email atau kata sandi salah.');
    }
    if (account.password != password) {
      throw const AuthException('Email atau kata sandi salah.');
    }

    _currentUser = account.user;
    _authChanges.add(_currentUser);
    return account.user;
  }

  @override
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future<void>.delayed(_latency);

    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw const AuthException('Email sudah digunakan.');
    }

    final user = AppUser(
      id: 'mock-user-${(_sequence++).toString().padLeft(4, '0')}',
      email: key,
      fullName: fullName.trim(),
      role: role,
    );

    _accounts[key] = _MockAccount(password: password, user: user);
    _currentUser = user;
    _authChanges.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _currentUser = null;
    _authChanges.add(null);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(_latency);
    // Tidak membocorkan apakah email terdaftar atau tidak (FR-003).
  }
}

class _MockAccount {
  const _MockAccount({required this.password, required this.user});

  final String password;
  final AppUser user;
}
