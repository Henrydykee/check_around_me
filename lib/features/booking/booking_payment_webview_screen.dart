import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookingPaymentWebViewScreen extends StatefulWidget {
  final String authorizationUrl;
  final String? reference;

  const BookingPaymentWebViewScreen({
    super.key,
    required this.authorizationUrl,
    this.reference,
  });

  @override
  State<BookingPaymentWebViewScreen> createState() => _BookingPaymentWebViewScreenState();
}

class _BookingPaymentWebViewScreenState extends State<BookingPaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  static const List<String> _successPatterns = [
    'success',
    'callback',
    'verify',
    'successful',
    'completed',
    'transaction',
    'payment-success',
    'paystack.com/success',
    'status=success',
    'trxref',
    'reference',
    'paid',
  ];

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url.toLowerCase();
            final isSuccess = _successPatterns.any((pattern) => url.contains(pattern.toLowerCase()));

            if (isSuccess) {
              router.pop(true);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authorizationUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.onSurface, size: 22),
          onPressed: () => router.pop(false),
        ),
        title: const Text(
          'Complete payment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

