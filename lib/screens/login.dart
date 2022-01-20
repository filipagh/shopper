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
        title: Row(
          children: [
            const Text("Login"),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("close"),
            ),
          ],
        ),
        content: Column(
          children: const [
            LoginForm(),
          ],
        ),
      ),
    ]);
  }
}
