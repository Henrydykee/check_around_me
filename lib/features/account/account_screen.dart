import 'package:flutter/material.dart';

import '../../core/services/local_storage.dart';
import '../../core/utils/router.dart';
import '../../core/vm/provider_initilizers.dart';
import '../../data/model/user_model.dart';
import 'billing_screen.dart';
import 'edit_profile_screen.dart';
import 'my_businesses_screen.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    _getInitials(_user?.name),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      _user?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user?.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. Menu Options List
              _buildMenuOption(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () async {
                  final result = await router.push(const EditProfileScreen());
                  if (result == true) {
                    _loadUserData();
                  }
                },
              ),
              _buildMenuOption(
                icon: Icons.business_center_outlined,
                title: 'My Businesses',
                onTap: () {
                  router.push(const MyBusinessesScreen());
                },
              ),
              _buildMenuOption(
                icon: Icons.verified_user_outlined,
                title: 'Security',
                onTap: () {},
              ),
              _buildMenuOption(
                icon: Icons.share_outlined,
                title: 'Referrals',
                onTap: () {
                  router.push(const ReferralsScreen());
                },
              ),
              _buildMenuOption(
                icon: Icons.credit_card_outlined,
                title: 'Billing',
                onTap: () {
                  router.push(const BillingScreen());
                },
              ),

              // 4. Sign Out Button
              _buildMenuOption(
                icon: Icons.logout,
                title: 'Sign Out',
                isDestructive: true, // Custom flag for red color
                onTap: () {
                  // Handle logout logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Helper Widget for the Menu Items
  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isDestructive = false,
  }) {
    // Define colors based on state
    final Color backgroundColor =  Colors.transparent;
    final Color contentColor = isDestructive
        ? Colors.red
        : ( Colors.grey[800]!);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: contentColor,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: contentColor,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
        // Removes default ListTile constraints to make it look tighter like the image
        minLeadingWidth: 20,
      ),
    );
  }
}