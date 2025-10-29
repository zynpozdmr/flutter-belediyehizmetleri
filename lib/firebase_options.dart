import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAxVmjRr2seDIYdM38VcYHx21tpv1QFnCo',
    appId: '1:108486664390:web:a68e0843af3d28da84f7c7',
    messagingSenderId: '108486664390',
    projectId: 'fluttermunicipalservices',
    authDomain: 'fluttermunicipalservices.firebaseapp.com',
    storageBucket: 'fluttermunicipalservices.firebasestorage.app',
    measurementId: 'G-67H0ZLN9EP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIQeNmtI5HrpYZeqG9-ksOvwmmkqpAtqQ',
    appId: '1:108486664390:android:64eacce83732bd7984f7c7',
    messagingSenderId: '108486664390',
    projectId: 'fluttermunicipalservices',
    storageBucket: 'fluttermunicipalservices.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDwztExTyPscB56CoRiTWY5YfZVvh5Hpg',
    appId: '1:108486664390:ios:f4da6618e06699a884f7c7',
    messagingSenderId: '108486664390',
    projectId: 'fluttermunicipalservices',
    storageBucket: 'fluttermunicipalservices.firebasestorage.app',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDwztExTyPscB56CoRiTWY5YfZVvh5Hpg',
    appId: '1:108486664390:ios:f4da6618e06699a884f7c7',
    messagingSenderId: '108486664390',
    projectId: 'fluttermunicipalservices',
    storageBucket: 'fluttermunicipalservices.firebasestorage.app',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxVmjRr2seDIYdM38VcYHx21tpv1QFnCo',
    appId: '1:108486664390:web:09dadc6fc951bf7f84f7c7',
    messagingSenderId: '108486664390',
    projectId: 'fluttermunicipalservices',
    authDomain: 'fluttermunicipalservices.firebaseapp.com',
    storageBucket: 'fluttermunicipalservices.firebasestorage.app',
    measurementId: 'G-88T893B1NT',
  );
}
