// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB4mKMFjuCDQtqipv7bl5D6KbOvHaib-P0',
    appId: '1:674229634836:web:d045b9f620e52f88936401',
    messagingSenderId: '674229634836',
    projectId: 'fcm-sentry',
    authDomain: 'fcm-sentry.firebaseapp.com',
    storageBucket: 'fcm-sentry.appspot.com',
    measurementId: 'G-VKMDT62HB6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgM-BgMQv4pks6_dtDwne4oNI0Q8Ap4SM',
    appId: '1:674229634836:android:465b78eddc581206936401',
    messagingSenderId: '674229634836',
    projectId: 'fcm-sentry',
    storageBucket: 'fcm-sentry.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRqUwMX8dhVHtJWLie2dnbHnT7TV7flg0',
    appId: '1:674229634836:ios:a5edff2b7a075aab936401',
    messagingSenderId: '674229634836',
    projectId: 'fcm-sentry',
    storageBucket: 'fcm-sentry.appspot.com',
    iosClientId: '674229634836-5q4vbg1e2l90o2ngqlod0m03k4noucog.apps.googleusercontent.com',
    iosBundleId: 'com.example.trackLocation',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCRqUwMX8dhVHtJWLie2dnbHnT7TV7flg0',
    appId: '1:674229634836:ios:a5edff2b7a075aab936401',
    messagingSenderId: '674229634836',
    projectId: 'fcm-sentry',
    storageBucket: 'fcm-sentry.appspot.com',
    iosClientId: '674229634836-5q4vbg1e2l90o2ngqlod0m03k4noucog.apps.googleusercontent.com',
    iosBundleId: 'com.example.trackLocation',
  );
}
