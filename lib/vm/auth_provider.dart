import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/data/model/user_model.dart';
import 'package:flutter/material.dart';
import '../core/services/local_storage.dart';
import '../core/services/request_failure.dart';
import '../data/model/create_account_payload.dart';
import '../data/repositories/auth_repositories.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

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
        isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
