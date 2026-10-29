import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
// `AuthException` milik Supabase disembunyikan agar tidak bentrok dengan
// AuthException aplikasi (lihat auth_repository.dart).
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import 'auth_repository.dart';
import 'models/app_user.dart';

/// Implementasi autentikasi memakai Supabase Auth (FR-001, FR-002, FR-003).
///
/// Tabel `public.users` diisi otomatis oleh trigger `handle_new_user`
/// (lihat `supabase/migrations/0004_triggers.sql`).
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> get authStateChanges => _client.auth.onAuthStateChange
      .asyncMap((event) => _loadUser(event.session?.user));

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = await _loadUser(response.user);
      if (user == null) {
        throw const AuthException('Akun tidak ditemukan.');
      }

      _currentUser = user;
      await _recordLoginSession(user.id);
      return user;
    } on AuthApiException catch (error) {
      throw AuthException(_translate(error.message));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Gagal masuk. Periksa koneksi internet.');
    }
  }

  @override
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'full_name': fullName.trim(),
          'role': role.dbValue,
        },
      );

      final user = await _loadUser(response.user);
      if (user == null) {
        throw const AuthException(
          'Registrasi berhasil. Silakan periksa email untuk verifikasi.',
        );
      }

      _currentUser = user;
      return user;
    } on AuthApiException catch (error) {
      throw AuthException(_translate(error.message));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Gagal mendaftar. Periksa koneksi internet.');
    }
  }

  @override
  Future<void> signOut() async {
    await _revokeCurrentSession();
    await _client.auth.signOut();
    _currentUser = null;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'tuturtangan://reset-password',
      );
    } on AuthApiException catch (error) {
      throw AuthException(_translate(error.message));
    } catch (_) {
      throw const AuthException('Gagal mengirim tautan reset.');
    }
  }

  // ------------------------------------------------------------- internal

  Future<AppUser?> _loadUser(User? authUser) async {
    if (authUser == null) {
      _currentUser = null;
      return null;
    }

    try {
      final row = await _client
          .from('users')
          .select('id, email, full_name, role')
          .eq('id', authUser.id)
          .maybeSingle();

      if (row != null) {
        final user = AppUser.fromMap(row);
        _currentUser = user;
        return user;
      }
    } catch (_) {
      // Trigger mungkin belum selesai; jatuh ke metadata di bawah.
    }

    final metadata = authUser.userMetadata ?? const <String, dynamic>{};
    final fallback = AppUser(
      id: authUser.id,
      email: authUser.email ?? '',
      fullName: (metadata['full_name'] as String?) ?? authUser.email ?? '',
      role: UserRole.fromDb(metadata['role'] as String?),
    );
    _currentUser = fallback;
    return fallback;
  }

  /// Mencatat sesi login ke `login_sessions` (FR-002).
  ///
  /// Kegagalan pencatatan tidak boleh menggagalkan proses login.
  Future<void> _recordLoginSession(String userId) async {
    final session = _client.auth.currentSession;
    if (session == null) {
      return;
    }

    try {
      await _client.from('login_sessions').insert({
        'user_id': userId,
        'token_hash': sha256.convert(utf8.encode(session.accessToken)).toString(),
        'expires_at': DateTime.fromMillisecondsSinceEpoch(
          session.expiresAt! * 1000,
        ).toUtc().toIso8601String(),
      });
    } catch (_) {
      // Diabaikan dengan sengaja.
    }
  }

  Future<void> _revokeCurrentSession() async {
    final user = _currentUser;
    if (user == null) {
      return;
    }

    try {
      await _client
          .from('login_sessions')
          .update({'is_revoked': true})
          .eq('user_id', user.id)
          .eq('is_revoked', false);
    } catch (_) {
      // Diabaikan dengan sengaja.
    }
  }

  String _translate(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials')) {
      return 'Email atau kata sandi salah.';
    }
    if (lower.contains('already registered') ||
        lower.contains('already exists')) {
      return 'Email sudah digunakan.';
    }
    if (lower.contains('password should be at least')) {
      return 'Kata sandi minimal 8 karakter.';
    }
    if (lower.contains('unable to validate email')) {
      return 'Format email tidak valid.';
    }
    return message;
  }
}
