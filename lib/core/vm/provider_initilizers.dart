
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/repositories/auth_repositories.dart';
import '../services/api_client.dart';
import '../services/local_storage.dart';

GetIt inject = GetIt.instance;

class ProviderInitializer {
  static List<SingleChildWidget> getProviders() => [
    ChangeNotifierProvider<AuthViewModel>(create: (_) => inject<AuthViewModel>()
    ),
  ];
}


Future<void> setupLocator() async {

  final localStorage = await LocalStorageService.getInstance();
  inject.registerSingleton<LocalStorageService>(localStorage);
  // Register ApiClient FIRST (since AuthRepository depends on it)
  inject.registerLazySingleton<ApiClient>(() => ApiClient());

  // Then register AuthRepository (depends on ApiClient)
  inject.registerLazySingleton<AuthRepository>(() => AuthRepository(inject()));
  // inject.registerLazySingleton<AdsRepository>(() => AdsRepository(inject()));
  // inject.registerLazySingleton<ChatProvider>(() => ChatProvider(inject()));


  // Finally register AuthProvider (depends on AuthRepository)
  // inject.registerLazySingleton<AuthProvider>(() => AuthProvider(inject()));
  // inject.registerLazySingleton<AdsProvider>(() => AdsProvider(inject()));
  // inject.registerLazySingleton<ChatRepository>(() => ChatRepository(inject()));
}


class AuthViewModel extends ChangeNotifier {
  String _userName = "";

  String get userName => _userName;

  void login(String name) {
    _userName = name;
    notifyListeners(); // notify listeners when state changes
  }
}