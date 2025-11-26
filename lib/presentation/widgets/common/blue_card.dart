// lib/presentation/widgets/common/blue_card.dart
import 'package:flutter/material.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';

class BlueCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const BlueCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: child,
      ),
    );
  }
}
