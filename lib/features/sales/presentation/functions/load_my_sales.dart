import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/sales/domain/usecases/get_my_sales_use_case.dart';
import 'package:stock_control_app/features/sales/presentation/provider/my_sales_provider.dart';

void loadMySales(WidgetRef ref) {
  ref.watch(mySalesStateProvider.notifier).state = AppState.loading;
  _fetchMySales(ref);
}

Future<void> _fetchMySales(WidgetRef ref) async {
  GetMySalesUseCase useCase = GetIt.I.get();
  final response = await useCase(const NoParams());

  response.fold(
    (l) {
      ref.watch(mySalesResultProvider.notifier).state = l;
      ref.watch(mySalesStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(mySalesErrorMessageProvider.notifier).state = r.message;
      ref.watch(mySalesStateProvider.notifier).state = AppState.error;
    },
  );
}