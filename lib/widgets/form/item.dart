// Create a Form widget.
import 'package:flutter/material.dart';
import 'package:home_storage/models/shopping_model.dart';
import 'package:home_storage/services/firebase_db/item_repo.dart';
import 'package:home_storage/widgets/validator/empty_string_validator.dart';
import 'package:home_storage/widgets/validator/utils/multy_validator.dart';

class ItemForm extends StatefulWidget {
  final ShoppingModel? referencedItem;
  late String buttonText;
  late Function(ShoppingModel) submitFunc;

  ItemForm.addItemForm({Key? key, this.referencedItem}) : super(key: key) {
    buttonText = "Add";
    submitFunc = (ShoppingModel item) => _addItem(item);
  }

  ItemForm.editItemForm({Key? key, required this.referencedItem})
      : super(key: key) {
    buttonText = "Edit";
    submitFunc = (ShoppingModel item) => _editItem(item, referencedItem!);
  }

  @override
  ItemFormState createState() {
    return ItemFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ItemFormState extends State<ItemForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  ItemFormState();

  @override
  Widget build(BuildContext context) {
    String? text;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: widget.referencedItem?.text,
            decoration: const InputDecoration(
                icon: Icon(Icons.create), labelText: "Name"),
            autofocus: true,
            onSaved: (value) {
              text = value;
            },
            validator: (value) {
              return multyValidate(
                  [EmptyValidator(value, "enter name of item")]);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.submitFunc(ShoppingModel(text!));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _editItem(ShoppingModel newItem, ShoppingModel replaceFor) {
  ItemRepo.replace(newItem, replaceFor);
}

void _addItem(ShoppingModel item) {
  ItemRepo.insertShoppItem(item);
}
