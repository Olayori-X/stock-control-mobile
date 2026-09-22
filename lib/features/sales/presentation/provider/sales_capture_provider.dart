import 'package:stock_control_app/core/provider/global.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/features/sales/domain/repositories/submit_sale_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final skuInputProvider = StateProvider<String>((ref) => '');
final quantityInputProvider = StateProvider<int>((ref) => 1);

final submitSaleStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);
final submitSaleErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");
final submitSaleResultProvider = StateProvider.autoDispose<SubmitSaleResult?>((ref) => null);