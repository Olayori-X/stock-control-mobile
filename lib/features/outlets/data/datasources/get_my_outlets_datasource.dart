import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/outlets/data/models/my_outlets_model.dart';

abstract interface class GetMyOutletsDataSource {
  Future<List<OutletResponse>> getMyOutlets();
}

class GetMyOutletsRemoteDataSource implements GetMyOutletsDataSource {
  @override
  Future<List<OutletResponse>> getMyOutlets() async {
    Response response = await dio.get("/sales/myoutlets");
    final List<dynamic> data = response.data;
    return data.map((o) => OutletResponse.fromJson(o as Map<String, dynamic>)).toList();
  }
}