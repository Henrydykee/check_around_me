import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart' as appwrite_models;

import '../utils/app_config.dart';

/// Handles Appwrite client and Google OAuth. After OAuth, use [getCurrentUser]
/// to get email/name and exchange with backend for app session.
class AppwriteService {
  late final Client _client;
  late final Account _account;

  AppwriteService() {
    _client = Client()
        .setEndpoint(AppConfig.appwriteEndpoint)
        .setProject(AppConfig.appwriteProjectId);
    _account = Account(_client);
  }

  Account get account => _account;

  /// URL to load in a WebView to start Google OAuth (web flow). After login, backend
  /// redirects to [AppConfig.oauthAppCallbackUrl]?secret=... which the WebView intercepts.
  /// Requires: In Appwrite Console (cloud.appwrite.io) → your project → add a Web platform
  /// with your domain (e.g. www.checkaroundme.com) so success/failure URLs to that host are allowed.
  static String getGoogleOAuthStartUrl() {
    final success = Uri.encodeComponent(AppConfig.oauthCallbackSuccess);
    final failure = Uri.encodeComponent(AppConfig.oauthCallbackFailure);
    return '${AppConfig.appwriteEndpoint}/account/sessions/oauth2/callback/google/${AppConfig.appwriteProjectId}?success=$success&failure=$failure';
  }

  /// Starts Google OAuth (in-app flow). SDK opens browser; user returns to app via
  /// appwrite-callback scheme with Appwrite session. Then use [getAppwriteUser] and
  /// exchange with your backend for your JWT.
  Future<void> createGoogleOAuth2Session() async {
    await _account.createOAuth2Session(
      provider: OAuthProvider.google,
      scopes: [
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
        'openid',
      ],
    );
  }

  /// Returns the current Appwrite user (email, name, etc.) after OAuth.
  /// Throws if no session.
  Future<appwrite_models.User> getAppwriteUser() async {
    return await _account.get();
  }

  /// Deletes the current Appwrite session (e.g. on logout if using only backend token).
  Future<void> deleteSession(String sessionId) async {
    await _account.deleteSession(sessionId: sessionId);
  }
}
