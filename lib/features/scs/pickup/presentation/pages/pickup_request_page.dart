import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_products_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/get_products_use_case.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/provider/pickup_provider.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/functions/pickup_functions.dart';

class PickupRequestPage extends ConsumerStatefulWidget {
  const PickupRequestPage({super.key});

  @override
  ConsumerState<PickupRequestPage> createState() => _PickupRequestPageState();
}

class _PickupRequestPageState extends ConsumerState<PickupRequestPage> {
  List<ProductResult> _products = [];
  bool _loadingProducts = true;
  String? _productsError;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    GetProductsUseCase useCase = GetIt.I.get();
    final response = await useCase(const NoParams());
    response.fold(
      (l) => setState(() {
        _products = l;
        _loadingProducts = false;
      }),
      (r) => setState(() {
        _productsError = r.message;
        _loadingProducts = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDistributor = ref.watch(selectedDistributorProvider);
    final distributorResults = ref.watch(distributorResultsProvider);
    final searching = ref.watch(searchingDistributorsProvider);
    final cart = ref.watch(cartItemsProvider);
    final createState = ref.watch(createPickupStateProvider);
    final createError = ref.watch(createPickupErrorMessageProvider);
    final createResult = ref.watch(createPickupResultProvider);
    final isSubmitting = createState == AppState.loading;

    return Scaffold(
      appBar: AppBar(title: const Text("New Pickup Request")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Distributor", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (selectedDistributor != null)
            Card(
              child: ListTile(
                title: Text(selectedDistributor.name),
                subtitle: Text(selectedDistributor.email),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => clearDistributor(ref),
                ),
              ),
            )
          else ...[
            TextField(
              decoration: const InputDecoration(hintText: "Search by name or email..."),
              onChanged: (value) => searchDistributors(ref, value),
            ),
            if (searching) const Padding(padding: EdgeInsets.all(8), child: Text("Searching…")),
            ...distributorResults.map((d) => ListTile(
                  title: Text(d.name),
                  subtitle: Text(d.email),
                  onTap: () => selectDistributor(ref, d),
                )),
          ],
          const SizedBox(height: 24),
          const Text("Products", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_loadingProducts) const Center(child: CircularProgressIndicator()),
          if (!_loadingProducts && _productsError != null) Text(_productsError!),
          if (!_loadingProducts && _productsError == null)
            ..._products.map((p) {
              final qty = cart[p.sku]?.quantity ?? 0;
              return ListTile(
                title: Text(p.name),
                subtitle: Text(p.sku),
                trailing: SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: qty.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsed = int.tryParse(value) ?? 0;
                      setCartQuantity(ref, p.sku, p.name, parsed);
                    },
                  ),
                ),
              );
            }),
          const SizedBox(height: 20),
          if (createState == AppState.error)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(createError, style: const TextStyle(color: Colors.red)),
            ),
          if (createState == AppState.success && createResult != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Request ${createResult.requestId} sent.",
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ElevatedButton(
            onPressed: isSubmitting ? null : () => submitPickupRequest(ref),
            child: isSubmitting
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("Submit request"),
          ),
        ],
      ),
    );
  }
}