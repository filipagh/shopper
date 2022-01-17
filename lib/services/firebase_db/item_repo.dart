import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:home_storage/models/shopping_model.dart';

class ItemRepo {

  static final DatabaseReference _ref = FirebaseDatabase.instance.ref("/items");

  Future<void> insertShoppItem(ShoppingModel item) async {
    await _ref.set(jsonEncode(item));
  }

  static Stream<DatabaseEvent> getStream() {
    return _ref.onValue;
  }

}


