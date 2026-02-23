import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/local_storage.dart';
import '../../core/utils/router.dart';
import '../../core/vm/provider_initilizers.dart';
import '../../core/vm/provider_view_model.dart';
import '../../core/widget/error.dart';
import '../../core/widget/loader_wrapper.dart';
import '../../data/model/user_model.dart';
import '../../vm/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() {
    final userJson = inject<LocalStorageService>().getJson("user");
    if (userJson != null) {
      setState(() {
        _user = UserModel.fromJson(userJson);
        _updateControllers();
      });
    }
  }

  void _updateControllers() {
    _firstNameController.text = _user?.name ?? '';
    _emailController.text = _user?.email ?? '';
    _phoneController.text = _user?.phone ?? '';
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(AuthProvider vm) async {
    if (_formKey.currentState!.validate()) {
      final fullName = _firstNameController.text.trim();
      final phone = _phoneController.text.trim();

      final success = await vm.updateUser(
        fullName: fullName,
        phone: phone,
      );

      if (!mounted) return;

      if (success) {
        router.pop(true);
      } else {
        showErrorDialog(
          context,
          "Error",
          vm.error?.message ?? "Failed to update profile",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<AuthProvider>(),
      onModelReady: (vm) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.getCurrentUser().then((_) {
            if (mounted) {
              final userJson = inject<LocalStorageService>().getJson("user");
              if (userJson != null) {
                setState(() {
                  _user = UserModel.fromJson(userJson);
                  _updateControllers();
                });
              }
            }
          });
        });
      },
      builder: (context, vm, child) {
        return LoaderWrapper(
          isLoading: vm.isLoading,
          view: Scaffold(
            backgroundColor: AppTheme.surface,
            body: CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  expandedHeight: 0,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.onSurface, size: 22),
                    onPressed: () => router.pop(),
                  ),
                  title: Text(
                    'Edit profile',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  centerTitle: true,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile header card
                          _buildProfileHeader(),
                          const SizedBox(height: 24),
                          // Section
                          _buildSectionLabel(
                            icon: Icons.person_outline_rounded,
                            label: 'Personal information',
                          ),
                          const SizedBox(height: 12),
                          _buildFormCard(
                            children: [
                              _buildLabeledField(
                                label: 'Full name',
                                icon: Icons.badge_outlined,
                                child: TextFormField(
                                  controller: _firstNameController,
                                  style: GoogleFonts.poppins(fontSize: 15),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Name is required';
                                    return null;
                                  },
                                  decoration: _inputDecoration(hint: 'e.g. John Doe'),
                                ),
                              ),
                              _buildDivider(),
                              _buildLabeledField(
                                label: 'Email',
                                icon: Icons.mail_outline_rounded,
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified_rounded,
                                          size: 14, color: AppTheme.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  readOnly: true,
                                  style: GoogleFonts.poppins(fontSize: 15, color: AppTheme.onSurfaceVariant),
                                  decoration: _inputDecoration(hint: 'Email address')
                                      .copyWith(fillColor: AppTheme.surfaceVariant),
                                ),
                              ),
                              _buildDivider(),
                              _buildLabeledField(
                                label: 'Phone number',
                                icon: Icons.phone_outlined,
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: GoogleFonts.poppins(fontSize: 15),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Phone is required';
                                    return null;
                                  },
                                  decoration: _inputDecoration(hint: 'e.g. +234 800 000 0000'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              'Used for booking updates and account recovery.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildSaveButton(vm),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withOpacity(0.08),
            AppTheme.primaryLight,
          ],
        ),
        borderRadius: AppTheme.borderRadiusXl,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: Text(
                  _getInitials(_user?.name),
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera_alt_rounded, size: 18, color: AppTheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _user?.name ?? 'Your name',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (_user?.email != null && (_user!.email ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _user!.email!,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionLabel({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required List<Widget> children}) {
    return Container(
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
      child: ClipRRect(
        borderRadius: AppTheme.borderRadiusXl,
        child: Column(children: children),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceVariant,
                  letterSpacing: 0.3,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing,
              ],
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: AppTheme.surfaceVariant,
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: AppTheme.onSurfaceVariant, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: AppTheme.surface,
      border: OutlineInputBorder(borderRadius: AppTheme.borderRadiusSm),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusSm,
        borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusSm,
        borderSide: const BorderSide(color: AppTheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusSm,
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
    );
  }

  Widget _buildSaveButton(AuthProvider vm) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () => _submitForm(vm),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.borderRadiusMd,
          ),
        ),
        icon: const Icon(Icons.check_rounded, size: 22),
        label: Text(
          'Save changes',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

