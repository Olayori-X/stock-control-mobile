import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/get_my_outlets_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final myOutletsStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);
final myOutletsErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");
final myOutletsListProvider = StateProvider.autoDispose<List<OutletResult>>((ref) => []);