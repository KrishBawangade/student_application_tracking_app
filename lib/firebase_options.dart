import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default : {
        
      }
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

// Replace these values with your Firebase project configurations
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuF8tR0q7nJNqgVsC7Snh3aKZl2SLnQQA',
    appId: '1:321626572122:android:22880ca196145149499f63',
    messagingSenderId: '321626572122',
    projectId: 'student-application-trac-725a5',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDedJZXxAV4l3XefheR8OmNUEXJQW1RVLY',
    appId: '1:321626572122:ios:8f3c0fbe86312612499f63',
    messagingSenderId: '321626572122',
    projectId: 'student-application-trac-725a5',
    iosBundleId: 'com.example.studentApplicationTrackingApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_WEB_MESSAGING_SENDER_ID',
    projectId: 'YOUR_WEB_PROJECT_ID',
  );

// FirebaseOptions getFirebaseOptions() {
//   if (kIsWeb) {
//     return webOptions;
//   } else if (defaultTargetPlatform == TargetPlatform.android) {
//     return androidOptions;
//   } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//     return iosOptions;
//   } else {
//     throw UnsupportedError('Platform not supported');
//   }
// }
}
