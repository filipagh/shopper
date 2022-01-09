
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_storage/widgets/menu.dart';

class DetailScreen extends StatelessWidget {
  String? id;

  DetailScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getMenu(context),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Viewing details for item $id'),
            FlatButton(
              child: Text('next!'),
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    '/xxx/${id! + "1"}'
                );
              },
            ),
            FlatButton(
              child: Text('Pop!'),
              onPressed: () {
                Navigator.of(context)
                    .pop();
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
