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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBtaGu9hIprt2zC8E_9iJHm0mzm8DmC9jU',
    appId: '1:37080143512:web:1327906d45b4ef2e04e2ed',
    messagingSenderId: '37080143512',
    projectId: 'campus-buddy-de1dd',
    authDomain: 'campus-buddy-de1dd.firebaseapp.com',
    databaseURL: 'https://campus-buddy-de1dd-default-rtdb.firebaseio.com',
    storageBucket: 'campus-buddy-de1dd.appspot.com',
    measurementId: 'G-7296YDVQGS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbYo_r_s9fwd52pSNxGUBjB4asvH4e8mU',
    appId: '1:37080143512:android:f429c870abf3020704e2ed',
    messagingSenderId: '37080143512',
    projectId: 'campus-buddy-de1dd',
    databaseURL: 'https://campus-buddy-de1dd-default-rtdb.firebaseio.com',
    storageBucket: 'campus-buddy-de1dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFHbfh7QpD3w-IA6BdcMuYt2docwWhudI',
    appId: '1:37080143512:ios:a84a3a371a0900e004e2ed',
    messagingSenderId: '37080143512',
    projectId: 'campus-buddy-de1dd',
    databaseURL: 'https://campus-buddy-de1dd-default-rtdb.firebaseio.com',
    storageBucket: 'campus-buddy-de1dd.appspot.com',
    iosClientId: '37080143512-fgtt43hcl8cbnarp73p6ec6cpd31o0hr.apps.googleusercontent.com',
    iosBundleId: 'com.example.campusBuddy',
  );
}
