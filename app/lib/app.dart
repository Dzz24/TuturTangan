import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget aplikasi TuturTangan.
///
/// Navigasi ditangani `go_router` lewat [routerProvider]; penjagaan sesi
/// (belum login, sudah login, sesi dipulihkan) ada di `redirect`.
class TuturTanganApp extends ConsumerWidget {
  const TuturTanganApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'TuturTangan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
