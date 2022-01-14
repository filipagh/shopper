import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:home_storage/screens/home.dart';
import 'package:home_storage/screens/login.dart';
import 'package:home_storage/screens/register.dart';
import 'package:home_storage/screens/unknown.dart';
import 'package:home_storage/utils/navigator/regex_custom_path.dart';
import 'package:home_storage/utils/navigator/route_list.dart';

import '../../main.dart';

class NavigatorCustom extends StatelessWidget {
  const NavigatorCustom({Key? key}) : super(key: key);


  void addAuthChangeListener(BuildContext context) {
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        context.read(authProvider.notifier).logOut();
      } else {
        context.read(authProvider.notifier).changeStatus(user);
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    addAuthChangeListener(context);

    return MaterialApp(
      initialRoute:  HomeScreen.navUrl,
      routes: {
        HomeScreen.navUrl: (context) => HomeScreen(),
        LoginScreen.navUrl: (context) => LoginScreen(),
        RegisterScreen.navUrl: (context) => RegisterScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        print(settings.name);
        for (RegexCustomPath path in globalRoutes) {
          final regExpPattern = RegExp(path.pattern);
          if (regExpPattern.hasMatch(settings.name!)) {
            final firstMatch = regExpPattern.firstMatch(settings.name!);
            final match =
                (firstMatch!.groupCount == 1) ? firstMatch.group(1) : null;

            return MaterialPageRoute<void>(
              builder: (context) => path.builder(context, match!),
              settings: settings,
            );
          }
        }
        // If no match is found, [WidgetsApp.onUnknownRoute] handles it.
        return MaterialPageRoute(builder: (context) => UnknownScreen());
      },
    );
  }
}
