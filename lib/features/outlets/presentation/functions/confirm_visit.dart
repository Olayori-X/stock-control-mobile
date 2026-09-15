import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/confirm_outlet_visit_repository.dart';
import 'package:stock_control_app/features/outlets/domain/usecases/confirm_outlet_visit_use_case.dart';
import 'package:stock_control_app/features/outlets/presentation/provider/outlet_visit_provider.dart';

void confirmOutletVisit(WidgetRef ref, String outletId, String routeDay) {
  ref.watch(confirmVisitStateProvider.notifier).state = AppState.loading;
  _capturePositionAndConfirm(ref, outletId, routeDay);
}

Future<void> _capturePositionAndConfirm(
  WidgetRef ref,
  String outletId,
  String routeDay,
) async {
  Position position;
  try {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    ref.watch(confirmVisitErrorMessageProvider.notifier).state =
        "Could not get your location. Enable location services and try again.";
    ref.watch(confirmVisitStateProvider.notifier).state = AppState.error;
    return;
  }

  ConfirmOutletVisitUseCase useCase = GetIt.I.get();
  final response = await useCase(
    ConfirmVisitParams(
      outletId: outletId,
      routeDay: routeDay,
      latitude: position.latitude,
      longitude: position.longitude,
    ),
  );

  response.fold(
    (l) {
      ref.watch(confirmVisitResultProvider.notifier).state = l;
      ref.watch(confirmVisitStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(confirmVisitErrorMessageProvider.notifier).state = r.message;
      ref.watch(confirmVisitStateProvider.notifier).state = AppState.error;
    },
  );
}