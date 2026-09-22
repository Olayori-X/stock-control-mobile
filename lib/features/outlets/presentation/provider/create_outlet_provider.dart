import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/create_my_outlet_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final createOutletStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);
final createOutletErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");
final createOutletResultProvider = StateProvider.autoDispose<CreatedOutletResult?>((ref) => null);