import 'package:stock_control_app/core/network/configuration.dart';
import 'package:stock_control_app/features/scs/invoices/data/models/invoices_model.dart';

abstract interface class InvoicesDataSource {
  Future<List<InvoiceResponse>> getMyInvoices();
  Future<List<ReceiptResponse>> getMyReceipts();
}

class InvoicesRemoteDataSource implements InvoicesDataSource {
  @override
  Future<List<InvoiceResponse>> getMyInvoices() async {
    Response response = await dio.get("/sales/myinvoices");
    final List<dynamic> data = response.data;
    return data.map((i) => InvoiceResponse.fromJson(i as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ReceiptResponse>> getMyReceipts() async {
    Response response = await dio.get("/sales/myreceipts");
    final List<dynamic> data = response.data;
    return data.map((r) => ReceiptResponse.fromJson(r as Map<String, dynamic>)).toList();
  }
}