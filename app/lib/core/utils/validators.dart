/// Validator input yang dipakai lintas fitur.
///
/// Aturan mengikuti FR-001: email harus valid dan kata sandi minimal
/// 8 karakter.
class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Email wajib diisi.';
    }
    if (!_emailPattern.hasMatch(input)) {
      return 'Format email tidak valid.';
    }
    return null;
  }

  static String? password(String? value) {
    final input = value ?? '';
    if (input.isEmpty) {
      return 'Kata sandi wajib diisi.';
    }
    if (input.length < 8) {
      return 'Kata sandi minimal 8 karakter.';
    }
    return null;
  }

  static String? requiredText(String? value, {String label = 'Kolom'}) {
    if ((value?.trim() ?? '').isEmpty) {
      return '$label wajib diisi.';
    }
    return null;
  }
}
