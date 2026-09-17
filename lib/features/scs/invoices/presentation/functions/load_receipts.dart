import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/scs/invoices/domain/usecases/get_my_receipts_use_case.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/provider/invoices_provider.dart';

void loadMyReceipts(WidgetRef ref) {
  ref.watch(receiptsStateProvider.notifier).state = AppState.loading;
  _fetchReceipts(ref);
}

Future<void> _fetchReceipts(WidgetRef ref) async {
  GetMyReceiptsUseCase useCase = GetIt.I.get();
  final response = await useCase(const NoParams());

  response.fold(
    (l) {
      ref.watch(receiptsListProvider.notifier).state = l;
      ref.watch(receiptsStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(receiptsErrorMessageProvider.notifier).state = r.message;
      ref.watch(receiptsStateProvider.notifier).state = AppState.error;
    },
  );
}