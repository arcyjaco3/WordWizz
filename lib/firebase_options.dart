// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBfdr1P-CntPowdgt5Vrur6TdJ1ZlbecPc',
    appId: '1:934484124693:web:0381348adc9de36f44da1c',
    messagingSenderId: '934484124693',
    projectId: 'wordwizz-e114b',
    authDomain: 'wordwizz-e114b.firebaseapp.com',
    storageBucket: 'wordwizz-e114b.appspot.com',
    measurementId: 'G-CJBLZW8Z41',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbStAiV6UDY3eO6zf5zMDnLwHaycEMXRw',
    appId: '1:934484124693:android:fd994285f1b9d9ce44da1c',
    messagingSenderId: '934484124693',
    projectId: 'wordwizz-e114b',
    storageBucket: 'wordwizz-e114b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCfZK77N7fz8FuTU0szpu-r6GvVcVhi78',
    appId: '1:934484124693:ios:0c835da8821e1b3c44da1c',
    messagingSenderId: '934484124693',
    projectId: 'wordwizz-e114b',
    storageBucket: 'wordwizz-e114b.appspot.com',
    iosClientId: '934484124693-aljv0co6q19629pceusmh9oca9qdbuna.apps.googleusercontent.com',
    iosBundleId: 'com.example.wordwiz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCfZK77N7fz8FuTU0szpu-r6GvVcVhi78',
    appId: '1:934484124693:ios:474557ea4acd768b44da1c',
    messagingSenderId: '934484124693',
    projectId: 'wordwizz-e114b',
    storageBucket: 'wordwizz-e114b.appspot.com',
    iosClientId: '934484124693-cooqdaa8ad0snqkpqakc7430a4sosn0e.apps.googleusercontent.com',
    iosBundleId: 'com.example.wordwizz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBfdr1P-CntPowdgt5Vrur6TdJ1ZlbecPc',
    appId: '1:934484124693:web:d821d2c3c663c35d44da1c',
    messagingSenderId: '934484124693',
    projectId: 'wordwizz-e114b',
    authDomain: 'wordwizz-e114b.firebaseapp.com',
    storageBucket: 'wordwizz-e114b.appspot.com',
    measurementId: 'G-QZYDYYT2V5',
  );
}
