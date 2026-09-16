import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:stock_control_app/features/sales/domain/repositories/submit_sale_repository.dart';
import 'package:stock_control_app/features/sales/domain/usecases/submit_sale_use_case.dart';
import 'package:stock_control_app/features/sales/presentation/provider/sales_capture_provider.dart';

const _uuid = Uuid();

void submitSale(WidgetRef ref, String outletId, String routeDay, String sku, int quantity) {
  ref.watch(submitSaleStateProvider.notifier).state = AppState.loading;
  _capturePositionAndSubmit(ref, outletId, routeDay, sku, quantity);
}

Future<void> _capturePositionAndSubmit(
  WidgetRef ref,
  String outletId,
  String routeDay,
  String sku,
  int quantity,
) async {
  Position position;
  try {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    ref.watch(submitSaleErrorMessageProvider.notifier).state =
        "Could not get your location. Enable location services and try again.";
    ref.watch(submitSaleStateProvider.notifier).state = AppState.error;
    return;
  }

  // Generated HERE — at the exact moment of capture, online or offline —
  // never regenerated on a later sync retry. This is what makes offline
  // idempotency actually work end-to-end.
  final transactionId = _uuid.v4();

  SubmitSaleUseCase useCase = GetIt.I.get();
  final response = await useCase(
    SubmitSaleParams(
      transactionId: transactionId,
      outletId: outletId,
      routeDay: routeDay,
      sku: sku,
      quantity: quantity,
      latitude: position.latitude,
      longitude: position.longitude,
    ),
  );

  response.fold(
    (l) {
      ref.watch(submitSaleResultProvider.notifier).state = l;
      ref.watch(submitSaleStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(submitSaleErrorMessageProvider.notifier).state = r.message;
      ref.watch(submitSaleStateProvider.notifier).state = AppState.error;
    },
  );
}