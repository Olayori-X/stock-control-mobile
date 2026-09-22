import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/scs/invoices/domain/repositories/invoices_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final invoicesStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);
final invoicesErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");
final invoicesListProvider = StateProvider.autoDispose<List<InvoiceResult>>((ref) => []);
final receiptsStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);
final receiptsErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");
final receiptsListProvider = StateProvider.autoDispose<List<ReceiptResult>>((ref) => []);