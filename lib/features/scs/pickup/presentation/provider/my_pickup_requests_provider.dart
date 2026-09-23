import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_my_pickup_requests_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final myPickupRequestsStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);
final myPickupRequestsErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");
final myPickupRequestsListProvider = StateProvider.autoDispose<List<MyPickupRequestResult>>((ref) => []);