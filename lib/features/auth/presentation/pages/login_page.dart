import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/auth/presentation/provider/login_provider.dart';
import 'package:stock_control_app/features/auth/presentation/functions/login.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _userIdController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginStateProvider);
    final errorMessage = ref.watch(loginErrorMessageProvider);
    final resumptionFailed = ref.watch(resumptionFailedProvider);
    final isLoading = loginState == AppState.loading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Sign in", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Enter your ID and PIN to start your route."),
              const SizedBox(height: 24),
              TextField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: "User ID"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: const InputDecoration(labelText: "PIN"),
              ),
              if (loginState == AppState.error) ...[
                const SizedBox(height: 8),
                Text(
                  resumptionFailed
                      ? "You're not near your planned route for today. Move closer to a scheduled outlet and try again."
                      : errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => pinLogin(ref, _userIdController.text.trim(), _pinController.text.trim()),
                child: isLoading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Sign in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}