import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/sales/data/models/my_sales_model.dart';

abstract interface class GetMySalesDataSource {
  Future<MySalesResponse> getMySales();
}

class GetMySalesRemoteDataSource implements GetMySalesDataSource {
  @override
  Future<MySalesResponse> getMySales() async {
    Response response = await dio.get("/sales/mysales");

    Map<String, dynamic> responseData = response.data;
    return MySalesResponse.fromJson(responseData);
  }
}