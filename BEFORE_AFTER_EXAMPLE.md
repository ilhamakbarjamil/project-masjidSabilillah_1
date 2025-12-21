# CONTOH IMPLEMENTASI: home_screen.dart Update
## Sebelum vs Sesudah (Before vs After)

---

## ❌ BEFORE (Current Implementation)

```dart
// Bagian 1: Text dengan hardcoded font size
Text(
  _userName ?? 'Hamba Allah',
  style: const TextStyle(
    color: Colors.white,
    fontSize: 26,  // ❌ Fixed size, tidak responsive
    fontWeight: FontWeight.bold,
  ),
)

// Bagian 2: Padding dengan fixed value
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24.0),  // ❌ Same untuk semua device
  child: Column(...)
)

// Bagian 3: GridView dengan fixed columns
GridView.count(
  crossAxisCount: 2,  // ❌ Same untuk semua device size
  ...
)

// Bagian 4: AppBar tanpa Material Design 3
SliverAppBar(
  elevation: 0,
  backgroundColor: primaryColor,  // ❌ Tidak menggunakan ColorScheme
  ...
)
```

---

## ✅ AFTER (Recommended Implementation)

### Step 1: Tambahkan imports

```dart
// Di bagian atas lib/presentation/screens/home_screen.dart
import 'package:masjid_sabilillah/core/utils/responsive_helper.dart';
import 'package:masjid_sabilillah/core/constants/app_text_theme.dart';
```

### Step 2: Update Text widgets

```dart
// ✅ Responsive font size
Text(
  _userName ?? 'Hamba Allah',
  style: TextStyle(
    color: Colors.white,
    fontSize: ResponsiveHelper.responsiveFontSize(context, 26),
    fontWeight: FontWeight.bold,
  ),
)

// ✅ Gunakan TextTheme dari theme
Text(
  'Layanan Masjid',
  style: Theme.of(context).textTheme.headlineMedium,  // Instead of manual TextStyle
)

// ✅ Untuk secondary text
Text(
  'Sholat Berikutnya',
  style: Theme.of(context).textTheme.bodyMedium,
)
```

### Step 3: Update Padding & Spacing

```dart
// ❌ BEFORE
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24.0),
  child: Column(...)
)

// ✅ AFTER
Padding(
  padding: ResponsiveHelper.responsivePadding(context, basePadding: 24),
  child: Column(...)
)

// ✅ ATAU dengan EdgeInsets.symmetric
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: ResponsiveHelper.isMobile(context) ? 16 : 24,
  ),
  child: Column(...)
)
```

### Step 4: Update GridView

```dart
// ❌ BEFORE
GridView.count(
  crossAxisCount: 2,
  children: [...],
)

// ✅ AFTER
GridView.count(
  crossAxisCount: ResponsiveHelper.getGridColumns(context),
  // 2 columns untuk mobile
  // 3 columns untuk tablet
  // 4 columns untuk desktop
  children: [...],
)
```

### Step 5: Update AppBar dengan ColorScheme

```dart
// ❌ BEFORE
SliverAppBar(
  elevation: 0,
  backgroundColor: primaryColor,
  ...
)

// ✅ AFTER
SliverAppBar(
  elevation: 0,
  backgroundColor: Theme.of(context).colorScheme.primary,
  // Automatically adapts to light/dark theme
  ...
)

// ✅ ATAU gunakan AppBarTheme dari theme
SliverAppBar(
  elevation: 0,
  // backgroundColor akan auto-apply dari theme
  ...
)
```

---

## 📝 COMPLETE EXAMPLE: Updated _buildNextPrayerCard

### BEFORE (Current)
```dart
Widget _buildNextPrayerCard(bool isDark) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),  // ❌ Fixed padding
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[900] : Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(PhosphorIconsFill.mapPin, size: 16, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              _selectedCity,
              style: TextStyle(
                fontSize: 12,  // ❌ Fixed font size
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // ... rest of widget
      ],
    ),
  );
}
```

### AFTER (Recommended)
```dart
Widget _buildNextPrayerCard(bool isDark) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
  
  return Card(  // ✅ Use Card instead of Container
    elevation: ResponsiveHelper.getResponsiveElevation(context),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    child: Padding(
      padding: ResponsiveHelper.responsivePadding(
        context,
        basePadding: 20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Tooltip(  // ✅ Add tooltip untuk accessibility
                message: 'Lokasi: $_selectedCity',
                child: Icon(
                  PhosphorIconsFill.mapPin,
                  size: 16,
                  color: colorScheme.primary,  // ✅ Use colorScheme
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _selectedCity,
                style: textTheme.bodySmall?.copyWith(  // ✅ Use textTheme
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 12 : 16,  // ✅ Responsive spacing
          ),
          // ... rest of widget
        ],
      ),
    ),
  );
}
```

---

