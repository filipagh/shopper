import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/widgets/form/login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const navUrl = '/login';

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AlertDialog(
        title: Text("Login"),
        content: LoginForm(),
      ),
    ]);

    return Scaffold(
      appBar: AppBar(),
      body: Center(child: LoginForm()),
    );
  }
}
