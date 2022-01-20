import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/services/firebase_db/item_repo.dart';
import 'package:home_storage/states/all_items.dart';
import 'package:home_storage/widgets/app_bar.dart';
import 'package:home_storage/widgets/form/new_item.dart';
import 'package:home_storage/widgets/menu.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AllItemsScreen extends HookWidget {
  static const navUrl = '/items';

  final searchQueryState = "";

  const AllItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllItemsListener.addListener();

    final allItems = useProvider(allItemsProvider);
    final searchQuery = useState(searchQueryState);

    Widget buildList() {
      var filteredItems = allItems.items;
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        filteredItems = filteredItems
            .where((element) => element.text.toLowerCase().contains(query))
            .toList();
      }

      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return ListTile(
            trailing: GestureDetector(
                onTap: () {
                  ItemRepo.deleteItem(item);
                },
                child: const Icon(Icons.delete)),
            title: Text(item.text),
            subtitle: Text(item.text),
          );
        },
      );
    }

    return Scaffold(
      drawer: getMenu(context),
      appBar: getAppBar(),
      floatingActionButton: const FloatAddItemButton(),
      body: Center(
        child: Column(
          children: [
            const Text(
              "All Items",
              textScaleFactor: 3,
            ),
            const Divider(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Column(
                children: [
                  SearchBar(searchQuery: searchQuery),
                  const Divider(),
                  ListTileTheme(
                      tileColor: Colors.lightBlueAccent, child: buildList()),
                ],
              ),
            ),
          ],
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
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                    title: Row(
                      children: [
                        const Text("Add new item"),
                        const Spacer(),
                        GestureDetector(
                          child: const Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    content: const NewItemForm()));
          },
        );
      },
    );
  }
}
