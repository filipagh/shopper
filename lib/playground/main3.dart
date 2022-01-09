import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'counter.dart';
void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final provider = StateNotifierProvider<CounterNotifier, CounterModel>(
      (ref) => CounterNotifier(),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counterModel = useProvider(provider);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '${counterModel.count}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {context.read(provider.notifier).increment();},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
