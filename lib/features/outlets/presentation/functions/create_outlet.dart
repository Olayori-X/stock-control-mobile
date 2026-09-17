import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/create_my_outlet_repository.dart';
import 'package:stock_control_app/features/outlets/domain/usecases/create_my_outlet_use_case.dart';
import 'package:stock_control_app/features/outlets/presentation/provider/create_outlet_provider.dart';

void createOutlet(
  WidgetRef ref, {
  required String name,
  required String address,
  required String outletType,
  required String phone,
  required String area,
  required String zone,
}) {
  ref.watch(createOutletStateProvider.notifier).state = AppState.loading;
  _captureAndCreate(ref, name, address, outletType, phone, area, zone);
}

Future<void> _captureAndCreate(
  WidgetRef ref,
  String name,
  String address,
  String outletType,
  String phone,
  String area,
  String zone,
) async {
  // GPS captured HERE, at the outlet — this is the entire point of the
  // feature. Never let coordinates be manually entered by a sales
  // associate; that's what makes this different from the admin flow.
  Position position;
  try {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    ref.watch(createOutletErrorMessageProvider.notifier).state =
        "Could not get your location. Enable location services and try again.";
    ref.watch(createOutletStateProvider.notifier).state = AppState.error;
    return;
  }

  CreateMyOutletUseCase useCase = GetIt.I.get();
  final response = await useCase(
    CreateMyOutletParams(
      name: name,
      address: address,
      outletType: outletType,
      phone: phone,
      latitude: position.latitude,
      longitude: position.longitude,
      area: area,
      zone: zone,
    ),
  );

  response.fold(
    (l) {
      ref.watch(createOutletResultProvider.notifier).state = l;
      ref.watch(createOutletStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(createOutletErrorMessageProvider.notifier).state = r.message;
      ref.watch(createOutletStateProvider.notifier).state = AppState.error;
    },
  );
}