import 'package:hooks_riverpod/hooks_riverpod.dart';

class CounterModel {
  const CounterModel(this.count);

  final int count;
}



class CounterNotifier extends StateNotifier<CounterModel> {
  CounterNotifier() : super(_initialValue);
  static const _initialValue = CounterModel(0);

  void increment() {
    state = CounterModel(state.count + 1);
  }
}
