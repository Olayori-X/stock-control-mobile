import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/scs/invoices/domain/repositories/invoices_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final StateProvider<AppState> invoicesStateProvider = StateProvider((ref) => AppState.initial);
final StateProvider<String> invoicesErrorMessageProvider = StateProvider((ref) => "");
final StateProvider<List<InvoiceResult>> invoicesListProvider = StateProvider((ref) => []);

final StateProvider<AppState> receiptsStateProvider = StateProvider((ref) => AppState.initial);
final StateProvider<String> receiptsErrorMessageProvider = StateProvider((ref) => "");
final StateProvider<List<ReceiptResult>> receiptsListProvider = StateProvider((ref) => []);