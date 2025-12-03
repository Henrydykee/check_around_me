import 'package:flutter/material.dart';
import '../core/services/request_failure.dart';
import '../data/model/create_account_payload.dart';
import '../data/repositories/auth_repositories.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  bool isLoading = false;
  RequestFailure? error;

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

}
