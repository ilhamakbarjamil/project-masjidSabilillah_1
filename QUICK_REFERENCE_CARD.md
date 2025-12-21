# QUICK REFERENCE CARD
## Design Guidelines Implementation Cheatsheet

---

## 🚀 PHASE 1: QUICK WINS (30 menit - 1 jam)

### 1. Enable Material Design 3
**File:** `lib/main.dart`

```dart
// In ThemeData.light()
theme: ThemeData(
  useMaterial3: true,  // ← ADD THIS
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.lightPrimary,
  ),
  textTheme: AppTextTheme.lightTextTheme,  // ← ADD THIS
),
```

### 2. Update Imports di Screens
**Example:** `lib/presentation/screens/home_screen.dart`

```dart
import 'package:masjid_sabilillah/core/utils/responsive_helper.dart';
import 'package:masjid_sabilillah/core/constants/app_text_theme.dart';
```

### 3. Replace Text Hardcoding
```dart
// ❌ OLD
Text('Hello', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))

// ✅ NEW
Text('Hello', style: Theme.of(context).textTheme.displayMedium)
```

---

## 📱 RESPONSIVE DESIGN PATTERNS

### Font Sizes
```dart
// ❌ HARDCODED
fontSize: 24

// ✅ RESPONSIVE
fontSize: ResponsiveHelper.responsiveFontSize(context, 24)
```

### Grid Columns
```dart
// ❌ FIXED
crossAxisCount: 2

// ✅ RESPONSIVE (2 mobile, 3 tablet, 4 desktop)
crossAxisCount: ResponsiveHelper.getGridColumns(context)
```

### Conditional Layout
```dart
if (ResponsiveHelper.isMobile(context)) {
  // Mobile layout
} else if (ResponsiveHelper.isTablet(context)) {
  // Tablet layout
} else {
  // Desktop layout
}
```

### Padding
```dart
// ✅ RESPONSIVE
padding: ResponsiveHelper.responsivePadding(context, basePadding: 24)

// ✅ OR conditional
padding: EdgeInsets.all(
  ResponsiveHelper.isMobile(context) ? 16 : 24
)
```

---

## 🎨 COLOR & THEME USAGE

### Use ColorScheme (NOT hardcoded color)
```dart
// ❌ HARDCODED
backgroundColor: Color(0xFF0D3B66)

// ✅ FROM THEME
backgroundColor: Theme.of(context).colorScheme.primary
```

### Use TextTheme
```dart
// TextTheme hierarchy:
displayLarge      // 32pt - Page titles
displayMedium     // 28pt
displaySmall      // 24pt
headlineLarge     // 24pt - Section headers
headlineMedium    // 20pt
headlineSmall     // 18pt
titleLarge        // 18pt - Card titles
titleMedium       // 16pt
titleSmall        // 14pt
bodyLarge         // 16pt - Regular text
bodyMedium        // 14pt
bodySmall         // 12pt
labelLarge        // 14pt - Buttons
labelMedium       // 12pt - Labels
labelSmall        // 10pt - Captions
```

---

## ♿ ACCESSIBILITY QUICK FIXES

### Add Tooltip to Icons
```dart
// ❌ NO LABEL
Icon(PhosphorIconsFill.gearSix)

// ✅ WITH TOOLTIP
Tooltip(
  message: 'Buka pengaturan',
  child: Icon(PhosphorIconsFill.gearSix),
)
```

### Add Semantic Label
```dart
// ✅ ACCESSIBLE
Semantics(
  label: 'Jadwal sholat berikutnya',
  child: Container(...),
)
```

### Use AccessibleCard
```dart
// From lib/core/widgets/accessibility_widgets.dart
AccessibleCard(
  semanticLabel: 'Prayer times card',
  child: Column(...),
)
```

### Check Color Contrast
```dart
// Use ColorContrastChecker
final isCompliant = ColorContrastChecker.isWCAG_AA_Compliant(
  Colors.black87,
  Colors.white,
); // Minimum 4.5:1
```

---

## 🔄 COMMON REPLACEMENTS TABLE

| OLD (❌) | NEW (✅) |
|---------|---------|
| `fontSize: 24` | `ResponsiveHelper.responsiveFontSize(context, 24)` |
| `padding: const EdgeInsets.all(20)` | `ResponsiveHelper.responsivePadding(context, basePadding: 20)` |
| `crossAxisCount: 2` | `ResponsiveHelper.getGridColumns(context)` |
| `color: primaryColor` | `Theme.of(context).colorScheme.primary` |
| `TextStyle(fontSize: 16)` | `Theme.of(context).textTheme.bodyLarge` |
| `Icon(icon)` | `Tooltip(message: '...', child: Icon(icon))` |
| `Container(...)` | `Card(child: Container(...))` |
| `Container(elevation: ...)` | (Gunakan Card sebagai ganti) |

---

## 🧪 TESTING QUICK CHECKS

