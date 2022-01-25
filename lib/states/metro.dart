import 'package:firebase_database/firebase_database.dart';
import 'package:home_storage/main.dart';
import 'package:home_storage/models/shopping_model.dart';
import 'package:home_storage/services/firebase_db/metro_repo.dart';
import 'package:home_storage/utils/navigator/navigator_app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MetroItemsState {
  const MetroItemsState(this.items, this.isLoaded);

  final bool isLoaded;
  final List<ShoppingModel> items;
}

class MetroNotifier extends StateNotifier<MetroItemsState> {
  MetroNotifier() : super(_initialValue);
  static const _initialValue = MetroItemsState([], false);

  static void setAllItems() {
    final allItems = useProvider(allItemsProvider).items;
    MetroRepo.insertItems(allItems);
  }

  void replaceList(List<ShoppingModel> list) {
    state = MetroItemsState(list, true);
  }
}

class MetroItemsListener {
  static bool _listen = false;

  static void addListener() {
    if (!_listen) {
      _listen = true;
      MetroRepo.getStream().listen((DatabaseEvent event) {
        List<ShoppingModel> list = [];

        for (var item in event.snapshot.children) {
          list.add(ShoppingModel(item.key!));
        }
        NavigatorCustom.navigatorKey.currentContext!
            .read(metroItemsProvider.notifier)
            .replaceList(list);
      });
    }
  }
}
