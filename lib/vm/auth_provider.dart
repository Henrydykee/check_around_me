import 'package:appwrite/appwrite.dart';
import 'package:check_around_me/core/services/appwrite_service.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/data/model/user_model.dart';
import 'package:flutter/material.dart';
import '../core/services/local_storage.dart';
import '../core/services/request_failure.dart';
import '../data/model/create_account_payload.dart';
import '../data/repositories/auth_repositories.dart';

// In-app flow: Appwrite SDK returns user to app with session; we exchange with backend for JWT.

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  final AppwriteService _appwrite;

  AuthProvider(this._repository, this._appwrite);

  bool isLoading = false;
  RequestFailure? error;
  UserModel? userModel;

  Future<void> register(CreateAccountModel create) async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.register(create);
    result.fold(
          (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
      },
          (success) {
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.login(email: email, password: password);
    await result.fold(
      (failure) async {
        error = failure;
        isLoading = false;
        notifyListeners();
      },
      (_) async {
        final userResult = await _repository.getCurrentUser();
        userResult.fold(
          (failure) {
            error = failure;
            isLoading = false;
            notifyListeners();
          },
          (user) {
            userModel = user;
            isLoading = false;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Sign in with Google (in-app flow). SDK opens browser; user returns to app with
  /// Appwrite session. We get user from Appwrite, call backend POST /auth/login-google
  /// to get our JWT, then load current user.
  Future<bool> loginWithGoogle() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _appwrite.createGoogleOAuth2Session();
      final user = await _appwrite.getAppwriteUser();
      final appwriteUserId = user.$id;
      debugPrint('🔐 [Appwrite] OAuth completed. User from SDK:');
      debugPrint('  \$id: $appwriteUserId');      debugPrint('   email: ${user.email}');
      debugPrint('  name: ${user.name}');
      debugPrint('  emailVerification: ${user.emailVerification}');
      debugPrint('  registration: ${user.registration}');
      final email = user.email;
      final name = user.name;
      if (email.isEmpty) {
        error = RequestFailure("Google account email not available");
        isLoading = false;
        notifyListeners();
        return false;
      }
      final result = await _repository.loginWithGoogle(
        email: email,
        name: name.isEmpty ? email.split('@').first : name,
        appwriteUserId: appwriteUserId,
      );
      return result.fold(
        (failure) {
          error = failure;
          isLoading = false;
          notifyListeners();
          return false;
        },
        (_) async {
          final userResult = await _repository.getCurrentUser();
          return userResult.fold(
            (failure) {
              error = failure;
              isLoading = false;
              notifyListeners();
              return false;
            },
            (u) {
              userModel = u;
              isLoading = false;
              notifyListeners();
              return true;
            },
          );
        },
      );
    } on AppwriteException catch (e) {
      error = RequestFailure(e.message ?? "Google sign-in was cancelled or failed");
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      error = RequestFailure(e.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getCurrentUser() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.getCurrentUser();
    result.fold(
          (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
      },
          (success) {
            userModel = success;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> updateUser({
    required String fullName,
    required String phone,
    String? avatarUrl,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.updateUser(
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );
    return result.fold(
          (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
        return false;
      },
          (success) {
            userModel = success;
        isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> logout() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repository.logout();
    return await result.fold(
      (failure) {
        error = failure;
        isLoading = false;
        notifyListeners();
        return false;
      },
      (_) async {
        userModel = null;
        final storage = inject<LocalStorageService>();
        await storage.remove("secret");
        await storage.remove("user");
        await storage.remove("userId");
        await storage.remove("savedUserEmail");
        isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
