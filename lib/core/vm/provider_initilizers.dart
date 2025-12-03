import 'package:check_around_me/data/repositories/business_repositories.dart';
import 'package:check_around_me/vm/business_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/repositories/auth_repositories.dart';
import '../../vm/auth_provider.dart';
import '../services/api_client.dart';
import '../services/local_storage.dart';

GetIt inject = GetIt.instance;

class ProviderInitializer {
  static List<SingleChildWidget> getProviders() => [
    ChangeNotifierProvider<AuthViewModel>(create: (_) => inject<AuthViewModel>()),
    ChangeNotifierProvider<BusinessProvider>(create: (_) => inject<BusinessProvider>()),
  ];
}

Future<void> setupLocator() async {
  final localStorage = await LocalStorageService.getInstance();
  inject.registerSingleton<LocalStorageService>(localStorage);
  // Register ApiClient FIRST (since AuthRepository depends on it)
  inject.registerLazySingleton<ApiClient>(() => ApiClient());

  // Then register AuthRepository (depends on ApiClient)
  inject.registerLazySingleton<AuthRepository>(() => AuthRepository(inject()));
  inject.registerLazySingleton<BusinessRepository>(() => BusinessRepository(inject()));

  // inject.registerLazySingleton<ChatProvider>(() => ChatProvider(inject()));

  // Finally register AuthProvider (depends on AuthRepository)
  inject.registerLazySingleton<AuthProvider>(() => AuthProvider(inject()));
  inject.registerLazySingleton<BusinessProvider>(() => BusinessProvider(inject()));
}

class AuthViewModel extends ChangeNotifier {
  String _userName = "";

  String get userName => _userName;

  void login(String name) {
    _userName = name;
    notifyListeners(); // notify listeners when state changes
  }
}
