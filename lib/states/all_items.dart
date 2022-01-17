
import 'package:firebase_database/firebase_database.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/models/shopping_model.dart';
import 'package:home_storage/services/firebase_db/item_repo.dart';
import 'package:home_storage/utils/navigator/navigator_app.dart';
import 'package:hooks_riverpod/all.dart';

class AllItemsState {
  const AllItemsState(this.items);

  final List<ShoppingModel> items;
}

class AllItemsNotifier extends StateNotifier<AllItemsState> {
  AllItemsNotifier() : super(_initialValue);
  static const _initialValue = AllItemsState([]);

  void replaceList(List<ShoppingModel> list) {
    print("replace");
    state = AllItemsState(list);
  }

}

class AllItemsListener {
  static bool _listen = false;

  static void addListener() {
    print("check");
    if (!_listen) {
      print("add");
      _listen = true;
        ItemRepo.getStream().listen((DatabaseEvent event) {
          List<ShoppingModel> list = [];

          for (var item in event.snapshot.children) {
            list.add(ShoppingModel(item.key!));
          }
          NavigatorCustom.navigatorKey.currentContext!.read(allItemsProvider.notifier).replaceList(list);
            // allItemsProvider.notifier.replaceList(list);
        });
    }
  }
}

