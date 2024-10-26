// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example usage:
/// ```dart
/// import 'firebase_options.dart';
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
///
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
        return macos; // Use macOS settings for macOS
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'reconfigure using the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDjonwxI1-_dYeBKrpfmZovBhkoQ3AJZOY',
    appId: '1:927116423153:web:449f9e63475861f8c9de50',
    messagingSenderId: '927116423153',
    projectId: 'batch-a-project',
    authDomain: 'batch-a-project.firebaseapp.com',
    storageBucket: 'batch-a-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0HOmyVyduWE9RUz6cqvnD8hKKnhXlZMg',
    appId: '1:927116423153:android:7de8189c4a60369ac9de50',
    messagingSenderId: '927116423153',
    projectId: 'batch-a-project',
    storageBucket: 'batch-a-project.appspot.com',
  );

  // Common settings for both iOS and macOS
  static const FirebaseOptions commonOptions = FirebaseOptions(
    apiKey: 'AIzaSyBhQNQK5DDoiyiYM2Yp2LttKDMCSTJemow',
    appId: '1:927116423153:ios:41546fcf9c8490efc9de50',
    messagingSenderId: '927116423153',
    projectId: 'batch-a-project',
    storageBucket: 'batch-a-project.appspot.com',
    iosBundleId: 'com.example.docbook',
  );

  static const FirebaseOptions ios = commonOptions;

  static const FirebaseOptions macos = commonOptions;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDjonwxI1-_dYeBKrpfmZovBhkoQ3AJZOY',
    appId: '1:927116423153:web:d11268db02a19bb7c9de50',
    messagingSenderId: '927116423153',
    projectId: 'batch-a-project',
    authDomain: 'batch-a-project.firebaseapp.com',
    storageBucket: 'batch-a-project.appspot.com',
  );
}
