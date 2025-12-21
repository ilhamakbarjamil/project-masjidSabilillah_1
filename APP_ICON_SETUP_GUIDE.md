# 🎨 STEP-BY-STEP: Setup Icon Aplikasi dengan flutter_launcher_icons

**Time:** 15-30 menit  
**Difficulty:** Easy  
**Recommended:** Ya! Cara tercepat & termudah  

---

## 📋 CHECKLIST SEBELUM MULAI

```
[ ] Sudah punya icon image (PNG, minimal 1024x1024)
[ ] Gambar icon sudah transparent background (recommended)
[ ] Icon sudah sesuai brand Masjid Sabilillah (optional)
[ ] Sudah backup project (git commit)
```

---

## 🚀 QUICK START (3 Steps)

### Step 1: Install Package (2 menit)
```bash
# Edit pubspec.yaml - tambahkan di dev_dependencies
flutter pub add --dev flutter_launcher_icons

# Atau manual di pubspec.yaml:
```

Buka `pubspec.yaml` dan cari bagian `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1  # ← TAMBAHKAN INI
```

Jalankan:
```bash
flutter pub get
```

---

### Step 2: Siapkan Icon File (5 menit)

Buat folder struktur:
```
assets/
└── icon/
    └── app_icon.png  (1024x1024 pixel, PNG)
```

**Contoh struktur folder:**
```
project-masjidSabilillah_1/
├── assets/
│   ├── images/
│   └── icon/           ← CREATE THIS
│       └── app_icon.png ← PUT ICON HERE
├── lib/
├── android/
├── ios/
└── pubspec.yaml
```

---

### Step 3: Configure pubspec.yaml (3 menit)

Di **akhir** file `pubspec.yaml`, tambahkan:

```yaml
# ... rest of pubspec.yaml

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  windows:
    generate: true
  macos:
    generate: true
  image_path: "assets/icon/app_icon.png"
  image_path_android: "assets/icon/app_icon.png"
  image_path_ios: "assets/icon/app_icon.png"
  remove_alpha_ios: true
  min_sdk_android: 21
```

---

### Step 4: Generate Icons (2 menit)

```bash
# Run flutter_launcher_icons
flutter pub run flutter_launcher_icons

# Output akan seperti:
# ✓ Successfully generated launcher icons
# ✓ Android launcher icons
# ✓ iOS launcher icons
# ✓ Windows launcher icons
# ✓ macOS launcher icons
```

---

### Step 5: Clean & Run (5 menit)

```bash
# Clean
flutter clean

# Get packages
flutter pub get

# Run
flutter run
```

**Selesai! Icon sudah berubah di semua platform.** ✅

---

## 🎨 CARA MEMBUAT ICON

Jika belum punya icon, gunakan:

### **Option 1: Figma (Gratis, Recommended)**
1. Buka https://figma.com
2. Create new design
3. Size: 1024x1024 px
4. Design islamic/mosque icon
5. Export as PNG (transparent background)

**Contoh Design:**
- Mosque silhouette (sederhana & profesional)
- Moon + Star (islamic symbol)
- Prayer beads (tasbih)
- Compass (qibla direction)

### **Option 2: Canva (Gratis, Mudah)**
1. Buka https://canva.com
2. Search "app icon"
3. Choose template atau buat custom
4. Customize dengan warna & design Masjid
5. Download as PNG

### **Option 3: Online Tools**
- **Logoipsum:** https://logoipsum.com
- **LogoMaker:** https://logomyway.com
- **Brandmark:** https://brandmark.io

### **Option 4: Hire Designer**
- Fiverr, Upwork, atau designer lokal
- Budget: Rp 50.000 - 500.000 tergantung kualitas

---

## 🖼️ ICON REQUIREMENTS

### Technical Specs
```
Format:          PNG
Recommended:     1024x1024 pixel
Minimum:         512x512 pixel
Background:      Transparent
Colors:          RGB (tidak CMYK)
```

### Design Tips
```
✅ Simple & recognizable
✅ Looks good in small sizes (100x100)
✅ High contrast (readable di lock screen)
✅ Padding dari tepi (20-30% margin)
✅ No text (or minimal text)
❌ Too complex (akan blur di ukuran kecil)
❌ Bright colors everywhere (sulit dibaca)
```

### Rekomendasi untuk Masjid Sabilillah
```
Primary Color:     #0D3B66 (biru gelap)
Secondary Color:   #4A90E2 (biru terang)
Accent:            Putih atau emas (opsional)
Style:             Minimalist / Modern Islamic
```

---

## 📂 FINAL STRUCTURE (Setelah Setup)

Icon akan di-generate di:

```
project-masjidSabilillah_1/
├── assets/
│   └── icon/
│       └── app_icon.png        (← Source icon, Anda buat)
├── android/
│   └── app/src/main/res/
│       ├── mipmap-ldpi/ic_launcher.png (auto-generated)
│       ├── mipmap-mdpi/ic_launcher.png (auto-generated)
│       ├── mipmap-hdpi/ic_launcher.png (auto-generated)
│       ├── mipmap-xhdpi/ic_launcher.png (auto-generated)
│       ├── mipmap-xxhdpi/ic_launcher.png (auto-generated)
│       └── mipmap-xxxhdpi/ic_launcher.png (auto-generated)
├── ios/
│   └── Runner/Assets.xcassets/AppIcon.appiconset/
│       ├── Icon-App-*.png (auto-generated)
│       └── Icon-App-*@2x.png (auto-generated)
├── windows/runner/resources/
│   └── app_icon.ico (auto-generated)
├── macos/Runner/Assets.xcassets/AppIcon.appiconset/
│   └── app_icon_* (auto-generated)
└── web/icons/
    ├── Icon-192.png (auto-generated)
    ├── Icon-512.png (auto-generated)
    └── favicon.png (auto-generated)
```

**JANGAN EDIT FILE AUTO-GENERATED!** Jika ingin ubah, edit `app_icon.png` dan run ulang command.

---

## ✅ VERIFICATION

Setelah setup, verify icon di:

### Android
```
Home Screen → Lihat icon di app drawer
Atau: Settings > Apps > Masjid Sabilillah
```

### iOS
```
Home Screen → Lihat icon di folder
App Switcher (swipe up) → Lihat icon
```

### Windows
```
Start Menu → Lihat icon
Desktop → Lihat icon (jika ada shortcut)
```

### Web
```
Browser tab → Lihat favicon (small icon)
```

---

## 🐛 TROUBLESHOOTING

### Problem 1: "flutter_launcher_icons command not found"
```bash
# Solution:
flutter pub get
flutter pub run flutter_launcher_icons
```

### Problem 2: Icons tidak berubah setelah run
```bash
# Clean everything:
flutter clean
rm -rf build
flutter pub get
flutter pub run flutter_launcher_icons
flutter run
```

### Problem 3: Icon terlihat blur atau pixelated
```
Reason: Source image terlalu kecil
Solution: Gunakan icon minimal 1024x1024 px
```

### Problem 4: Icon masih "masjid_sabilillah" default
```bash
# Verify:
ls assets/icon/app_icon.png  # File ada?
grep -A 5 "flutter_launcher_icons:" pubspec.yaml  # Config ada?

# Re-run:
flutter pub run flutter_launcher_icons --flavor production
```

### Problem 5: Transparent background tidak bekerja (iOS)
```yaml
# Ubah di pubspec.yaml:
flutter_launcher_icons:
  remove_alpha_ios: false  # Change from true to false
```

---

## 🔄 UPDATE ICON KEMUDIAN

Jika ingin ubah icon nanti:

1. **Edit file:** `assets/icon/app_icon.png`
2. **Jalankan:**
   ```bash
   flutter pub run flutter_launcher_icons
   ```
3. **Clean & Run:**
   ```bash
   flutter clean
   flutter run
   ```

---

## 🎯 EXAMPLE: Complete Setup

### File: pubspec.yaml
```yaml
name: masjid_sabilillah
description: "Aplikasi Jadwal Sholat dan Informasi Masjid Sabilillah"
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ^3.9.2

dependencies:
  flutter:
    sdk: flutter
  # ... other dependencies

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1  # ← ADDED

flutter:
  uses-material-design: true

flutter_launcher_icons:                    # ← ADDED
  android: "launcher_icon"
  ios: true
  windows:
    generate: true
  macos:
    generate: true
  image_path: "assets/icon/app_icon.png"
  image_path_android: "assets/icon/app_icon.png"
  image_path_ios: "assets/icon/app_icon.png"
  remove_alpha_ios: true
  min_sdk_android: 21
```

### Folder: assets/icon/
```
assets/
└── icon/
    └── app_icon.png (1024x1024, transparent background)
```

### Commands to Run
```bash
# 1. Get packages
flutter pub get

# 2. Generate icons
flutter pub run flutter_launcher_icons

# 3. Clean & run
flutter clean
flutter run
```

---

## 📊 ESTIMATED TIMELINE

| Step | Time | Notes |
|------|------|-------|
| Install package | 2 min | flutter pub add flutter_launcher_icons |
| Create icon | 15-120 min | Depends on design skill/hiring |
| Copy to assets | 2 min | Create folder & copy file |
| Configure pubspec | 3 min | Add flutter_launcher_icons config |
| Generate icons | 2 min | flutter pub run flutter_launcher_icons |
| Clean & run | 5 min | flutter clean && flutter run |
| **Total** | **30-135 min** | **Mostly design time** |

---

## 🎁 BONUS: Multiple Icons (Different Flavors)

Jika ingin icon berbeda untuk development vs production:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/app_icon.png"
  image_path_android: "assets/icon/app_icon.png"
  image_path_ios: "assets/icon/app_icon.png"
  
  # Development flavor (opsional)
  # image_path_android_dev: "assets/icon/dev_icon.png"
```

---

## ✨ NEXT STEPS

1. **Siapkan icon file** (atau buat di Figma/Canva)
2. **Copy ke:** `assets/icon/app_icon.png`
3. **Update:** `pubspec.yaml` dengan flutter_launcher_icons config
4. **Run:** `flutter pub run flutter_launcher_icons`
5. **Test:** `flutter clean && flutter run`
6. **Verify:** Lihat icon di home screen

---

**Status:** Ready to Implement  
**Difficulty:** Easy  
**Time Needed:** 15-30 minutes  
**Recommended:** YES! ✅