## 🎨 COMPLETE EXAMPLE: Updated build() method

```dart
@override
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,  // ✅ Use colorScheme
    body: RefreshIndicator(
      onRefresh: _refreshData,
      color: colorScheme.primary,  // ✅ Use colorScheme instead of primaryColor
      child: CustomScrollView(
        slivers: [
          // 1. MODERN APP BAR
          SliverAppBar(
            expandedHeight: ResponsiveHelper.responsiveFontSize(context, 180),  // ✅ Responsive height
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.primary,  // ✅ Use colorScheme
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -20,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(
                          PhosphorIcons.mosque(),
                          size: 250,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: ResponsiveHelper.responsivePadding(
                        context,
                        basePadding: 24,
                      ),  // ✅ Responsive padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assalamu\'alaikum,',
                            style: textTheme.bodyMedium?.copyWith(  // ✅ Use textTheme
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.isMobile(context) ? 4 : 8,
                          ),
                          Text(
                            _userName ?? 'Hamba Allah',
                            style: textTheme.displayMedium?.copyWith(  // ✅ Use textTheme
                              color: Colors.white,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                context,
                                26,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.isMobile(context) ? 20 : 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Tooltip(  // ✅ Add tooltip untuk accessibility
                message: 'Buka pengaturan',
                child: IconButton(
                  icon: Icon(
                    PhosphorIconsFill.gearSix,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.toNamed('/pengaturan'),
                  tooltip: 'Pengaturan',  // ✅ Add semantic label
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: ResponsiveHelper.responsivePadding(
                context,
                basePadding: 20,
              ),  // ✅ Responsive padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. PRAYER CARD
                  _buildNextPrayerCard(isDark),
                  
                  SizedBox(
                    height: ResponsiveHelper.isMobile(context) ? 24 : 30,
                  ),

                  // 3. MENU TITLE
                  Text(
                    'Layanan Masjid',
                    style: textTheme.headlineMedium,  // ✅ Use textTheme
                  ),
                  const SizedBox(height: 16),

                  // 4. MENU GRID
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: ResponsiveHelper.getGridColumns(context),  // ✅ Responsive columns
                    mainAxisSpacing: ResponsiveHelper.isMobile(context) ? 16 : 20,
                    crossAxisSpacing: ResponsiveHelper.isMobile(context) ? 16 : 20,
                    childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.1 : 1.2,
                    children: [
                      _buildMenuCard('Jadwal Sholat', PhosphorIconsFill.clock, Colors.blue, '/jadwal', isDark),
                      _buildMenuCard('Infaq/Donasi', PhosphorIconsFill.handHeart, Colors.orange, '/donasi', isDark),
                      _buildMenuCard('Pengumuman', PhosphorIconsFill.megaphone, Colors.purple, '/pengumuman', isDark),
                      _buildMenuCard('Lokasi', PhosphorIconsFill.mapPin, Colors.red, '/lokasi', isDark),
                    ],
                  ),

                  SizedBox(
                    height: ResponsiveHelper.isMobile(context) ? 24 : 30,
                  ),

                  // 5. QUOTE SECTION
                  _buildQuoteSection(isDark),
                  
                  SizedBox(
                    height: ResponsiveHelper.isMobile(context) ? 32 : 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## ✨ KEY IMPROVEMENTS

| Aspek | Before | After |
|-------|--------|-------|
| **Font Size** | Hardcoded: 26, 18, 12 | Responsive dengan ResponsiveHelper |
| **Padding** | Same 24 everywhere | Responsive: 16-24 based on device |
| **Grid Columns** | Fixed 2 columns | 2 (mobile), 3 (tablet), 4 (desktop) |
| **Colors** | primaryColor variable | Theme.of(context).colorScheme |
| **TextStyle** | Manual TextStyle | Theme.of(context).textTheme |
| **Accessibility** | Tidak ada tooltip | Tooltip + Semantics |
| **Dark Mode** | Manual isDark check | Automatic via theme |

---

## 🚀 HOW TO APPLY

### Option 1: Gradual Update (Recommended)
1. Update imports
2. Update Text widgets dulu (file home_screen.dart)
3. Update Padding & Spacing
4. Update Colors & TextStyle
5. Test & validate
6. Repeat ke screens lain

### Option 2: Full Refactor
1. Backup existing file
2. Rewrite penuh mengikuti contoh after
3. Test komprehensif

---

## ✅ TESTING CHECKLIST

Setelah update, test:
- [ ] Text readable di semua font sizes (100%-200%)
- [ ] Layout proper di mobile (360px)
- [ ] Layout proper di tablet (768px)
- [ ] Layout proper di desktop (1920px)
- [ ] Dark mode working
- [ ] Light mode working
- [ ] Icons punya tooltip
- [ ] Color contrast >= 4.5:1

---

**Last Updated:** 22 Desember 2025

