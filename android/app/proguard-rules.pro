# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Keep the HTTP package models (if you use any reflection-based libs)
# (not strictly necessary here, but a good template)
-dontwarn okhttp3.**
-dontwarn okio.**

# If you add JSON serialization packages (e.g. json_serializable), keep their annotations:
-keep @com.fasterxml.jackson.annotation.JsonProperty class *
-keep class com.fasterxml.jackson.** { *; }
