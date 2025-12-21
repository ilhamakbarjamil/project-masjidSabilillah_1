// lib/core/utils/responsive_helper.dart
import 'package:flutter/material.dart';

/// Helper class untuk menangani responsive design
/// Mengikuti standar Material Design 3 dengan breakpoints
class ResponsiveHelper {
  // Screen breakpoints (Material Design 3)
  static const double mobileWidth = 360;
  static const double tabletWidth = 600;
  static const double desktopWidth = 1200;

  /// Mendapatkan lebar screen
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Mendapatkan tinggi screen
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Cek apakah device adalah mobile
  static bool isMobile(BuildContext context) {
    return getWidth(context) < tabletWidth;
  }

  /// Cek apakah device adalah tablet
  static bool isTablet(BuildContext context) {
    return getWidth(context) >= tabletWidth && getWidth(context) < desktopWidth;
  }

  /// Cek apakah device adalah desktop
  static bool isDesktop(BuildContext context) {
    return getWidth(context) >= desktopWidth;
  }

  /// Mendapatkan device orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Font size responsif - mengikuti Material Design typography
  static double responsiveFontSize(BuildContext context, double baseSize) {
    final width = getWidth(context);
    
    if (width < mobileWidth) {
      return baseSize * 0.85;
    } else if (width < tabletWidth) {
      return baseSize;
    } else if (width < desktopWidth) {
      return baseSize * 1.15;
    } else {
      return baseSize * 1.3;
    }
  }

  /// Padding responsif
  static EdgeInsets responsivePadding(BuildContext context, {
    required double basePadding,
  }) {
    final width = getWidth(context);
    
    if (isMobile(context)) {
      return EdgeInsets.all(basePadding);
    } else if (isTablet(context)) {
      return EdgeInsets.all(basePadding * 1.2);
    } else {
      return EdgeInsets.all(basePadding * 1.5);
    }
  }

  /// Spacing responsif untuk GridView columns
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Max width untuk content
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return getWidth(context) - 32; // 16 padding left + right
    } else if (isTablet(context)) {
      return 600;
    } else {
      return 1000;
    }
  }

  /// Elevated untuk responsive elevation
  static double getResponsiveElevation(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 4;
    } else {
      return 8;
    }
  }
}
