import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/local_storage.dart';
import '../../core/utils/router.dart';
import '../../core/vm/provider_initilizers.dart';
import '../../data/model/user_model.dart';
import '../../data/repositories/auth_repositories.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({super.key});

  @override
  State<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  UserModel? _user;
  final TextEditingController _shareLinkController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  bool _isLoadingReferral = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadReferralFromBackend();
  }

  void _loadUserData() {
    final userJson = inject<LocalStorageService>().getJson("user");
    if (userJson != null) {
      setState(() {
        _user = UserModel.fromJson(userJson);
        final referralCode = _user?.referralCode ?? '';
        _referralCodeController.text = referralCode;
        _shareLinkController.text = referralCode.isNotEmpty
            ? 'https://beta.checkaroundme.com/auth?ref=$referralCode'
            : '';
      });
    }
  }

  Future<void> _loadReferralFromBackend() async {
    try {
      final repo = inject<AuthRepository>();
      setState(() {
        _isLoadingReferral = true;
      });
      final result = await repo.getReferralCodeFromSummary();
      if (!mounted) return;
      result.fold(
        (_) {
          // Ignore error here; we'll keep whatever was loaded from local storage.
        },
        (referralCode) {
          setState(() {
            _referralCodeController.text = referralCode;
            _shareLinkController.text = referralCode.isNotEmpty
                ? 'https://beta.checkaroundme.com/auth?ref=$referralCode'
                : '';
          });
        },
      );
    } catch (_) {
      // Silently ignore unexpected errors; UI will continue using local storage value.
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingReferral = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _shareLinkController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard(String text, String label) async {
    if (text.isEmpty) return;
    
    await Clipboard.setData(ClipboardData(text: text));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label copied to clipboard'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => router.pop(),
        ),
        title: const Text(
          'Referrals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_user == null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Log in to see and share your referral code.',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isLoadingReferral)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LinearProgressIndicator(minHeight: 3),
                ),
              // Header Section
              const Text(
                'Referrals',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Invite friends and grow the community.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Invite Friends Section
              const Text(
                'Invite Friends',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share your unique link with friends. When they sign up and verify their business, you help grow our network.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Share Link Field
              const Text(
                'Share Link',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _shareLinkController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'No referral code available',
                        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(_shareLinkController.text, 'Share link'),
                    icon: const Icon(Icons.copy, size: 18, color: Colors.black),
                    label: const Text(
                      'Copy',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Referral Code Field
              const Text(
                'Referral Code',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _referralCodeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'No referral code available',
                        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(_referralCodeController.text, 'Referral code'),
                    icon: const Icon(Icons.copy, size: 18, color: Colors.black),
                    label: const Text(
                      'Copy',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // How it works Section
              const Text(
                'How it works',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Steps
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 32,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Send Invitation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Share your link with friends.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Step 2
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.people,
                          size: 32,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'They Join',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'They sign up and verify their account.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


