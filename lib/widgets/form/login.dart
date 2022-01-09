// Create a Form widget.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/screens/register.dart';
import 'package:home_storage/widgets/validator/empty_string_validator.dart';
import 'package:home_storage/widgets/validator/utils/multy_validator.dart';
import 'package:home_storage/widgets/validator/utils/validator.dart';
import 'package:home_storage/widgets/validator/mail_validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String? emptyValidator(value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String? mail;
    String? password;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.alternate_email), labelText: "Email"),
            autofocus: true,
            onSaved: (value) {
              mail = value;
            },
            validator: (value) {
              return multyValidate([MailValidator(value, "enter correct Mail adress")]);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: "Password"),
            obscureText: true,
            onSaved: (value) {
              password = value;
            },
            validator: (value) {
              return multyValidate([EmptyValidator(value, "enter password")]);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(

              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RegisterScreen.navUrl);
                  },
                  child: const Text('Register'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: mail!, password: password!);
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '${userCredential.user!.uid} Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
