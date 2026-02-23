import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/services/appwrite_service.dart';
import '../../../core/utils/app_config.dart';

/// Runs Google OAuth in a WebView. Intercepts when the backend redirects to
/// [AppConfig.oauthAppCallbackUrl]?secret=... and pops with the token.
class OAuthWebViewScreen extends StatefulWidget {
  const OAuthWebViewScreen({super.key});

  @override
  State<OAuthWebViewScreen> createState() => _OAuthWebViewScreenState();
}

class _OAuthWebViewScreenState extends State<OAuthWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  static String? _extractSecretFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    var secret = uri.queryParameters['secret'] ?? uri.queryParameters['token'];
    if (secret != null && secret.isNotEmpty) return secret;
    if (uri.fragment.isNotEmpty) {
      final params = Uri.splitQueryString(uri.fragment);
      secret = params['secret'] ?? params['token'];
    }
    return (secret != null && secret.isNotEmpty) ? secret : null;
  }

  static bool _isAppCallbackUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.host != AppConfig.oauthAppCallbackHost) return false;
    final path = uri.path;
    if (path != AppConfig.oauthAppCallbackPath && path != '${AppConfig.oauthAppCallbackPath}/') {
      return false;
    }
    return _extractSecretFromUrl(url) != null;
  }

  @override
  void initState() {
    super.initState();
    final startUrl = AppwriteService.getGoogleOAuthStartUrl();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (_isAppCallbackUrl(request.url)) {
              final secret = _extractSecretFromUrl(request.url);
              if (secret != null && mounted) {
                Navigator.of(context).pop(secret);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(startUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in with Google'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
