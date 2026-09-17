import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/scs/invoices/domain/usecases/get_my_invoices_use_case.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/provider/invoices_provider.dart';

void loadMyInvoices(WidgetRef ref) {
  ref.watch(invoicesStateProvider.notifier).state = AppState.loading;
  _fetchInvoices(ref);
}

Future<void> _fetchInvoices(WidgetRef ref) async {
  GetMyInvoicesUseCase useCase = GetIt.I.get();
  final response = await useCase(const NoParams());

  response.fold(
    (l) {
      ref.watch(invoicesListProvider.notifier).state = l;
      ref.watch(invoicesStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(invoicesErrorMessageProvider.notifier).state = r.message;
      ref.watch(invoicesStateProvider.notifier).state = AppState.error;
    },
  );
}