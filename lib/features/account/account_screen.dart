import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/widget/error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/local_storage.dart';
import '../../core/utils/router.dart';
import '../../core/vm/provider_initilizers.dart';
import '../../data/model/user_model.dart';
import '../../vm/auth_provider.dart';
import '../auth/presentation/login_screen.dart';
import 'billing_screen.dart';
import 'edit_profile_screen.dart';
import 'my_businesses_screen.dart';
import 'notifications_screen.dart';
import 'referrals_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userJson = inject<LocalStorageService>().getJson("user");
    if (userJson != null) {
      setState(() {
        _user = UserModel.fromJson(userJson);
      });
    }
  }

  Future<void> _handleSignOut() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.logout();
    if (!mounted) return;
    if (success) {
      router.pushAndRemoveUntil(const LoginScreen(), (route) => false);
    } else {
      showErrorDialog(context, 'Sign Out', auth.error?.message ?? 'Could not sign out');
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppTheme.borderRadiusXl,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        _getInitials(_user?.name),
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user?.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Menu card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppTheme.borderRadiusXl,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuOption(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      onTap: () async {
                        final result = await router.push(const EditProfileScreen());
                        if (result == true) _loadUserData();
                      },
                      showDivider: true,
                    ),
                    _buildMenuOption(
                      icon: Icons.business_center_outlined,
                      title: 'My Businesses',
                      onTap: () => router.push(const MyBusinessesScreen()),
                      showDivider: true,
                    ),
                    _buildMenuOption(
                      icon: Icons.verified_user_outlined,
                      title: 'Security',
                      onTap: () {},
                      showDivider: true,
                    ),
                    _buildMenuOption(
                      icon: Icons.share_outlined,
                      title: 'Referrals',
                      onTap: () => router.push(const ReferralsScreen()),
                      showDivider: true,
                    ),
                    _buildMenuOption(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () => router.push(const NotificationsScreen()),
                      showDivider: true,
                    ),
                    _buildMenuOption(
                      icon: Icons.credit_card_outlined,
                      title: 'Billing',
                      onTap: () => router.push(const BillingScreen()),
                      showDivider: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Sign Out card (separate for emphasis)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppTheme.borderRadiusXl,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildMenuOption(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  isDestructive: true,
                  onTap: _handleSignOut,
                  showDivider: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isDestructive = false,
    bool showDivider = true,
  }) {
    final Color contentColor = isDestructive ? const Color(0xFFDC2626) : AppTheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppTheme.borderRadiusSm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(icon, color: contentColor, size: 22),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: contentColor,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 20 + 22 + 16,
            endIndent: 20,
            color: AppTheme.surfaceVariant,
          ),
      ],
    );
  }
}