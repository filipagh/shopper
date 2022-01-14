
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/widgets/app_bar.dart';

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}
