// features/outlets/data/datasources/delete_my_outlet_datasource.dart
import 'package:stock_control_app/core/network/configuration.dart';

abstract interface class DeleteMyOutletDataSource {
  Future<void> deleteOutlet(String outletId);
}

class DeleteMyOutletRemoteDataSource implements DeleteMyOutletDataSource {
  @override
  Future<void> deleteOutlet(String outletId) async {
    await dio.delete("/sales/deleteoutlet", queryParameters: {"outlet_id": outletId});
  }
}