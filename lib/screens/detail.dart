import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/widgets/app_bar.dart';
import 'package:home_storage/widgets/menu.dart';

class DetailScreen extends StatelessWidget {
  final String? id;

  const DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getMenu(context),
      appBar: getAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Viewing details for item $id'),
            TextButton(
              child: const Text('next!'),
              onPressed: () {
                Navigator.pushNamed(context, '/xxx/${id! + "1"}');
              },
            ),
            TextButton(
              child: const Text('Pop!'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.popUntil(context, (route) => route.isFirst);
                // Navigator.of(context)
                //     .popUntil(ModalRoute.withName("/"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
