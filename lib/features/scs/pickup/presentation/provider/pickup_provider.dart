import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/search_distributors_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/create_pickup_request_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final distributorQueryProvider = StateProvider<String>((ref) => '');
final distributorResultsProvider = StateProvider<List<DistributorResult>>((ref) => []);
final searchingDistributorsProvider = StateProvider<bool>((ref) => false);
final selectedDistributorProvider = StateProvider<DistributorResult?>((ref) => null);

final cartItemsProvider = StateProvider<Map<String, PickupProductItem>>((ref) => {});

final StateProvider<AppState> createPickupStateProvider = StateProvider(
  (ref) => AppState.initial,
);

final StateProvider<String> createPickupErrorMessageProvider = StateProvider(
  (ref) => "",
);

final StateProvider<PickupRequestResult?> createPickupResultProvider = StateProvider(
  (ref) => null,
);