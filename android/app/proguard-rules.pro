#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

-keep class androidx.lifecycle.DefaultLifecycleObserver

-keep class org.spongycastle.** { *; }
-dontwarn org.spongycastle.**
-keep class com.github.chinloyal.pusher_client.** { *; }