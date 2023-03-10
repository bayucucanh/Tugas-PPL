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
    apiKey: 'AIzaSyB4utetA217otmnx7HVlxHYoeqIR7DwXkc',
    appId: '1:143834371075:web:66f343814cb1f380d42a36',
    messagingSenderId: '143834371075',
    projectId: 'pssi-bcfac',
    authDomain: 'pssi-bcfac.firebaseapp.com',
    storageBucket: 'pssi-bcfac.appspot.com',
    measurementId: 'G-54NMXHHDEP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAz9J3bBdD7UkJpdgSQwAuDDNt17Kk_dCA',
    appId: '1:143834371075:android:286e315813bfc463d42a36',
    messagingSenderId: '143834371075',
    projectId: 'pssi-bcfac',
    storageBucket: 'pssi-bcfac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBW3yKvs7a9JG84R4IlDyoyOxzaTeZIMF0',
    appId: '1:143834371075:ios:03f33b79112619f3d42a36',
    messagingSenderId: '143834371075',
    projectId: 'pssi-bcfac',
    storageBucket: 'pssi-bcfac.appspot.com',
    androidClientId: '143834371075-810rpfnng6u3vcse9ad7tckro3u6f78f.apps.googleusercontent.com',
    iosClientId: '143834371075-h8jqsht30aa13mtdct3tv0q5pp9tf4tn.apps.googleusercontent.com',
    iosBundleId: 'com.kunci.mobilePssi',
  );
}
