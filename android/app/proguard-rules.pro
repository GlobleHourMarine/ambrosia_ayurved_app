# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ========== Play Core Library Rules ==========
# Keep all Play Core classes
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.** { *; }

# Keep all interfaces (needed for callbacks)
-keep public interface com.google.android.play.core.tasks.** { *; }

# Keep SplitCompatApplication and related classes
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }

# Keep listener interfaces
-keep public interface com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener { *; }

# Keep task-related classes
-keep class com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }

# Keep all methods in these classes
-keepclassmembers class com.google.android.play.core.splitinstall.SplitInstallRequest { *; }
-keepclassmembers class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }

# Suppress warnings from Play Core
-dontwarn com.google.android.play.**

# Keep your app's classes
-keep class com.app.ambrosiaayurved.** { *; }

# Keep Flutter annotations
-keepclassmembers class * {
    @flutter.** *;
}

# Gson rules (for JSON parsing)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# HTTP client rules
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# Lottie animation rules
-keep class com.airbnb.lottie.** { *; }
-dontwarn com.airbnb.lottie.**

# Provider package rules
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

# Keep serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep model classes (adjust package name as needed)
-keep class com.app.ambrosiaayurved.models.** { *; }

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep classes with custom constructors
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# Keep Activity subclasses
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Keep line numbers for debugging stack traces
-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
-renamesourcefileattribute SourceFile

# -------------------------------
# Firebase Messaging
# -------------------------------
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**

# Firebase Analytics
-keep class com.google.firebase.analytics.** { *; }
-dontwarn com.google.firebase.analytics.**

# Firebase Installations (needed for token refresh)
-keep class com.google.firebase.installations.** { *; }
-dontwarn com.google.firebase.installations.**

# Firebase Common
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# -------------------------------
# Google Play Services
# -------------------------------
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# -------------------------------
# WorkManager (used internally by Firebase)
# -------------------------------
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
