import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/create_my_outlet_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final StateProvider<AppState> createOutletStateProvider = StateProvider((ref) => AppState.initial);
final StateProvider<String> createOutletErrorMessageProvider = StateProvider((ref) => "");
final StateProvider<CreatedOutletResult?> createOutletResultProvider = StateProvider((ref) => null);