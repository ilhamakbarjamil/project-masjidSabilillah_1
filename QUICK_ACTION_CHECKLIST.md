# ✅ QUICK ACTION CHECKLIST
## Mengubah Nama & Icon Aplikasi Masjid Sabilillah

**Target Completion:** 30 menit - 1 jam  
**Difficulty:** Easy ✅

---

## 📋 CHECKLIST: NAMA APLIKASI

**Status Saat Ini:**
- ✅ Android: `masjid_sabilillah` → **Harus dirubah ke "Masjid Sabilillah"**
- ✅ iOS: Sudah `Masjid Sabilillah` ✓
- ✅ main.dart: Sudah `Masjid Sabilillah` ✓

### DONE: ✅ Android label sudah diubah

Perubahan yang sudah dilakukan:
- ✅ `android/app/src/main/AndroidManifest.xml` → "Masjid Sabilillah"

### SKIP (Optional): Windows, macOS, Linux
Jika tidak butuh support platform ini, skip langkah ini.

---

## 🎨 CHECKLIST: ICON APLIKASI

**PILIH SALAH SATU:**

### OPTION A: Automatic Setup (RECOMMENDED) ⭐

```
[ ] Step 1: Install flutter_launcher_icons
    Command: flutter pub add --dev flutter_launcher_icons
    File: pubspec.yaml ← auto-updated

[ ] Step 2: Siapkan icon file
    Folder: assets/icon/
    File: app_icon.png (1024x1024 PNG)
    Background: Transparent (recommended)
    
    DIM PERLU ICON FILE?
    → Gunakan: Figma (figma.com) atau Canva (canva.com)
    → Waktu: 5-15 menit untuk design
    → Cost: Gratis!

[ ] Step 3: Update pubspec.yaml
    Add section flutter_launcher_icons di akhir file
    Copy dari: APP_ICON_SETUP_GUIDE.md

[ ] Step 4: Generate icons
    Command: flutter pub run flutter_launcher_icons
    
[ ] Step 5: Clean & test
    Command: flutter clean
    Command: flutter pub get
    Command: flutter run
    Verify: Lihat icon di home screen
```

**Total Time:** 20-30 menit (excluding design)

---

### OPTION B: Manual (Jika tidak ingin package)

```
[ ] Download atau design icon file (1024x1024 PNG)

[ ] Android icons
    [ ] Replace di: android/app/src/main/res/mipmap-*/
    [ ] Rename semua: ic_launcher.png
    
[ ] iOS icons
    [ ] Replace di: ios/Runner/Assets.xcassets/AppIcon.appiconset/
    
[ ] Test
    [ ] flutter clean
    [ ] flutter run
```

**Total Time:** 45-60 menit

---

## 🚀 STEP-BY-STEP (OPTION A RECOMMENDED)

### 1️⃣ Install Package (2 menit)
```bash
cd /home/zack/Documents/project-masjidSabilillah_1

# Install flutter_launcher_icons
flutter pub add --dev flutter_launcher_icons

# Or:
# Edit pubspec.yaml manually dan add:
# dev_dependencies:
#   flutter_launcher_icons: ^0.13.1
# Lalu: flutter pub get
```

✅ **Status:** Package installed

---

### 2️⃣ Buat Folder Icon (1 menit)
```bash
# Create folder
mkdir -p assets/icon

# Verify
ls -la assets/icon/
```

✅ **Status:** Folder created

---

### 3️⃣ Siapkan Icon File (10-15 menit)

**Opsi A: Buat sendiri di Figma/Canva**
- Buka: https://figma.com atau https://canva.com
- Buat icon 1024x1024 pixel
- Design: Islamic/mosque theme
- Export: PNG (transparent background)
- Simpan ke: `assets/icon/app_icon.png`

**Opsi B: Pakai template/icon gratis**
- https://www.flaticon.com (cari "mosque icon")
- https://www.iconfinder.com
- https://thenounproject.com
- Resize ke 1024x1024
- Simpan ke: `assets/icon/app_icon.png`

**Opsi C: Gunakan placeholder (test dulu)**
- Download icon dari Google
- Simpan ke: `assets/icon/app_icon.png`
- Test setup dulu sebelum design final

✅ **Status:** Icon file ready at `assets/icon/app_icon.png`

---

### 4️⃣ Update pubspec.yaml (3 menit)

**File:** `pubspec.yaml`

Buka dengan editor dan cari baris paling akhir. Tambahkan:

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
  remove_alpha_ios: true
  min_sdk_android: 21
```

✅ **Status:** pubspec.yaml updated

---

### 5️⃣ Generate Icons (2 menit)

```bash
# Make sure you're in project directory
cd /home/zack/Documents/project-masjidSabilillah_1

