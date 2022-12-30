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
    apiKey: 'AIzaSyApiKHDMQ5aTyLzI2ypWyfWHN0xESw3gig',
    appId: '1:401730393508:web:773e30554c938320df5d31',
    messagingSenderId: '401730393508',
    projectId: 'fir-2e426',
    authDomain: 'fir-2e426.firebaseapp.com',
    storageBucket: 'fir-2e426.appspot.com',
    measurementId: 'G-SNFB3TR20B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZnaNtfp1mXhNxKLErAZVqWHwXOZxl8cI',
    appId: '1:401730393508:android:f490d2fc8458483fdf5d31',
    messagingSenderId: '401730393508',
    projectId: 'fir-2e426',
    storageBucket: 'fir-2e426.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChzv89xOe5rV8QbeSCJ_lEbusXTSbuudQ',
    appId: '1:401730393508:ios:2ce29f415ee9ea76df5d31',
    messagingSenderId: '401730393508',
    projectId: 'fir-2e426',
    storageBucket: 'fir-2e426.appspot.com',
    iosClientId: '401730393508-oafk4suc94eo9gcmajd50jj6n81j3lie.apps.googleusercontent.com',
    iosBundleId: 'com.example.employeeDatabaseApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChzv89xOe5rV8QbeSCJ_lEbusXTSbuudQ',
    appId: '1:401730393508:ios:2ce29f415ee9ea76df5d31',
    messagingSenderId: '401730393508',
    projectId: 'fir-2e426',
    storageBucket: 'fir-2e426.appspot.com',
    iosClientId: '401730393508-oafk4suc94eo9gcmajd50jj6n81j3lie.apps.googleusercontent.com',
    iosBundleId: 'com.example.employeeDatabaseApp',
  );
}