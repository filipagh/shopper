import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/utils/navigator/navigator_app.dart';

import 'conf/configure_nonweb.dart' if (dart.library.html) 'conf/configure_web.dart';
import 'secrets.dart';

FirebaseOptions get firebaseOptions {
  return const FirebaseOptions(
    appId: appId,
    apiKey: firebaseApiKey,
    projectId: projectId2,
    messagingSenderId: messagingSenderId2,
  );
}

Future<void> main() async {
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  configureApp();
  runApp(NavigatorCustom());
}
