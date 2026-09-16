import 'package:stock_control_app/core/provider/global.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/features/sales/domain/repositories/submit_sale_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final skuInputProvider = StateProvider<String>((ref) => '');
final quantityInputProvider = StateProvider<int>((ref) => 1);

final StateProvider<AppState> submitSaleStateProvider = StateProvider(
  (ref) => AppState.initial,
);

final StateProvider<String> submitSaleErrorMessageProvider = StateProvider(
  (ref) => "",
);

final StateProvider<SubmitSaleResult?> submitSaleResultProvider = StateProvider(
  (ref) => null,
);