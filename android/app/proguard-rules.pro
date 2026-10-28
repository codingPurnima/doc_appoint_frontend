# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Dart/Flutter native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep our classes
-keep class com.example.doc_appoint_frontend.** { *; }

# Riverpod & Provider
-keep class riverpod.** { *; }
-keep class flutter_riverpod.** { *; }

# HTTP
-keep class io.flutter.plugins.urllauncher.** { *; }

# Secure Storage
-keep class com.firebase.** { *; }

# JSON serialization
-keepclassmembers class * {
    *** *Factory();
}

# Enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Collections
-keep class java.util.** { *; }
-keep class java.lang.** { *; }
