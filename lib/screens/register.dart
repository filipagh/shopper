import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/widgets/form/login.dart';
import 'package:home_storage/widgets/form/register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const navUrl = '/register';

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AlertDialog(
        title: Text("Register"),
        content: RegisterForm(),
      ),
    ]);

    return Scaffold(
      appBar: AppBar(),
      body: Center(child: LoginForm()),
    );
  }
}
