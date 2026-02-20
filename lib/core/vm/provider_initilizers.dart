import 'package:check_around_me/data/repositories/business_repositories.dart';
import 'package:check_around_me/data/repositories/notification_repository.dart';
import 'package:check_around_me/vm/business_provider.dart';
import 'package:check_around_me/vm/notification_provider.dart';
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
    ChangeNotifierProvider<BusinessProvider>(create: (_) => inject<BusinessProvider>()),
    ChangeNotifierProvider<AuthProvider>(create: (_) => inject<AuthProvider>()),
    ChangeNotifierProvider<NotificationProvider>(
      create: (_) => NotificationProvider(inject<NotificationRepository>()),
    ),
  ];
}

Future<void> setupLocator() async {
  final localStorage = await LocalStorageService.getInstance();
  inject.registerSingleton<LocalStorageService>(localStorage);
  inject.registerLazySingleton<ApiClient>(() => ApiClient());

  inject.registerLazySingleton<AuthRepository>(() => AuthRepository(inject()));
  inject.registerLazySingleton<BusinessRepository>(() => BusinessRepository(inject()));
  inject.registerLazySingleton<NotificationRepository>(() => NotificationRepository(inject()));

  inject.registerLazySingleton<AuthProvider>(() => AuthProvider(inject()));
  inject.registerLazySingleton<BusinessProvider>(() => BusinessProvider(inject()));
}


