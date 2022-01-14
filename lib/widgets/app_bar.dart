import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/screens/home.dart';
import 'package:home_storage/screens/login.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

PreferredSizeWidget getAppBar() {
  return _customAppBar();
}

class _customAppBar extends HookWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final authModel = useProvider(authProvider);
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName(HomeScreen.navUrl));
        },
        child: Text("Shopper"),
      ),
      actions: [
        if (authModel.isLoggedIn) ...[
          Center(
              child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Text(authModel.user!.email! + "\nLOGOUT", textScaleFactor: 2,))),
        ] else ...[
          Center(
            child: FittedBox(
              child: GestureDetector(
                  child: Text("login", textScaleFactor: 2,),
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
