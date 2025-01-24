# Keep Stripe classes
-dontwarn com.stripe.android.**
-keep class com.stripe.android.** { *; }

# Keep React Native Stripe SDK classes
-dontwarn com.reactnativestripesdk.**
-keep class com.reactnativestripesdk.** { *; }

# Preserve Activity and related classes used by Stripe Push Provisioning
-keep class com.stripe.android.pushProvisioning.** { *; }

# Prevent optimizations that might remove or inline methods
-optimizations !method/inlining/

# Keep Parcelable classes (required by Stripe SDK for intents)
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}