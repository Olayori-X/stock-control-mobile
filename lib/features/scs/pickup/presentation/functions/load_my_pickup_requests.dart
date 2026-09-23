import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/get_my_pickup_requests_use_case.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/provider/my_pickup_requests_provider.dart';

void loadMyPickupRequests(WidgetRef ref) {
  ref.watch(myPickupRequestsStateProvider.notifier).state = AppState.loading;
  _fetchMyPickupRequests(ref);
}

Future<void> _fetchMyPickupRequests(WidgetRef ref) async {
  GetMyPickupRequestsUseCase useCase = GetIt.I.get();
  final response = await useCase(const NoParams());

  response.fold(
    (l) {
      ref.watch(myPickupRequestsListProvider.notifier).state = l;
      ref.watch(myPickupRequestsStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(myPickupRequestsErrorMessageProvider.notifier).state = r.message;
      ref.watch(myPickupRequestsStateProvider.notifier).state = AppState.error;
    },
  );
}