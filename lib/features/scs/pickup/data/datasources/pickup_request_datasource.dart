import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/scs/pickup/data/models/pickup_request_model.dart';

abstract interface class PickupRequestDataSource {
  Future<SearchDistributorsResponse> searchDistributors(String query);
  Future<PickupRequestResponse> createPickupRequest(CreatePickupRequestPayload payload);
  Future<List<ProductResponse>> getProducts();
}

class PickupRequestRemoteDataSource implements PickupRequestDataSource {
  @override
  Future<SearchDistributorsResponse> searchDistributors(String query) async {
    Response response = await dio.get(
      "/sales/searchdistributor",
      queryParameters: {"query": query},
    );

    Map<String, dynamic> responseData = response.data;
    return SearchDistributorsResponse.fromJson(responseData);
  }

  @override
  Future<PickupRequestResponse> createPickupRequest(
    CreatePickupRequestPayload payload,
  ) async {
    Response response = await dio.post("/sales/createrequest", data: payload.toJson());

    Map<String, dynamic> responseData = response.data;
    return PickupRequestResponse.fromJson(responseData);
  }

  @override
  Future<List<ProductResponse>> getProducts() async {
    Response response = await dio.get("/sales/products");
    final List<dynamic> data = response.data;
    return data.map((p) => ProductResponse.fromJson(p as Map<String, dynamic>)).toList();
  }
}