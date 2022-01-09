// Create a Form widget.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/screens/login.dart';
import 'package:home_storage/widgets/validator/empty_string_validator.dart';
import 'package:home_storage/widgets/validator/identity_validator.dart';
import 'package:home_storage/widgets/validator/mail_validator.dart';
import 'package:home_storage/widgets/validator/utils/multy_validator.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _registerFormKey = GlobalKey<FormState>();

  String? emptyValidator(value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController a = TextEditingController(text: "");
    TextEditingController b = TextEditingController(text: "");
    String? mail;
    String? password;
    String? passwordCheck;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _registerFormKey,
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
              return multyValidate(
                  [MailValidator(value, "enter correct Mail adress")]);
            },
          ),
          TextFormField(
            controller: a,
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: "Password"),
            obscureText: true,
            onSaved: (value) {
              password = value;
            },
            validator: (value) {
              return multyValidate([
                EmptyValidator(value, "enter password"),
                IdentityValidator(value, b.text, "passwords does not match")
              ]);
            },
          ),
          TextFormField(
            controller: b,
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: "Password Check"),
            obscureText: true,
            onSaved: (value) {
              password = value;
            },
            validator: (value) {
              return multyValidate([
                EmptyValidator(value, "enter password"),
                IdentityValidator(value, a.text, "passwords does not match")
              ]);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, LoginScreen.navUrl);
                  },
                  child: const Text('Login'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_registerFormKey.currentState!.validate()) {
                      _registerFormKey.currentState!.save();
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: mail!, password: password!);
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //       content: Text(
                      //           '${userCredential.user!.uid} Processing Data')),
                      // );
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
