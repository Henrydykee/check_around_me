import 'package:flutter/material.dart';

import '../services/local_storage.dart';
import '../vm/provider_initilizers.dart';
import '../../features/auth/presentation/login_screen.dart';
import 'router.dart';

/// Ensures the user is logged in before performing a protected action.
/// Returns true if already logged in or after successful login, false otherwise.
Future<bool> requireLoggedIn(BuildContext context) async {
  final storage = inject<LocalStorageService>();
  final token = storage.getString("secret");

  if (token != null && token.isNotEmpty) {
    return true;
  }

  final shouldLogin = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.lock_outline_rounded, size: 40, color: Colors.black87),
                const SizedBox(height: 16),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You need an account to perform this action.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Sign in or create account'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Not now'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  if (shouldLogin != true) return false;

  // Navigate to login screen; when done, user will be back on current screen.
  await router.push(const LoginScreen());

  final newToken = storage.getString("secret");
  return newToken != null && newToken.isNotEmpty;
}

