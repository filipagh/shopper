import 'package:flutter/material.dart';
import 'package:home_storage/models/shopping_model.dart';
import 'package:home_storage/widgets/form/item.dart';

Future addItemPopup(context, {ShoppingModel? suggestItem}) {
  ItemForm form = ItemForm.addItemForm(referencedItem: suggestItem);
  return _build(context, "Add new Item", form);
}

Future editItemPopup(context, ShoppingModel editedItem) {
  ItemForm form = ItemForm.editItemForm(referencedItem: editedItem);
  return _build(context, "Edit Item", form);
}

Future _build(context, title, form) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
                title: Row(
                  children: [
                    Text(title),
                    const Spacer(),
                    GestureDetector(
                      child: const Icon(Icons.close),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                content: form));
      });
}
