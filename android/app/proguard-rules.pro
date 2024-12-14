# Regras para Flutter
-keep class io.flutter.** { *; }
-keep class com.google.** { *; }
-keepattributes *Annotation*

# Regras para Sqflite
-keep class android.database.sqlite.** { *; }
-keep class android.database.** { *; }
-keep class io.flutter.plugins.sqflite.** { *; }

# Outras configurações comuns
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-dontwarn okio.**
-dontwarn okhttp3.**
