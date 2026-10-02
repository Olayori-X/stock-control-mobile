import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_products_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/get_products_use_case.dart';
import 'package:stock_control_app/features/sales/presentation/provider/sales_capture_provider.dart';
import 'package:stock_control_app/features/sales/presentation/functions/submit_sale.dart';

class SalesCapturePage extends ConsumerStatefulWidget {
  final String outletId;
  final String outletName;
  final String routeDay;

  const SalesCapturePage({
    super.key,
    required this.outletId,
    required this.outletName,
    required this.routeDay,
  });

  @override
  ConsumerState<SalesCapturePage> createState() => _SalesCapturePageState();
}

class _SalesCapturePageState extends ConsumerState<SalesCapturePage> {
  List<ProductResult> _products = [];
  bool _loadingProducts = true;
  String? _productsError;

  ProductResult? _selectedProduct;
  final _quantityController = TextEditingController(text: "1");
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
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
    ref.listen<AppState>(submitSaleStateProvider, (previous, next) {
      if (next == AppState.success) {
        final result = ref.read(submitSaleResultProvider);
        // Only clear the form on an actual new sale, not a queued/blocked
        // outcome — those still need the same product/quantity selected
        // if the associate wants to retry.
        if (result != null && !result.queued && result.blockReason == null) {
          setState(() {
            _selectedProduct = null;
            _searchController.clear();
            _quantityController.text = "1";
          });
        }
      }
    });

    final state = ref.watch(submitSaleStateProvider);
    final result = ref.watch(submitSaleResultProvider);
    final errorMessage = ref.watch(submitSaleErrorMessageProvider);
    final isLoading = state == AppState.loading;

    final query = _searchController.text.trim().toLowerCase();
    final visibleProducts = query.isEmpty
        ? <ProductResult>[]
        : _products.where((p) => p.name.toLowerCase().contains(query) || p.sku.toLowerCase().contains(query)).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Sale at ${widget.outletName}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Product", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_loadingProducts) const Center(child: CircularProgressIndicator()),
            if (!_loadingProducts && _productsError != null) Text(_productsError!, style: const TextStyle(color: Colors.red)),
            if (!_loadingProducts && _productsError == null) ...[
              if (_selectedProduct != null)
                Card(
                  child: ListTile(
                    title: Text(_selectedProduct!.name),
                    subtitle: Text(_selectedProduct!.sku),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                        _selectedProduct = null;
                        _searchController.clear();
                      }),
                    ),
                  ),
                )
              else ...[
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search by product name or SKU...",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                if (query.isNotEmpty && visibleProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("No matching products.", style: TextStyle(color: Colors.grey)),
                  ),
                ...visibleProducts.map((p) => ListTile(
                      title: Text(p.name),
                      subtitle: Text(p.sku),
                      onTap: () => setState(() => _selectedProduct = p),
                    )),
              ],
            ],
            const SizedBox(height: 16),
            if (_selectedProduct != null) ...[
              const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
            const SizedBox(height: 20),
            if (state == AppState.success && result != null) _buildResultCard(result),
            if (state == AppState.error) ...[
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading || _selectedProduct == null ? null : _handleSubmit,
              child: isLoading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Submit sale"),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    final product = _selectedProduct;
    if (product == null) return;

    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (quantity <= 0) return;

    submitSale(ref, widget.outletId, widget.routeDay, product.sku, quantity);
  }

  Widget _buildResultCard(result) {
    if (result.queued) {
      return const Card(
        color: Colors.amber,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text("No connection — sale saved and will sync automatically."),
        ),
      );
    }
    if (result.blockReason != null) {
      return Card(
        color: Colors.red.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(result.message ?? "This sale could not be completed."),
        ),
      );
    }
    return Card(
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text("Sale recorded — ₦${result.totalValue?.toStringAsFixed(2) ?? ''}"),
      ),
    );
  }
}