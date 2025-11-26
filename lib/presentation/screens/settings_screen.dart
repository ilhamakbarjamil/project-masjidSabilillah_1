// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tampilan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<bool>(
              future: LocalStorageService().getTheme(),
              builder: (context, snapshot) {
                final isDark = snapshot.data ?? false;
                return SwitchListTile(
                  title: const Text('Tema Gelap'),
                  value: isDark,
                  onChanged: (bool? value) async {
                    if (value == null) return;
                    await LocalStorageService().saveTheme(value);
                    if (!context.mounted) return;
                    // Refresh seluruh aplikasi
                    context.go('/');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}