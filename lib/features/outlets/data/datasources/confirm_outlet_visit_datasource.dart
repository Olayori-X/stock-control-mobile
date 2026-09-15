import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/outlets/data/models/outlet_visit_model.dart';

abstract interface class ConfirmOutletVisitDataSource {
  Future<ConfirmVisitResponse> confirmVisit(ConfirmVisitPayload payload);
}

class ConfirmOutletVisitRemoteDataSource implements ConfirmOutletVisitDataSource {
  @override
  Future<ConfirmVisitResponse> confirmVisit(ConfirmVisitPayload payload) async {
    Response response = await dio.post("/sales/confirmvisit", data: payload.toJson());

    Map<String, dynamic> responseData = response.data;
    return ConfirmVisitResponse.fromJson(responseData);
  }
}