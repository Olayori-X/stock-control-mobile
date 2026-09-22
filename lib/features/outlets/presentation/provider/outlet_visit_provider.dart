import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/confirm_outlet_visit_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final confirmVisitStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);

final confirmVisitErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");

final confirmVisitResultProvider = StateProvider.autoDispose<ConfirmVisitResult?>((ref) => null);