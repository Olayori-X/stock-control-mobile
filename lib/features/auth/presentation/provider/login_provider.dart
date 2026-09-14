import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/auth/domain/repositories/pin_login_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final userIdInputProvider = StateProvider<String>((ref) => '');
final pinInputProvider = StateProvider<String>((ref) => '');

final StateProvider<AppState> loginStateProvider = StateProvider(
  (ref) => AppState.initial,
);

final StateProvider<String> loginErrorMessageProvider = StateProvider(
  (ref) => "",
);

final StateProvider<PinLoginResult?> loginResponseProvider = StateProvider(
  (ref) => null,
);

// Distinct from the generic loginErrorMessageProvider so the UI can show
// a dedicated "you're not near your planned route" state rather than a
// generic error banner — the resumption check fails through the same
// error path as everything else, but deserves clearer messaging.
final StateProvider<bool> resumptionFailedProvider = StateProvider(
  (ref) => false,
);