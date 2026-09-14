import 'package:flutter_riverpod/legacy.dart';

enum AppUserState { loggedOut, loggedIn }

final StateProvider<AppUserState> appStateProvider = StateProvider(
  (ref) => AppUserState.loggedOut,
);

final StateProvider<String> accountTypeProvider = StateProvider((ref) => '');

enum AppState { initial, loading, error, success }

final StateProvider<String> useridProvider = StateProvider((ref) => '');
