# HTTP Client library (http package)
-keep class com.** { *; }
-keepclassmembers class com.** { *; }

# JSON serialization (dart:convert)
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes with @JsonSerializable annotation
-keep @com.google.gson.annotations.SerializedName class * { *; }

# Keep model classes
-keep class **.models.** { *; }
-keep class **.models.**$* { *; }

# Keep API services
-keep class **.services.** { *; }
-keep class **.services.**$* { *; }

# Keep services
-keepclasseswithmembernames class * {
    public <init>(...);
}

# Network security
-keep class android.net.** { *; }
-keep interface android.net.** { *; }

# Keep everything in data layer
-keep class **.data.** { *; }

# Keep everything in services layer  
-keep class **.services.** { *; }

# Don't warn about missing classes
-dontwarn java.lang.invoke.**
-dontwarn javax.naming.**
-dontwarn sun.misc.**
-dontwarn sun.reflect.**

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
