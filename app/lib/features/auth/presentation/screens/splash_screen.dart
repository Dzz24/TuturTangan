import 'package:flutter/material.dart';

/// Layar pembuka: menampilkan logo selagi sesi dipulihkan.
///
/// Router akan memindahkan pengguna ke `/login` atau `/home` setelah
/// [AuthState] selesai dimuat.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sign_language,
              size: 96,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('TuturTangan', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Komunikasi & pembelajaran BISINDO',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
