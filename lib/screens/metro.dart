import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/models/shopping_model.dart';
import 'package:home_storage/services/firebase_db/metro_repo.dart';
import 'package:home_storage/states/all_items.dart';
import 'package:home_storage/states/metro.dart';
import 'package:home_storage/utils/navigator/navigator_app.dart';
import 'package:home_storage/widgets/app_bar.dart';
import 'package:home_storage/widgets/menu.dart';
import 'package:home_storage/widgets/popups/item_popup.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MetroListScreen extends HookWidget {
  static const navUrl = '/metro';

  final searchQueryState = "";

  const MetroListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MetroItemsListener.addListener();
    AllItemsListener.addListener();

    final allItems = useProvider(allItemsProvider);
    final metroItems = useProvider(metroItemsProvider);
    final searchQuery = useState(searchQueryState);

    Widget buildList() {
      var filteredItems =
          processItemList(searchQuery.value, metroItems.items, allItems.items);
      return ListView.builder(
        shrinkWrap: true,
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final tile = filteredItems[index];
          return tile.buildTile();
        },
      );
    }

    return Scaffold(
      drawer: getMenu(context),
      appBar: getAppBar(),
      floatingActionButton: const FloatAddItemButton(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50),
                child: Row(
                  children: const [
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          "Metro",
                          // textScaleFactor: 3,
                        ),
                      ),
                    ),
                    Spacer(),
                    _PopupMenu()
                  ],
                ),
              ),
              const Divider(),
              SearchBar(searchQuery: searchQuery),
              const Divider(),
              if (!metroItems.isLoaded) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                          scale: 4, child: CircularProgressIndicator()),
                    ],
                  ),
                )
              ] else if (metroItems.items.isEmpty) ...[
                Column(
                  children: [
                    Text("Your list is empty"),
                    ElevatedButton(
                      onPressed: () {
                        MetroRepo.insertItems(allItems.items);
                      },
                      child: Text("Create new list from All items"),
                    )
                  ],
                )
              ] else ...[
                Expanded(child: buildList()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<_Tile> processItemList(
      String query, List<ShoppingModel> items, List<ShoppingModel> allItems) {
    var filteredItems = items;
    List<_Tile> finalTiles = [];
    if (query.isNotEmpty) {
      filteredItems = filteredItems
          .where((element) =>
              element.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    for (var element in filteredItems) {
      finalTiles.add(_ItemTile(element, Colors.lightBlue[100]!));
    }
    if (query.isNotEmpty) {
      List<ShoppingModel> removedItems = allItems
          .where((element) =>
              element.text.toLowerCase().contains(query.toLowerCase()))
          .toList();

      for (var addedItem in finalTiles) {
        for (var rmItem in removedItems) {
          if (addedItem.item.text == rmItem.text) {
            removedItems.remove(rmItem);
            break;
          }
        }
      }
      for (var element in removedItems) {
        finalTiles.add(_RemovedItemTile(element));
      }
    }

    if (isPossibleToAddItem(query, finalTiles.length)) {
      finalTiles.add(_AddItemTile(ShoppingModel(query)));
    }

    return finalTiles;
  }

  bool isPossibleToAddItem(String query, int itemsCount) {
    if (itemsCount < 6 && query.isNotEmpty) {
      return true;
    }
    return false;
  }
}

class _PopupMenu extends HookWidget {
  const _PopupMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allItems = useProvider(allItemsProvider);
    return Expanded(
      child: FittedBox(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<String>(
          onSelected: (String result) {
            switch (result) {
              case 'Load All Items':
                MetroRepo.clearList();
                MetroRepo.insertItems(allItems.items);
                break;
              case 'Clear All':
                MetroRepo.clearList();
                break;
              default:
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Load All Items',
              child: Text('Load All Items'),
            ),
            const PopupMenuItem<String>(
              value: 'Clear All',
              child: Text('Clear All'),
            ),
          ],
          child: const Icon(
            Icons.more_vert,
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  final ValueNotifier<String> searchQuery;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          hintText: "search"),
      onChanged: (text) {
        searchQuery.value = text;
      },
    );
  }
}

class FloatAddItemButton extends StatelessWidget {
  const FloatAddItemButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        addItemPopup(context);
      },
    );
  }
}

class _ItemTile implements _Tile {
  @override
  Widget buildTile() {
    return Dismissible(
      background: Container(color: Colors.red[200]),
      key: ObjectKey(item),
      onDismissed: (direction) {
        MetroRepo.deleteItem(item);
        ScaffoldMessenger.of(NavigatorCustom.navigatorKey.currentContext!)
            .showSnackBar(SnackBar(content: Row(
              children: [
                Text('${item.text} dismissed'),
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(NavigatorCustom.navigatorKey.currentContext!).hideCurrentSnackBar();
                      MetroRepo.insertShoppItem(item);
                      ScaffoldMessenger.of(NavigatorCustom.navigatorKey.currentContext!)
                          .showSnackBar(SnackBar(content: Text("reverted")));
                      },
                    child: Text("revert"))
              ],
            )));
      },
      child: Card(
        color: Colors.lightBlue[100],
        child: ListTile(
          trailing:
              GestureDetector(onTap: () {}, child: const Icon(Icons.note_add)),
          title: Text(item.text),
          subtitle: null,
        ),
      ),
    );
  }

  _ItemTile(this.item, this.color);

  @override
  ShoppingModel item;
  Color color;
}

class _RemovedItemTile implements _Tile {
  @override
  Widget buildTile() {
    return Card(
      color: Colors.red[100],
      child: ListTile(
        trailing: GestureDetector(
            onTap: () {
              MetroRepo.insertShoppItem(item);
            },
            child: const Icon(Icons.add)),
        title: Text(item.text),
        subtitle: null,
      ),
    );
  }

  _RemovedItemTile(this.item);

  @override
  ShoppingModel item;
}

class _AddItemTile implements _Tile {
  @override
  Widget buildTile() {
    return Card(
      color: Colors.lightGreen,
      child: ListTile(
        onTap: () {
          addItemPopup(NavigatorCustom.navigatorKey.currentContext!,
                  suggestItem: item)
              .then((item) {
            MetroRepo.insertShoppItem(item);
            if (item != null) {
              MetroRepo.insertShoppItem(item);
            }
          });
        },
        title: Row(
          children: [
            Text("Add item: ${item.text}"),
            const Spacer(),
            const Icon(Icons.add),
          ],
        ),
      ),
    );
  }

  _AddItemTile(this.item);

  @override
  ShoppingModel item;
}

abstract class _Tile {
  late ShoppingModel item;

  Widget buildTile();
}
