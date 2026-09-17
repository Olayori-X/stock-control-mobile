import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/search_distributors_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/create_pickup_request_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/search_distributors_use_case.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/create_pickup_request_use_case.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/provider/pickup_provider.dart';

Timer? _debounce;

// Debounced the same way the web dashboard's distributor search was —
// 300ms — to avoid firing a request on every keystroke.
void searchDistributors(WidgetRef ref, String query) {
  ref.watch(distributorQueryProvider.notifier).state = query;

  _debounce?.cancel();
  if (query.trim().isEmpty) {
    ref.watch(distributorResultsProvider.notifier).state = [];
    return;
  }

  _debounce = Timer(const Duration(milliseconds: 300), () => _runSearch(ref, query));
}

Future<void> _runSearch(WidgetRef ref, String query) async {
  ref.watch(searchingDistributorsProvider.notifier).state = true;

  SearchDistributorsUseCase useCase = GetIt.I.get();
  final response = await useCase(query);

  response.fold(
    (l) => ref.watch(distributorResultsProvider.notifier).state = l,
    (r) => ref.watch(distributorResultsProvider.notifier).state = [],
  );

  ref.watch(searchingDistributorsProvider.notifier).state = false;
}

void selectDistributor(WidgetRef ref, DistributorResult distributor) {
  ref.watch(selectedDistributorProvider.notifier).state = distributor;
  ref.watch(distributorResultsProvider.notifier).state = [];
}

void clearDistributor(WidgetRef ref) {
  ref.watch(selectedDistributorProvider.notifier).state = null;
}

void setCartQuantity(WidgetRef ref, String sku, String name, int quantity) {
  final cart = Map<String, PickupProductItem>.from(ref.read(cartItemsProvider));
  if (quantity <= 0) {
    cart.remove(sku);
  } else {
    cart[sku] = PickupProductItem(sku: sku, name: name, quantity: quantity);
  }
  ref.watch(cartItemsProvider.notifier).state = cart;
}

void submitPickupRequest(WidgetRef ref) {
  final distributor = ref.read(selectedDistributorProvider);
  final cart = ref.read(cartItemsProvider);

  if (distributor == null) {
    ref.watch(createPickupErrorMessageProvider.notifier).state =
        "Select a distributor for this pickup.";
    ref.watch(createPickupStateProvider.notifier).state = AppState.error;
    return;
  }
  if (cart.isEmpty) {
    ref.watch(createPickupErrorMessageProvider.notifier).state =
        "Add at least one product with a quantity.";
    ref.watch(createPickupStateProvider.notifier).state = AppState.error;
    return;
  }

  ref.watch(createPickupStateProvider.notifier).state = AppState.loading;
  _submit(ref, distributor.userId, cart.values.toList());
}

Future<void> _submit(WidgetRef ref, String distributorId, List<PickupProductItem> products) async {
  CreatePickupRequestUseCase useCase = GetIt.I.get();
  final response = await useCase(
    CreatePickupRequestParams(distributorId: distributorId, products: products),
  );

  response.fold(
    (l) {
      ref.watch(createPickupResultProvider.notifier).state = l;
      ref.watch(createPickupStateProvider.notifier).state = AppState.success;
      // Reset for the next request
      ref.watch(selectedDistributorProvider.notifier).state = null;
      ref.watch(cartItemsProvider.notifier).state = {};
    },
    (r) {
      ref.watch(createPickupErrorMessageProvider.notifier).state = r.message;
      ref.watch(createPickupStateProvider.notifier).state = AppState.error;
    },
  );
}