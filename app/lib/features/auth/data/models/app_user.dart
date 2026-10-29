/// Peran pengguna, selaras dengan enum `user_role` di PostgreSQL.
enum UserRole {
  pengguna('Pengguna'),
  jbi('JBI'),
  admin('Admin');

  const UserRole(this.label);

  /// Label yang ditampilkan di UI.
  final String label;

  /// Nilai yang disimpan di kolom `users.role`.
  String get dbValue => name;

  static UserRole fromDb(String? value) {
    return switch (value) {
      'jbi' => UserRole.jbi,
      'admin' => UserRole.admin,
      _ => UserRole.pengguna,
    };
  }
}

/// Representasi pengguna yang dipakai lapisan UI.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  final String id;
  final String email;
  final String fullName;
  final UserRole role;

  bool get isAdmin => role == UserRole.admin;
  bool get isJbi => role == UserRole.jbi;

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: (map['email'] as String?) ?? '',
      fullName: (map['full_name'] as String?) ?? '',
      role: UserRole.fromDb(map['role'] as String?),
    );
  }

  AppUser copyWith({
    String? fullName,
    String? email,
    UserRole? role,
  }) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
    );
  }
}
