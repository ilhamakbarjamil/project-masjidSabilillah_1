// Add this button to any screen to access notification test screen
// Example: Add to HomeScreen, SettingsScreen, or create a debug menu

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationTestButton extends StatelessWidget {
  const NotificationTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Get.toNamed('/notification-test'),
      icon: const Icon(Icons.notifications),
      label: const Text('🔔 Test Notifikasi'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
    );
  }
}

// Or simple text button:
class NotificationTestTextButton extends StatelessWidget {
  const NotificationTestTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.toNamed('/notification-test'),
      child: const Text('Test Notifikasi'),
    );
  }
}

// Or simple button in a list:
ListTile(
  title: const Text('Tes Notifikasi Sholat'),
  subtitle: const Text('Test notifikasi prayer time'),
  trailing: const Icon(Icons.arrow_forward_ios),
  onTap: () => Get.toNamed('/notification-test'),
)

// Usage in HomeScreen:
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: ListView(
      children: [
        // ... other widgets ...
        
        // Add notification test button
        Padding(
          padding: const EdgeInsets.all(16),
          child: NotificationTestButton(),
        ),
        
        // ... more widgets ...
      ],
    ),
  );
}
