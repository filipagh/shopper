import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/widgets/app_bar.dart';
import 'package:home_storage/widgets/menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const navUrl = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getMenu(context),
      appBar: getAppBar(),
      body: Center(
        child: TextButton(
          child: const Text('View Details'),
          onPressed: () {
            Navigator.pushNamed(context, '/xxx/488');
          },
        ),
      ),
    );
  }
}
