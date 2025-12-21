// lib/core/widgets/accessible_card.dart
import 'package:flutter/material.dart';

/// Widget Card yang accessible dengan semantic labels
/// Mengikuti WCAG 2.1 guidelines
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final double elevation;

  const AccessibleCard({
    Key? key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.backgroundColor,
    this.elevation = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      enabled: onTap != null,
      button: onTap != null,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          backgroundColor: backgroundColor,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

// lib/core/widgets/accessible_icon_button.dart
import 'package:flutter/material.dart';

/// IconButton yang accessible dengan tooltip dan semantic label
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String semanticLabel;
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  const AccessibleIconButton({
    Key? key,
    required this.icon,
    required this.tooltip,
    required this.semanticLabel,
    required this.onPressed,
    this.color,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      enabled: true,
      button: true,
      onTap: onPressed,
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          icon: Icon(icon, size: size),
          color: color,
          onPressed: onPressed,
          tooltip: tooltip,
        ),
      ),
    );
  }
}

// lib/core/widgets/accessible_text.dart
import 'package:flutter/material.dart';

/// Text widget dengan semantic label untuk accessibility
class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? semanticLabel;

  const AccessibleText(
    this.text, {
    Key? key,
    this.style,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      enabled: true,
      child: Text(
        text,
        style: style,
        // Ensure minimum text size for accessibility
        semanticsLabel: semanticLabel,
      ),
    );
  }
}

// lib/core/widgets/color_contrast_checker.dart
import 'package:flutter/material.dart';

/// Helper class untuk check color contrast ratio
/// Mengikuti WCAG 2.1 AA/AAA standards
class ColorContrastChecker {
  /// Hitung contrast ratio antara dua warna
  /// Reference: https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio
  static double getContrastRatio(Color color1, Color color2) {
    final luminance1 = _getRelativeLuminance(color1);
    final luminance2 = _getRelativeLuminance(color2);
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Hitung relative luminance dari color
  static double _getRelativeLuminance(Color color) {
    final r = _linearize(color.red / 255);
    final g = _linearize(color.green / 255);
    final b = _linearize(color.blue / 255);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearize RGB value
  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    } else {
      return ((value + 0.055) / 1.055) * ((value + 0.055) / 1.055);
    }
  }

  /// Check apakah contrast ratio memenuhi WCAG AA standard (4.5:1)
  static bool isWCAG_AA_Compliant(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 4.5;
  }

  /// Check apakah contrast ratio memenuhi WCAG AAA standard (7:1)
  static bool isWCAG_AAA_Compliant(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 7.0;
  }

  /// Get recommended text color (black or white) untuk background tertentu
  static Color getRecommendedTextColor(Color backgroundColor) {
    final luminance = _getRelativeLuminance(backgroundColor);
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
