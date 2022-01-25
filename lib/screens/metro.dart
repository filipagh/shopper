import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/models/shopping_model.dart';
import 'package:home_storage/services/firebase_db/item_repo.dart';
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

    final allItems = useProvider(allItemsProvider);
    final metroItems = useProvider(metroItemsProvider);
    final searchQuery = useState(searchQueryState);

    Widget buildList() {
      var filteredItems = processItemList(searchQuery.value, metroItems.items);
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
                      Transform.scale(scale: 4,child: CircularProgressIndicator()),
                    ],
                  ),
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

  List<_Tile> processItemList(String query, List<ShoppingModel> items) {
    var filteredItems = items;
    List<_Tile> finalTiles = [];
    if (query.isNotEmpty) {
      filteredItems = filteredItems
          .where((element) =>
          element.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    for (var element in filteredItems) {
      finalTiles.add(_ItemTile(element));
    }
    if (isPossibleToAddItem(query, filteredItems.length)) {
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

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<String>(
          onSelected: (String result) {
            switch (result) {
              case 'option1':
                print('option 1 clicked');
                break;
              case 'option2':
                print('option 2 clicked');
                break;
              case 'delete':
                print('I want to delete');
                break;
              default:
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'option1',
              child: Text('Option 1'),
            ),
            const PopupMenuItem<String>(
              value: 'option2',
              child: Text('Option 2'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          child: Icon(Icons.more_vert,),
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
      key: ObjectKey(item),
      onDismissed: (direction) {},
      child: Card(
        color: Colors.blueAccent,
        child: ListTile(
          onTap: () {
            editItemPopup(NavigatorCustom.navigatorKey.currentContext!, item);
          },
          trailing: GestureDetector(
              onTap: () {
                ItemRepo.deleteItem(item);
              },
              child: const Icon(Icons.delete)),
          title: Text(item.text),
          subtitle: null,
        ),
      ),
    );
  }

  _ItemTile(this.item);

  @override
  ShoppingModel item;
}

class _AddItemTile implements _Tile {
  @override
  Widget buildTile() {
    return ListTile(
      onTap: () {
        addItemPopup(NavigatorCustom.navigatorKey.currentContext!,
            suggestItem: item);
      },
      title: Row(
        children: [
          Text("Add item: ${item.text}"),
          const Spacer(),
          const Icon(Icons.add),
        ],
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
