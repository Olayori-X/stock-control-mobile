import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/outlets/presentation/provider/create_outlet_provider.dart';
import 'package:stock_control_app/features/outlets/presentation/functions/create_outlet.dart';

class CreateOutletPage extends ConsumerStatefulWidget {
  const CreateOutletPage({super.key});

  @override
  ConsumerState<CreateOutletPage> createState() => _CreateOutletPageState();
}

class _CreateOutletPageState extends ConsumerState<CreateOutletPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _typeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _zoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _typeController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createOutletStateProvider);
    final errorMessage = ref.watch(createOutletErrorMessageProvider);
    final result = ref.watch(createOutletResultProvider);
    final isLoading = state == AppState.loading;

    return Scaffold(
      appBar: AppBar(title: const Text("New Outlet")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Your current location will be captured as this outlet's coordinates. "
            "Make sure you're standing at the outlet before saving.",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Outlet name")),
          const SizedBox(height: 12),
          TextField(controller: _addressController, decoration: const InputDecoration(labelText: "Address")),
          const SizedBox(height: 12),
          TextField(controller: _typeController, decoration: const InputDecoration(labelText: "Type (e.g. Retail)")),
          const SizedBox(height: 12),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone")),
          const SizedBox(height: 12),
          TextField(controller: _areaController, decoration: const InputDecoration(labelText: "Area")),
          const SizedBox(height: 12),
          TextField(controller: _zoneController, decoration: const InputDecoration(labelText: "Zone")),
          const SizedBox(height: 20),
          if (state == AppState.error)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ),
          if (state == AppState.success && result != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text("${result.name} created and assigned to you.", style: const TextStyle(color: Colors.green)),
            ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () => createOutlet(
                      ref,
                      name: _nameController.text.trim(),
                      address: _addressController.text.trim(),
                      outletType: _typeController.text.trim(),
                      phone: _phoneController.text.trim(),
                      area: _areaController.text.trim(),
                      zone: _zoneController.text.trim(),
                    ),
            child: isLoading
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("Save outlet at my location"),
          ),
        ],
      ),
    );
  }
}