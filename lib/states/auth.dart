import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthModel {
  const AuthModel(this.isLoggedIn, this.user, this.isAppInitialized);

  final bool isAppInitialized;
  final User? user;
  final bool isLoggedIn;
}

class AuthNotifier extends StateNotifier<AuthModel> {
  AuthNotifier() : super(_initialValue);
  static const _initialValue = AuthModel(false, null, false);

  void changeStatus(User? user) {
    state = AuthModel(user != null ? true : false, user, true);
  }

  void logOut() {
    state = const AuthModel(false, null, true);
  }
}
