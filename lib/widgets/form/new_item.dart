// Create a Form widget.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/models/shopping_model.dart';
import 'package:home_storage/services/firebase_db/item_repo.dart';
import 'package:home_storage/widgets/validator/empty_string_validator.dart';
import 'package:home_storage/widgets/validator/utils/multy_validator.dart';

class NewItemForm extends StatefulWidget {
  final String? predefinedName;

  const NewItemForm({Key? key, this.predefinedName}) : super(key: key);

  @override
  NewItemFormState createState() {
    return NewItemFormState(predefinedName);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewItemFormState extends State<NewItemForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  late String? predefinedName;

  NewItemFormState(this.predefinedName);

  @override
  Widget build(BuildContext context) {
    String? text;
    // Build a Form widget using the _formKey created above.
    // return Column(mainAxisAlignment: MainAxisAlignment.center, children: [

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: predefinedName,
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
                      ItemRepo.insertShoppItem(ShoppingModel(text!));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
