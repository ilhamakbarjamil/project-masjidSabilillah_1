# 📝 CONTOH: pubspec.yaml dengan flutter_launcher_icons Config

Ini adalah contoh lengkap `pubspec.yaml` Anda dengan flutter_launcher_icons sudah dikonfigurasi.

---

## CURRENT pubspec.yaml (SEBELUM)

```yaml
name: masjid_sabilillah
description: "A new Flutter project."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ^3.9.2

dependencies:
  flutter:
    sdk: flutter
  phosphor_flutter: ^2.0.0
  concentric_transition: ^1.0.3
  cupertino_icons: ^1.0.8
  firebase_core: ^4.2.1
  firebase_messaging: ^16.0.4
  flutter_local_notifications: ^17.2.3
  # ... other dependencies

dev_dependencies:
  flutter_test:
    sdk: flutter
  internet_connection_checker: ^1.0.0+1

flutter:
  uses-material-design: true
```

---

## UPDATED pubspec.yaml (SESUDAH)

Tambahkan di bagian `dev_dependencies` dan `flutter_launcher_icons` section:

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
  phosphor_flutter: ^2.0.0
  concentric_transition: ^1.0.3
  cupertino_icons: ^1.0.8
  firebase_core: ^4.2.1
  firebase_messaging: ^16.0.4
  flutter_local_notifications: ^17.2.3
  # ... other dependencies

dev_dependencies:
  flutter_test:
    sdk: flutter
  internet_connection_checker: ^1.0.0+1
  flutter_launcher_icons: ^0.13.1  # ← TAMBAH INI

flutter:
  uses-material-design: true

# ← TAMBAH SECTION INI DI PALING AKHIR
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

## DETAIL PENJELASAN

### flutter_launcher_icons section

```yaml
flutter_launcher_icons:
  # Platform yang ingin generate icon
  android: "launcher_icon"           # Android - nama asset
  ios: true                          # iOS - enabled
  windows:
    generate: true                   # Windows - enabled
  macos:
    generate: true                   # macOS - enabled
  
  # Path ke source icon
  image_path: "assets/icon/app_icon.png"           # Default untuk semua
  image_path_android: "assets/icon/app_icon.png"   # Android specific
  image_path_ios: "assets/icon/app_icon.png"       # iOS specific
  
  # Options
  remove_alpha_ios: true             # Buat background solid untuk iOS
  min_sdk_android: 21                # Minimum Android API level
```

---

## KONFIGURASI ALTERNATIF (Advanced)

### Jika ingin icon berbeda untuk dev & prod:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/app_icon.png"
  
  # Untuk flavor/build variant berbeda (opsional):
  # android_adaptive_icon_background: "#ffffff"
  # android_adaptive_icon_foreground: "assets/icon/adaptive_icon_foreground.png"
```

### Jika ingin Android Adaptive Icon (Android 8+):

```yaml
flutter_launcher_icons:
  android: "launcher_icon_adaptive"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/icon/adaptive_icon_foreground.png"
  ios: true
  image_path: "assets/icon/app_icon.png"
```

---

## LANGKAH IMPLEMENTASI

### 1. Edit pubspec.yaml

Buka file `pubspec.yaml` dengan text editor, dan:

```
1. Cari: dev_dependencies:
2. Tambahkan: flutter_launcher_icons: ^0.13.1
3. Ke bawah akhir file, tambahkan flutter_launcher_icons section
4. Save file
```

### 2. Jalankan command

```bash
# Get packages
flutter pub get

# Generate icons
flutter pub run flutter_launcher_icons

# Clean
flutter clean

# Run
flutter run
```

---

## FOLDER STRUCTURE (AFTER)

```
project-masjidSabilillah_1/
├── assets/
│   ├── images/
│   └── icon/
│       └── app_icon.png              (← Anda provide)
├── android/
│   └── app/src/main/res/
│       ├── mipmap-ldpi/ic_launcher.png       (auto-gen)
│       ├── mipmap-mdpi/ic_launcher.png       (auto-gen)
│       ├── mipmap-hdpi/ic_launcher.png       (auto-gen)
│       ├── mipmap-xhdpi/ic_launcher.png      (auto-gen)
│       ├── mipmap-xxhdpi/ic_launcher.png     (auto-gen)
│       └── mipmap-xxxhdpi/ic_launcher.png    (auto-gen)
├── ios/
│   └── Runner/Assets.xcassets/AppIcon.appiconset/
│       ├── Icon-App-20x20@1x.png     (auto-gen)
│       ├── Icon-App-20x20@2x.png     (auto-gen)
│       ├── Icon-App-20x20@3x.png     (auto-gen)
│       └── ... (lebih banyak icons)
├── pubspec.yaml                       (← UPDATE)
└── ... (other files)
```

---

## COMMAND REFERENCE

```bash
# Install package
flutter pub add --dev flutter_launcher_icons

# Or manually:
# Edit pubspec.yaml, add flutter_launcher_icons: ^0.13.1 di dev_dependencies
# Run: flutter pub get

# Generate icons
flutter pub run flutter_launcher_icons

# Generate untuk specific platform
flutter pub run flutter_launcher_icons:main

# Clean everything
flutter clean

# Get packages
flutter pub get

# Run aplikasi
flutter run

# Build release APK
flutter build apk --release

# Build release App Bundle
flutter build appbundle --release
```

---

## COMMON CONFIGURATIONS

### Config 1: Basic Setup (Recommended)
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  windows:
    generate: true
  macos:
    generate: true
  image_path: "assets/icon/app_icon.png"
  remove_alpha_ios: true
  min_sdk_android: 21
```

### Config 2: Minimal (Android + iOS Only)
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/app_icon.png"
```

### Config 3: Full Featured (Adaptive Icon)
```yaml
flutter_launcher_icons:
  android: "launcher_icon_adaptive"
  ios: true
  windows:
    generate: true
  macos:
    generate: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/icon/adaptive_icon_foreground.png"
  remove_alpha_ios: true
  min_sdk_android: 21
```

---

## TROUBLESHOOTING

### Error: image_path points to missing file
```
Solution: Pastikan file ada di:
assets/icon/app_icon.png
(1024x1024 PNG format)
```

### Error: pubspec.yaml syntax error
```
Solution: Check indent (gunakan spaces, bukan tabs)
Pastikan alignment flutter_launcher_icons di paling kiri
```

### Icons tidak berubah setelah run
```
Solution:
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
flutter run
```

### Port already in use
```
Solution:
flutter run --release
Atau kill process:
lsof -ti:8888 | xargs kill -9
```

---

## NEXT STEPS

1. **Copy** pubspec.yaml configuration di atas
2. **Edit** `pubspec.yaml` Anda
3. **Add** flutter_launcher_icons dependency
4. **Add** flutter_launcher_icons configuration
5. **Create** `assets/icon/` folder
6. **Put** `app_icon.png` (1024x1024) di sana
7. **Run** `flutter pub get`
8. **Run** `flutter pub run flutter_launcher_icons`
9. **Run** `flutter clean && flutter run`
10. **Verify** icon di home screen

---

**Status:** Configuration Template Ready  
**Difficulty:** Easy  
**Time:** 5 minutes to update  

