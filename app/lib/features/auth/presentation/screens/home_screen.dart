import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../providers/auth_providers.dart';

/// Kerangka utama setelah login: tiga tab (Belajar, Kamus, Profil).
///
/// Isi tab Belajar dan Kamus akan diisi pada Fitur 3–5. Untuk sekarang
/// hanya tab Profil yang fungsional (FR-004 dasar + logout FR-002).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          _PlaceholderTab(
            icon: Icons.menu_book_outlined,
            title: 'Belajar',
            description:
                'Katalog kosakata BISINDO, video gerakan, kuis, dan progres '
                'belajar akan tampil di sini (Fitur 3 & 4).',
          ),
          _PlaceholderTab(
            icon: Icons.sign_language_outlined,
            title: 'Kamus',
            description:
                'Kamus kata ke isyarat dan sesi speech-to-text akan tampil '
                'di sini (Fitur 5).',
          ),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Belajar',
          ),
          NavigationDestination(
            icon: Icon(Icons.sign_language_outlined),
            selectedIcon: Icon(Icons.sign_language),
            label: 'Kamus',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Segera hadir',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final initial = user.fullName.isEmpty
        ? '?'
        : user.fullName.characters.first.toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                initial,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Center(
            child: Chip(
              avatar: const Icon(Icons.badge_outlined, size: 18),
              label: Text(user.role.label),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit profil'),
            subtitle: const Text('Foto, bio, kebutuhan khusus'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _notYet(context, 'Edit profil'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Persetujuan data'),
            subtitle: const Text('Transkripsi & notifikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _notYet(context, 'Persetujuan data'),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Verifikasi JBI'),
            subtitle: const Text('Unggah sertifikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _notYet(context, 'Verifikasi JBI'),
          ),
          const Divider(),
          if (AppConfig.useMockBackend)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.science_outlined,
                      size: 16, color: theme.hintColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Backend: mode mock (Supabase belum dikonfigurasi)',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _notYet(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature akan tersedia pada fase berikutnya.')),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu masuk kembali untuk menggunakan aplikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
}
