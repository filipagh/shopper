import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/states/all_items.dart';
import 'package:home_storage/states/auth.dart';
import 'package:home_storage/states/metro.dart';
import 'package:home_storage/utils/navigator/navigator_app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'conf/configure_nonweb.dart'
    if (dart.library.html) 'conf/configure_web.dart';
import 'secrets.dart';

FirebaseOptions get firebaseOptions {
  return const FirebaseOptions(
      appId: appId,
      apiKey: firebaseApiKey,
      projectId: projectId2,
      messagingSenderId: messagingSenderId2,
      databaseURL: dbUrl);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupAuthState();

  configureApp();

  runApp(const ProviderScope(child: NavigatorCustom()));
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>(
  (ref) => AuthNotifier(),
);

final allItemsProvider = StateNotifierProvider<AllItemsNotifier, AllItemsState>(
  (ref) => AllItemsNotifier(),
);

final metroItemsProvider = StateNotifierProvider<MetroNotifier, MetroItemsState>(
  (ref) => MetroNotifier(),
);

Future<void> setupAuthState() async {
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
}
