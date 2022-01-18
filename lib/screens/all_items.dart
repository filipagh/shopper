import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/services/firebase_db/item_repo.dart';
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

      body: Center(
        child: Column(
          children: [
            Text("All Items", textScaleFactor: 3,),
            Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: ListTileTheme(
                    tileColor: Colors.lightBlueAccent,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allItems.items.length,
                      itemBuilder: (context, index) {
                        final item = allItems.items[index];
                        return ListTile(
                          trailing: GestureDetector(
                              onTap: () {ItemRepo.deleteItem(item);},
                              child: Icon(Icons.delete)),
                          title: Text(item.text),
                          subtitle: Text(item.text),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
