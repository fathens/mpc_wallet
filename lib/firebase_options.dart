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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0WzymNUXYOp-4dxw61IiajiIGXCJ0r9s',
    appId: '1:904340595483:web:bdd6318f1f796b36ca69be',
    messagingSenderId: '904340595483',
    projectId: 'mpc-wallet-c5a4b',
    authDomain: 'mpc-wallet-c5a4b.firebaseapp.com',
    storageBucket: 'mpc-wallet-c5a4b.appspot.com',
    measurementId: 'G-FETTJVP0B6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDoXI0dPLoi77w60YdeAJWDM8r_30j_GFU',
    appId: '1:904340595483:android:412843a0be1c2fbaca69be',
    messagingSenderId: '904340595483',
    projectId: 'mpc-wallet-c5a4b',
    storageBucket: 'mpc-wallet-c5a4b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDA_w7kHsIOOkKZayPNUN8TnI8DbPxiWe8',
    appId: '1:904340595483:ios:d045137fb977f6dbca69be',
    messagingSenderId: '904340595483',
    projectId: 'mpc-wallet-c5a4b',
    storageBucket: 'mpc-wallet-c5a4b.appspot.com',
    iosClientId: '904340595483-9v7ptc7jmrr34filrenvj7f48926ejrd.apps.googleusercontent.com',
    iosBundleId: 'com.example.mpcWallet',
  );
}
