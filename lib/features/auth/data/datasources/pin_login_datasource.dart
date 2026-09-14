import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/auth/data/models/pin_login_model.dart';

abstract interface class PinLoginDataSource {
  Future<PinLoginResponse> login(PinLoginPayload payload);
}

class PinLoginRemoteDataSource implements PinLoginDataSource {
  @override
  Future<PinLoginResponse> login(PinLoginPayload payload) async {
    Response response = await dio.post(
      "/auth/pinlogin",
      data: payload.toJson(),
    );

    Map<String, dynamic> responseData = response.data;
    return PinLoginResponse.fromJson(responseData);
  }
}