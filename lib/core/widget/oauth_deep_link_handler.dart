import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../vm/provider_initilizers.dart';
import '../utils/router.dart';
import 'package:check_around_me/core/services/local_storage.dart';
import 'package:check_around_me/features/navbar/check_navbar.dart';
import 'package:check_around_me/vm/auth_provider.dart';

/// Listens for OAuth callback deep link (web flow). When backend redirects to
/// checkaroundme://auth/oauth-callback?secret=... (or ?token=...), stores the token and navigates to home.
class OAuthDeepLinkHandler extends StatefulWidget {
  const OAuthDeepLinkHandler({super.key, required this.child});

  final Widget child;

  @override
  State<OAuthDeepLinkHandler> createState() => _OAuthDeepLinkHandlerState();
}

class _OAuthDeepLinkHandlerState extends State<OAuthDeepLinkHandler> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  static const String _scheme = 'checkaroundme';

  bool _isOurOAuthCallback(Uri? uri) {
    if (uri == null || uri.scheme != _scheme) return false;
    final path = uri.path;
    final hasOAuthPath = path == '/oauth-callback' ||
        path == 'oauth-callback' ||
        path.endsWith('oauth-callback');
    if (!hasOAuthPath) return false;
    return _extractSecret(uri) != null;
  }

  String? _extractSecret(Uri uri) {
    var secret = uri.queryParameters['secret'] ?? uri.queryParameters['token'];
    if (secret != null && secret.isNotEmpty) return secret;
    if (uri.fragment.isNotEmpty) {
      final params = Uri.splitQueryString(uri.fragment);
      secret = params['secret'] ?? params['token'];
    }
    return (secret != null && secret.isNotEmpty) ? secret : null;
  }

  Future<void> _handleUri(Uri? uri) async {
    debugPrint('🔗 [OAuth] Received deep link: ${uri?.toString() ?? "null"}');
    if (uri != null) {
      debugPrint('   scheme=${uri.scheme} host=${uri.host} path=${uri.path} '
          'query=${uri.query} fragment=${uri.fragment.isEmpty ? "(empty)" : "${uri.fragment.length} chars"}');
    }

    if (!_isOurOAuthCallback(uri)) return;
    final secret = _extractSecret(uri!);
    if (secret == null) return;

    debugPrint('🔗 [OAuth] Extracted token (length=${secret.length}), storing and fetching user...');

    final storage = inject<LocalStorageService>();
    await storage.setString('secret', secret);

    final auth = inject<AuthProvider>();
    await auth.getCurrentUser();

    if (auth.error == null) {
      debugPrint('🔗 [OAuth] getCurrentUser OK → navigating to home');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.pushReplacement(CheckNavbar());
      });
    } else {
      debugPrint('🔗 [OAuth] getCurrentUser FAILED: ${auth.error?.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    _appLinks.getInitialLink().then(_handleUri);
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
