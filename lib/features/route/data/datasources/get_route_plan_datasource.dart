import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/route/data/models/route_plan_model.dart';

abstract interface class GetRoutePlanDataSource {
  Future<RoutePlanResponse> getMyRoutePlan();
}

class GetRoutePlanRemoteDataSource implements GetRoutePlanDataSource {
  @override
  Future<RoutePlanResponse> getMyRoutePlan() async {
    Response response = await dio.get("/sales/myrouteplan");

    Map<String, dynamic> responseData = response.data;
    return RoutePlanResponse.fromJson(responseData);
  }
}