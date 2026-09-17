import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/outlets/data/models/create_outlet_model.dart';

abstract interface class CreateMyOutletDataSource {
  Future<CreateOutletResponse> create(CreateOutletPayload payload);
}

class CreateMyOutletRemoteDataSource implements CreateMyOutletDataSource {
  @override
  Future<CreateOutletResponse> create(CreateOutletPayload payload) async {
    Response response = await dio.post("/sales/addoutlet", data: payload.toJson());

    Map<String, dynamic> responseData = response.data;
    return CreateOutletResponse.fromJson(responseData);
  }
}