
import 'package:firebase_database/firebase_database.dart';
import 'package:home_storage/models/shopping_model.dart';

class ItemRepo {

  static final DatabaseReference _ref = FirebaseDatabase.instance.ref("/items");

  static Future<void> insertShoppItem(ShoppingModel item) async {
    await _ref.child(item.text).set(true);
  }

  static void deleteItem(ShoppingModel item) {
     _ref.child(item.text).remove();
  }


  static Stream<DatabaseEvent> getStream() {
    return _ref.onValue;
  }

}


