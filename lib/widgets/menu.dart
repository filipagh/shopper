import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/screens/all_items.dart';
import 'package:home_storage/screens/metro.dart';

Widget getMenu(BuildContext context) {
  return Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
    child: ListView(
// Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Drawer Header'),
        ),
        ListTile(
          title: const Text('All items'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AllItemsScreen.navUrl);
// Update the state of the app.
// ...
          },
        ),
        ListTile(
          title: const Text('Metro'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, MetroListScreen.navUrl);
// Update the state of the app.
// ...
          },
        ),
      ],
    ),
  );
}
