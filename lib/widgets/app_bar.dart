import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/screens/home.dart';
import 'package:home_storage/screens/login.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

PreferredSizeWidget getAppBar() {
  return _CustomAppBar();
}

class _CustomAppBar extends HookWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final authModel = useProvider(authProvider);
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Route route = ModalRoute.of(context) as Route;
          final routeName = route.settings.name;
          if (routeName != HomeScreen.navUrl) {
            Navigator.pushNamed(context, HomeScreen.navUrl);
          }
        },
        child: const Text("Shopper"),
      ),
      actions: [
        if (authModel.isLoggedIn) ...[
          Center(
              child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    authModel.user!.email! + "\nLOGOUT",
                    textScaleFactor: 1.5,
                  ))),
        ] else ...[
          Center(
            child: FittedBox(
              child: GestureDetector(
                  child: const Text(
                    "login",
                    textScaleFactor: 1.5,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.navUrl);
                  }),
            ),
          )
        ]
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
