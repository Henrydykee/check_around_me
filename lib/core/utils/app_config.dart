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

  // Appwrite (Google OAuth)
  static const String appwriteEndpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String appwriteProjectId = '684ac0f3003e3f36e174';

  /// Base URL for auth callbacks (no /v1). Web OAuth flow redirects here after Google sign-in.
  static String get oauthCallbackBase => baseUrl.replaceAll('/v1', '');

  /// Success redirect for OAuth (same as web). Backend receives this, then redirects to [oauthAppCallbackUrl] with ?secret=...
  static String get oauthCallbackSuccess => '$oauthCallbackBase/auth/oauth-callback';
  static String get oauthCallbackFailure => '$oauthCallbackBase/auth/oauth-callback?failure=true';

  /// HTTPS URL we intercept in the WebView. Backend must redirect here with ?secret=... (or ?token=...).
  static String get oauthAppCallbackUrl {
    final host = Uri.parse(baseUrl).host;
    return 'https://$host/auth/app-callback';
  }

  /// Host + path to match when intercepting in WebView (same host as API, path /auth/app-callback).
  static String get oauthAppCallbackHost => Uri.parse(baseUrl).host;
  static const String oauthAppCallbackPath = '/auth/app-callback';
}

