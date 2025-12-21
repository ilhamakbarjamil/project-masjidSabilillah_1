# 📱 PANDUAN: Mengubah Nama & Icon Aplikasi Flutter
**Platform:** Android, iOS, Windows, macOS, Linux, Web  
**Created:** 22 Desember 2025  

---

## 🎯 CARA MENGUBAH NAMA APLIKASI

Nama aplikasi perlu diubah di beberapa tempat tergantung platform target:

### 1. **pubspec.yaml** (Package Name)
**File:** `pubspec.yaml`

```yaml
# SEKARANG:
name: masjid_sabilillah
description: "A new Flutter project."

# UBAH MENJADI:
name: masjid_sabilillah  # ← Package name (gunakan snake_case, jangan ubah jika sudah di production)
description: "Aplikasi Jadwal Sholat dan Informasi Masjid Sabilillah"
```

⚠️ **CATATAN:** Jangan ubah package name jika app sudah published. Anda perlu update semua import statements.

---

### 2. **Android Manifest** (Display Name)
**File:** `android/app/src/main/AndroidManifest.xml`

Temukan bagian ini dan ubah `android:label`:

```xml
<!-- SEKARANG -->
<application
    android:label="masjid_sabilillah"
    ...>

<!-- UBAH MENJADI -->
<application
    android:label="Masjid Sabilillah"
    ...>
```

---

### 3. **iOS Info.plist** (Display Name)
**File:** `ios/Runner/Info.plist`

Temukan & ubah key berikut:

```xml
<!-- SEKARANG -->
<key>CFBundleDisplayName</key>
<string>masjid sabilillah</string>

<!-- UBAH MENJADI -->
<key>CFBundleDisplayName</key>
<string>Masjid Sabilillah</string>
```

---

### 4. **Windows** (Display Name)
**File:** `windows/runner/main.cpp`

```cpp
// Temukan baris ini:
const wchar_t* kAppName = L"masjid_sabilillah";

// Ubah menjadi:
const wchar_t* kAppName = L"Masjid Sabilillah";
```

---

### 5. **macOS** (Display Name)
**File:** `macos/Runner/Info.plist`

```xml
<!-- SEKARANG -->
<key>CFBundleDisplayName</key>
<string>masjid_sabilillah</string>

<!-- UBAH MENJADI -->
<key>CFBundleDisplayName</key>
<string>Masjid Sabilillah</string>
```

---

### 6. **Linux** (Display Name)
**File:** `linux/CMakeLists.txt`

```cmake
# Temukan:
set(APPLICATION_TITLE "masjid_sabilillah")

# Ubah menjadi:
set(APPLICATION_TITLE "Masjid Sabilillah")
```

---

### 7. **main.dart** (App Title)
**File:** `lib/main.dart` (Sudah benar ✅)

```dart
GetMaterialApp(
  title: 'Masjid Sabilillah',  // ← Ini untuk browser/task switcher
  ...
)
```

Sudah benar, tidak perlu diubah.

---

## 🎨 CARA MENGUBAH ICON APLIKASI

Ini lebih kompleks. Ada dua cara:

### **CARA 1: Automatic (RECOMMENDED) - Pakai flutter_launcher_icons**

#### Step 1: Install Package
Tambahkan ke `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

Jalankan:
```bash
flutter pub get
```

#### Step 2: Setup Icon Configuration
Buat atau edit file `pubspec.yaml`, tambahkan di bagian bawah:

```yaml
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
  min_sdk_android: 21
  remove_alpha_ios: true
```

#### Step 3: Persiapkan Icon File
1. Buat folder: `assets/icon/`
2. Letakkan file icon: `app_icon.png` (minimal 1024x1024px)
   - Format: PNG dengan transparent background
   - Recommended: 1024x1024 atau lebih besar

#### Step 4: Generate Icons
```bash
flutter pub run flutter_launcher_icons
```

Ini akan auto-generate icons untuk:
- ✅ Android (berbagai ukuran)
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Web

**Selesai! Tidak perlu edit manual lagi.**

---

### **CARA 2: Manual (Jika tidak ingin pakai package)**

#### Android Icons
**Lokasi:** `android/app/src/main/res/mipmap-*/`

Icons yang diperlukan:
- `mipmap-ldpi/ic_launcher.png` (36x36)
- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)

1. Delete file lama
2. Replace dengan icon baru di masing-masing folder
3. Build ulang

#### iOS Icons
**Lokasi:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Edit file: `Contents.json`

1. Replace icon files (berbagai ukuran)
2. Build ulang

---

## ✅ QUICK CHECKLIST

```
NAMA APLIKASI:
[ ] pubspec.yaml - description
[ ] android/app/src/main/AndroidManifest.xml - android:label
[ ] ios/Runner/Info.plist - CFBundleDisplayName
[ ] windows/runner/main.cpp - kAppName
[ ] macos/Runner/Info.plist - CFBundleDisplayName
[ ] linux/CMakeLists.txt - APPLICATION_TITLE
[ ] lib/main.dart - title (optional, untuk browser)