# Get packages (just in case)
flutter pub get

# Generate icons untuk semua platform
flutter pub run flutter_launcher_icons

# Expected output:
# ✓ Successfully generated launcher icons
```

✅ **Status:** Icons generated

---

### 6️⃣ Clean & Run (5 menit)

```bash
# Clean build cache
flutter clean

# Get packages
flutter pub get

# Run aplikasi
flutter run

# Atau untuk test specific platform:
# flutter run -d <device_id>
```

**Verify:** 
- Lihat icon di home screen/app drawer
- Lihat di app switcher (recent apps)
- Icon berubah dari default flutter

✅ **Status:** Icon updated & verified

---

### 7️⃣ Build APK untuk Share (5 menit, optional)

```bash
# Build APK release
flutter build apk --release

# Output di:
# build/app/outputs/flutter-apk/app-release.apk

# Atau untuk App Bundle:
flutter build appbundle --release

# Output di:
# build/app/outputs/bundle/release/app-release.aab
```

✅ **Status:** Ready to share

---

## 📊 SUMMARY CHANGES

### Changed Files
```
✅ android/app/src/main/AndroidManifest.xml
   - android:label: "masjid_sabilillah" → "Masjid Sabilillah"

⏳ pubspec.yaml
   - Add flutter_launcher_icons dependency
   - Add flutter_launcher_icons configuration

⏳ assets/icon/app_icon.png
   - NEW FILE (create/provide)

🔄 android/app/src/main/res/mipmap-*/
   - AUTO-GENERATED (overwrite)

🔄 ios/Runner/Assets.xcassets/
   - AUTO-GENERATED (overwrite)
```

---

## 🎯 QUICK COMMANDS CHEATSHEET

```bash
# Install package
flutter pub add --dev flutter_launcher_icons

# Create folder
mkdir -p assets/icon

# Generate icons
flutter pub run flutter_launcher_icons

# Clean
flutter clean

# Get packages
flutter pub get

# Run
flutter run

# Build APK
flutter build apk --release
```

---

## ⏱️ TIME BREAKDOWN

| Step | Time | Notes |
|------|------|-------|
| 1. Install package | 2 min | One command |
| 2. Create folder | 1 min | mkdir |
| 3. Prepare icon | 10-15 min | Design atau download |
| 4. Update pubspec | 3 min | Copy-paste |
| 5. Generate icons | 2 min | One command |
| 6. Clean & run | 5 min | flutter clean + run |
| 7. Build APK | 3-5 min | Optional |
| **TOTAL** | **26-33 min** | **Without design time** |

**Jika design icon:** +15-120 minutes

---

## ✨ VERIFICATION

Setelah selesai, pastikan:

```
[ ] Aplikasi nama: "Masjid Sabilillah" ✓
[ ] Icon custom sudah di home screen ✓
[ ] Icon custom di app drawer ✓
[ ] App berjalan normal tanpa error ✓
[ ] Sudah tested di device/emulator ✓
```

---

## 🐛 JIKA ADA MASALAH

### Masalah: Flutter command not found
```bash
# Solution: Update PATH atau gunakan full path
/home/zack/flutter/bin/flutter pub run flutter_launcher_icons
```

### Masalah: Icon tidak berubah
```bash
# Solution: Clean lebih dalam
flutter clean
rm -rf build
flutter pub get
flutter pub run flutter_launcher_icons
flutter run
```

### Masalah: File app_icon.png tidak ditemukan
```bash
# Check:
ls -la assets/icon/app_icon.png

# Jika tidak ada, buat folder dulu:
mkdir -p assets/icon
# Kemudian copy icon file ke sana
```

### Masalah: pubspec.yaml syntax error
```bash
# Verify:
dart analyze pubspec.yaml

# Or just check indent (must be consistent spaces, not tabs)
```

---

## 📞 NEED HELP?

1. **Untuk detail lengkap:** Baca file `CHANGING_APP_NAME_AND_ICON.md`
2. **Untuk icon setup:** Baca file `APP_ICON_SETUP_GUIDE.md`
3. **Untuk troubleshoot:** Lihat bagian "Troubleshooting" di guide

---

## 🎉 SETELAH SELESAI

Aplikasi siap untuk di-share dengan:
- ✅ Nama aplikasi: "Masjid Sabilillah"
- ✅ Icon custom
- ✅ APK file: `build/app/outputs/flutter-apk/app-release.apk`

**Tinggal share ke teman/keluarga! 🚀**

---

**Start Time:** Sekarang!  
**Estimated Duration:** 30 menit - 1 jam  
**Difficulty:** Easy ✅  
**Next Step:** Start dengan Step 1 ☝️

