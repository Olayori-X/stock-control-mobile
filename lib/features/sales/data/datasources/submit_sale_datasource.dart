import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/sales/data/models/sale_model.dart';

abstract interface class SubmitSaleDataSource {
  Future<SubmitSaleResponse> submitSale(SubmitSalePayload payload);
}

class SubmitSaleRemoteDataSource implements SubmitSaleDataSource {
  @override
  Future<SubmitSaleResponse> submitSale(SubmitSalePayload payload) async {
    Response response = await dio.post("/sales/submitsale", data: payload.toJson());

    Map<String, dynamic> responseData = response.data;
    return SubmitSaleResponse.fromJson(responseData);
  }
}