ICON APLIKASI (Pilih salah satu):
Option A - Automatic:
[ ] Install flutter_launcher_icons
[ ] Siapkan icon file (1024x1024 PNG)
[ ] Update pubspec.yaml dengan flutter_launcher_icons config
[ ] Run: flutter pub run flutter_launcher_icons
[ ] Done! ✓

Option B - Manual:
[ ] Replace android icons (mipmap-*)
[ ] Replace iOS icons (Assets.xcassets)
[ ] Replace windows icons (windows/runner/resources)
[ ] Replace macos icons (macos/Runner/Assets.xcassets)
```

---

## 🔄 AFTER CHANGING NAME

Jalankan:
```bash
# Clean build
flutter clean

# Get packages
flutter pub get

# Run
flutter run
```

---

## 🎨 ICON DESIGN TIPS

### Ukuran Ideal
- **Source file:** 1024x1024 pixel (atau lebih besar)
- **Padding:** 20% margin dari tepi
- **Format:** PNG dengan transparent background
- **Style:** Sesuai dengan app theme (Masjid Sabilillah = islamic design)

### Contoh Design Ideas untuk Masjid Sabilillah:
1. **Mosque silhouette** - Gambar masjid sederhana
2. **Moon + Star** - Islamic symbol
3. **Prayer beads** - Tasbih icon
4. **Compass** - Untuk qibla direction
5. **Clock** - Prayer times symbol

### Recommended Tools:
- **Figma** (free) - https://figma.com
- **Canva** (free) - https://canva.com
- **Adobe XD** (paid)
- **Photoshop** (paid)

---

## 📦 TESTING AFTER CHANGES

### Verify App Name
```bash
# Build APK
flutter build apk

# Check app name di file manager atau:
adb shell cmd package dump d | grep displayLabel
```

### Verify Icon
Cukup lihat di:
- Home screen (launcher)
- App drawer
- Recent apps
- Settings > Apps

---

## 🚀 BUILD & SHARE

Setelah ubah nama & icon:

### Android (APK)
```bash
flutter build apk --release
# File: build/app/outputs/flutter-apk/app-release.apk
```

### Android (Bundle)
```bash
flutter build appbundle --release
# File: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
# Atau gunakan Xcode untuk distribution
```

---

## ⚠️ IMPORTANT NOTES

1. **Package Name:** Jangan ubah di pubspec.yaml jika sudah published
2. **Version:** Update version di pubspec.yaml sebelum release
3. **Testing:** Test di emulator/device sebelum share
4. **Icons:** Ensure icon terlihat baik di berbagai screen sizes
5. **Permissions:** Periksa AndroidManifest untuk permissions yang diperlukan

---

## 📋 CONTOH LENGKAP: Cara Ubah Nama

Misalkan Anda ingin ubah nama dari "masjid_sabilillah" → "Masjid Sabilillah App"

### 1. pubspec.yaml
```yaml
name: masjid_sabilillah
description: "Aplikasi Jadwal Sholat dan Informasi Masjid Sabilillah"
```

### 2. android/app/src/main/AndroidManifest.xml
```xml
<application
    android:label="Masjid Sabilillah App"
    ...>
```

### 3. ios/Runner/Info.plist
```xml
<key>CFBundleDisplayName</key>
<string>Masjid Sabilillah App</string>
```

### 4. lib/main.dart
```dart
GetMaterialApp(
  title: 'Masjid Sabilillah App',
  ...
)
```

### 5. Ganti Icon
Ikuti Cara 1 (flutter_launcher_icons) atau Cara 2 (manual)

### 6. Build & Test
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🎯 UNTUK IMMEDIATE ACTION

**Jika ingin cepat sekarang:**

1. **Nama sudah bagus:** "Masjid Sabilillah" ✅
2. **Tinggal ubah di:**
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`
   - Windows/macOS (jika diperlukan)

3. **Icon:**
   - Pakai flutter_launcher_icons (Cara 1) - RECOMMENDED
   - Atau buat custom icon & replace manual (Cara 2)

---

**Status:** Ready for Implementation  
**Estimated Time:** 30 min - 2 hours (tergantung design icon)  
**Difficulty:** Easy-Medium  

