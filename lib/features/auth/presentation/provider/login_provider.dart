import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/auth/domain/repositories/pin_login_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final userIdInputProvider = StateProvider<String>((ref) => '');
final pinInputProvider = StateProvider<String>((ref) => '');

final loginStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);

final loginErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");

final loginResponseProvider = StateProvider.autoDispose<PinLoginResult?>((ref) => null);

final resumptionFailedProvider = StateProvider.autoDispose<bool>((ref) => false);