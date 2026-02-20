class AppConfig {
  // Runtime environment override (set via main_dev.dart)
  static String? _runtimeEnvironment;
  
  // Read environment from --dart-define flag or runtime override, defaults to 'main'
  static String get environment {
    if (_runtimeEnvironment != null) {
      return _runtimeEnvironment!;
    }
    return const String.fromEnvironment(
      'ENV',
      defaultValue: 'main',
    );
  }

  // Set environment at runtime (called from main_dev.dart)
  static void setEnvironment(String env) {
    _runtimeEnvironment = env;
  }

  // API Base URLs
  static const String mainBaseUrl = 'https://www.checkaroundme.com/api/v1';
  static const String devBaseUrl = 'https://beta.checkaroundme.com/api/v1';

  // Get the appropriate base URL based on environment
  static String get baseUrl {
    switch (environment.toLowerCase()) {
      case 'dev':
        return devBaseUrl;
      case 'main':
      case 'prod':
      case 'production':
        return mainBaseUrl;
      default:
        return mainBaseUrl; // Default to main for safety
    }
  }

  // Helper to check if we're in dev mode
  static bool get isDev => environment.toLowerCase() == 'dev';
  static bool get isMain => !isDev;

  /// URL for a business's primary image (uses dev or prod base based on environment).
  static String businessPrimaryImageUrl(String businessId) =>
      '$baseUrl/businesses/$businessId/images/primary';
}

