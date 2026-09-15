import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/confirm_outlet_visit_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final StateProvider<AppState> confirmVisitStateProvider = StateProvider(
  (ref) => AppState.initial,
);

final StateProvider<String> confirmVisitErrorMessageProvider = StateProvider(
  (ref) => "",
);

final StateProvider<ConfirmVisitResult?> confirmVisitResultProvider = StateProvider(
  (ref) => null,
);