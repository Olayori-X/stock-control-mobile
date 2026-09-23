import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/outlets/domain/usecases/get_my_outlets_use_case.dart';
import 'package:stock_control_app/features/outlets/presentation/provider/my_outlets_provider.dart';

void loadMyOutlets(WidgetRef ref) {
  ref.watch(myOutletsStateProvider.notifier).state = AppState.loading;
  _fetchMyOutlets(ref);
}

Future<void> _fetchMyOutlets(WidgetRef ref) async {
  GetMyOutletsUseCase useCase = GetIt.I.get();
  final response = await useCase(const NoParams());

  response.fold(
    (l) {
      ref.watch(myOutletsListProvider.notifier).state = l;
      ref.watch(myOutletsStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(myOutletsErrorMessageProvider.notifier).state = r.message;
      ref.watch(myOutletsStateProvider.notifier).state = AppState.error;
    },
  );
}