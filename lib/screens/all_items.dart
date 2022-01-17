import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/states/all_items.dart';
import 'package:home_storage/widgets/app_bar.dart';
import 'package:home_storage/widgets/menu.dart';
import 'package:hooks_riverpod/all.dart';

class AllItemsScreen extends HookWidget {
  static const navUrl = '/items';

  const AllItemsScreen();

  @override
  Widget build(BuildContext context) {
    AllItemsListener.addListener();
    final allItems = useProvider(allItemsProvider);


    return Scaffold(
      drawer: getMenu(context),
      appBar: getAppBar(),
      body: ListView.builder(
        itemCount: allItems.items.length,
        itemBuilder: (context, index) {
          final item = allItems.items[index];
          return ListTile(
            title: Text(item.text),
            subtitle: Text(item.text),
          );
        },
      ),
    );
  }
}
