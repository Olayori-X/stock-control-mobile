import 'package:stock_control_app/core/provider/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stock_control_app/features/auth/domain/repositories/pin_login_repository.dart';
import 'package:stock_control_app/features/auth/domain/usecases/pin_login_use_case.dart';
import 'package:stock_control_app/features/auth/presentation/provider/login_provider.dart';
import 'package:stock_control_app/core/session/session_storage.dart';
import 'package:stock_control_app/core/network/session.dart';

void pinLogin(WidgetRef ref, String userId, String pin) {
  ref.watch(loginStateProvider.notifier).state = AppState.loading;
  ref.watch(resumptionFailedProvider.notifier).state = false;
  _initiatePinLogin(ref, userId, pin);
}

Future<void> _initiatePinLogin(
  WidgetRef ref,
  String userId,
  String pin,
) async {
  // GPS is captured here, at the moment of login — the resumption check
  // is meaningless if location is read at any other time. If location
  // can't be obtained at all, login can't proceed; there's nothing valid
  // to submit.
  Position? position;
  try {
    position = await _capturePosition();
  } catch (e) {
    ref.watch(loginErrorMessageProvider.notifier).state =
        "Could not get your location. Enable location services and try again.";
    ref.watch(loginStateProvider.notifier).state = AppState.error;
    return;
  }

  PinLoginUseCase useCase = GetIt.I.get();
  final response = await useCase(
    PinLoginParams(
      userId: userId,
      pin: pin,
      latitude: position.latitude,
      longitude: position.longitude,
      deviceRef: "", // TODO: populate with a real device identifier once device_info_plus (or similar) is added
    ),
  );

  await response.fold(
    (l) async {
      ref.watch(loginResponseProvider.notifier).state = l;
      await SessionStorage.save(GetIt.I<SalesSession>());
      ref.watch(loginStateProvider.notifier).state = AppState.success;
    },
    (r) async {
      // The resumption-geofence failure and every other login error both
      // arrive through this same BountainsError path from the backend —
      // matched on message text since the API doesn't send a structured
      // error code. Brittle, but there's nothing else to key off yet.
      if (r.message.toLowerCase().contains("not near your planned route")) {
        ref.watch(resumptionFailedProvider.notifier).state = true;
      }
      ref.watch(loginErrorMessageProvider.notifier).state = r.message;
      ref.watch(loginStateProvider.notifier).state = AppState.error;
    },
  );
}

Future<Position> _capturePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception("Location services are disabled");
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception("Location permission permanently denied");
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}