```bash
# Analyze
dart analyze lib/

# Run
flutter run

# Test responsive (Chrome window resizing)
flutter run -d chrome

# Check accessibility
# Enable TalkBack (Android) atau VoiceOver (iOS)
```

---

## 📋 BEFORE COMMITTING CHECKLIST

- [ ] `dart analyze lib/` returns 0 issues
- [ ] `flutter run` builds successfully
- [ ] Tested di mobile size (360px width)
- [ ] Tested di tablet size (768px width)
- [ ] Tested di dark mode
- [ ] Tested di light mode
- [ ] All icon buttons have tooltips
- [ ] No hardcoded font sizes (use theme)
- [ ] No hardcoded colors (use colorScheme)
- [ ] Color contrast checked (4.5:1 minimum)

---

## 🎯 FILE MODIFICATIONS PRIORITY

### Phase 1 (Week 1)
```
1. lib/main.dart
   - Enable useMaterial3
   - Add ColorScheme.fromSeed()
   - Add AppTextTheme
   
2. lib/core/utils/responsive_helper.dart
   - (Already created - just ensure it's there)
   
3. lib/core/constants/app_text_theme.dart
   - (Already created - just ensure it's there)
```

### Phase 2 (Week 1-2)
```
4. lib/presentation/screens/home_screen.dart
   - Replace hardcoded sizes
   - Use ResponsiveHelper
   - Use Theme colors
   - Add tooltips
   
5. lib/presentation/screens/prayer_times_screen.dart
   - Same as home_screen
   
6. lib/presentation/screens/settings_screen.dart
   - Same as home_screen
```

### Phase 3 (Week 2)
```
7. Other screens
   - login_screen.dart
   - signup_screen.dart
   - splash_screen.dart
```

---

## 🔗 USEFUL METHODS (Copy-Paste Ready)

### Responsive Height
```dart
SliverAppBar(
  expandedHeight: ResponsiveHelper.getHeight(context) * 0.25,
)
```

### Responsive MaxWidth
```dart
SizedBox(
  width: ResponsiveHelper.getMaxContentWidth(context),
  child: Column(...),
)
```

### Device Detection
```dart
if (ResponsiveHelper.isMobile(context)) {
  // Show mobile layout
} else if (ResponsiveHelper.isTablet(context)) {
  // Show tablet layout
}
```

### Responsive Elevation
```dart
Card(
  elevation: ResponsiveHelper.getResponsiveElevation(context),
  child: ...,
)
```

---

## ⚡ PERFORMANCE TIPS

1. **Don't call ResponsiveHelper multiple times**
   ```dart
   // ❌ INEFFICIENT
   build() {
     return Column(
       children: [
         Text(style: TextStyle(fontSize: ResponsiveHelper.responsiveFontSize(...))),
         Text(style: TextStyle(fontSize: ResponsiveHelper.responsiveFontSize(...))),
       ],
     );
   }
   
   // ✅ BETTER
   build() {
     final fontSize = ResponsiveHelper.responsiveFontSize(context, 16);
     return Column(
       children: [
         Text(style: TextStyle(fontSize: fontSize)),
         Text(style: TextStyle(fontSize: fontSize)),
       ],
     );
   }
   ```

2. **Use Theme references instead of creating TextStyle**
   ```dart
   // ❌ Creates new TextStyle
   TextStyle(fontSize: 16, color: Colors.black87)
   
   // ✅ Uses cached theme
   Theme.of(context).textTheme.bodyLarge
   ```

3. **Cache ColorScheme if used multiple times**
   ```dart
   final colorScheme = Theme.of(context).colorScheme;
   // Then use colorScheme.primary instead of calling Theme.of() again
   ```

---

## 📚 QUICK REFERENCE LINKS

**In this project:**
- `DESIGN_COMPLIANCE_SUMMARY.md` - Overall status
- `DESIGN_GUIDELINES_ANALYSIS.md` - Detailed analysis
- `IMPLEMENTATION_PLAN.md` - Full roadmap
- `BEFORE_AFTER_EXAMPLE.md` - Code examples
- `lib/core/utils/responsive_helper.dart` - Responsive methods
- `lib/core/constants/app_text_theme.dart` - Typography definition
- `lib/core/widgets/accessibility_widgets.dart` - Accessible components

**External:**
- [Material Design 3](https://material.io/design)
- [Flutter Material](https://flutter.dev/docs/cookbook/design/themes)
- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [Color Contrast](https://webaim.org/articles/contrast/)

---

## 💡 GOLDEN RULES

1. **Always use Theme, never hardcode colors**
2. **Always use ResponsiveHelper for sizes**
3. **Always use TextTheme for font styles**
4. **Always add Tooltip/Semantics for accessibility**
5. **Always test on multiple screen sizes**
6. **Always test dark and light modes**
7. **Always check color contrast (4.5:1 minimum)**

---

**Last Updated:** 22 Desember 2025  
**Version:** 1.0  
**Status:** Ready to Use

