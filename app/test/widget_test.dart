import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuturtangan/core/utils/validators.dart';
import 'package:tuturtangan/features/auth/presentation/screens/login_screen.dart';

void main() {
  group('Validators', () {
    test('email kosong ditolak', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('email tidak valid ditolak', () {
      expect(Validators.email('bukan-email'), isNotNull);
      expect(Validators.email('a@b'), isNotNull);
    });

    test('email valid diterima', () {
      expect(Validators.email('demo@tuturtangan.id'), isNull);
      expect(Validators.email('  nama@email.com  '), isNull);
    });

    test('kata sandi kurang dari 8 karakter ditolak', () {
      expect(Validators.password('1234567'), isNotNull);
    });

    test('kata sandi 8 karakter atau lebih diterima', () {
      expect(Validators.password('demo1234'), isNull);
    });
  });

  testWidgets('layar login menampilkan kolom email dan tombol masuk',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Masuk ke TuturTangan'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Kata sandi'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Masuk'), findsOneWidget);
  });
}
