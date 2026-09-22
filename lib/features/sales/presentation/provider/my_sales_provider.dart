import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/sales/domain/repositories/get_my_sales_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final mySalesStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);
final mySalesErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");
final mySalesResultProvider = StateProvider.autoDispose<MySalesResult?>((ref) => null);