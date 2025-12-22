# 📱 Build & Deploy Guide - Jadwal Sholat Fix

## Pre-Build Checklist

### Step 1: Verify Network Config (RELEASE mode)
**File:** `android/app/src/main/res/xml/network_security_config.xml`

Untuk production build:
```xml
<!-- Debug overrides - COMMENT OUT untuk release! -->
<!-- 
<debug-overrides>
    <trust-anchors>
        <certificates src="system" />
        <certificates src="user" />
    </trust-anchors>
</debug-overrides> 
-->
```

### Step 2: Verify Permissions
**File:** `android/app/src/main/AndroidManifest.xml`

Pastikan ada:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

### Step 3: Check API Service
**File:** `lib/data/services/api_service.dart`

Pastikan:
```dart
static const String baseUrl = 'https://api.aladhan.com/v1/timingsByCity';
static const int connectionTimeout = 30; // 30 detik
```

---

## Build Process

### Option 1: Build APK (for testing on device)

```bash
# Navigate to project
cd /home/zack/Documents/project-masjidSabilillah_1

# Clean build
flutter clean
flutter pub get

# Build debug APK
flutter build apk --debug

# Output: build/app/outputs/flutter-app.apk
```

### Option 2: Build Release APK (for app store)

```bash
# Clean build
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-app.apk
```

### Option 3: Build App Bundle (for Google Play)

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## Testing on Device

### Install APK
```bash
# Connect device via USB with debug mode ON
adb devices  # Verify device is connected

# Install APK
adb install -r build/app/outputs/flutter-app.apk

# Or use flutter
flutter run --release
```

### Monitor Logs
```bash
# Open logcat
adb logcat

# Filter for relevant logs
adb logcat | grep -E "API Service|CachedApiService|PrayerTimesScreen|Exception"
```

### Test Prayer Schedule Screen
1. Open app
2. Tap navigation to "Jadwal Sholat"
3. Wait for loading...
4. Should display prayer times

If error appears:
- Check logcat output
- Tap "Coba Lagi" button
- Try different city
- Check internet connection

---

## Troubleshooting During Build

### Issue: "Unable to resolve dependency"
```bash
flutter pub get
flutter clean
flutter pub get
```

### Issue: "SSL Certificate Error"
✅ Already fixed in `network_security_config.xml`
- System CA trust configured
- Debug overrides for development

### Issue: "Network Timeout"
✅ Timeout increased to 30 seconds
- Check internet connection quality
- Verify API endpoint is accessible

### Issue: "Gradle Build Failed"
```bash
# Clean gradle
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --debug
```

---

## Post-Build Checklist

- [ ] APK built successfully
- [ ] File size is reasonable (~50-100MB)
- [ ] Signature is valid (for release)
- [ ] APK installs on device
- [ ] App launches without crash
- [ ] Jadwal Sholat screen loads
- [ ] Data displays correctly
- [ ] Retry button works
- [ ] Logcat shows no errors

---

## Deployment to Google Play

### Prerequisites
- Android keystore configured
- Play Store developer account
- App version updated in `pubspec.yaml`

### Steps
1. Create app signing key:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10950 \
     -alias upload
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=<from_keytool>
   keyPassword=<from_keytool>
   keyAlias=upload
   storeFile=/path/to/upload-keystore.jks
   ```

3. Build app bundle:
   ```bash
   flutter build appbundle --release
   ```

4. Upload to Play Console:
   - Go to Play Console > Your App > Release
   - Upload `build/app/outputs/bundle/release/app-release.aab`

---

## Version Management

Update in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

Format: `major.minor.patch+buildNumber`

---

## Monitoring After Deployment

### Track Issues
- Monitor logcat for errors
- Collect user feedback
- Check Play Store reviews

### Logs to Watch
```
[API Service] - API call status
[CachedApiService] - Cache operations
[PrayerTimesScreen] - UI rendering
```

---

## Rollback Plan

If critical issue found:
1. Build new APK with fixes
2. Test thoroughly on device
3. Upload new version to Play Store
4. Notify users if needed

---

## Summary

✅ Network security configured for HTTPS
✅ API service with proper headers and timeout
✅ Cache fallback mechanism
✅ Error handling and user feedback
✅ Mock data for offline fallback
✅ Build and deployment process documented

**Ready to build and deploy!** 🚀

---

**Last Updated:** December 22, 2025
