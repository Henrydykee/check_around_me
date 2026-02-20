import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

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
    // Initialize controllers with empty values first
    _firstNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() {
    // First try to load from local storage for immediate display
    final userJson = inject<LocalStorageService>().getJson("user");
    if (userJson != null) {
      setState(() {
        _user = UserModel.fromJson(userJson);
        _updateControllers();
      });
    }
  }

  void _updateControllers() {
    // Use the full name as the first name field
    _firstNameController.text = _user?.name ?? '';
    _emailController.text = _user?.email ?? '';
    _phoneController.text = _user?.phone ?? '';
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
        router.pop(true); // Return true to indicate success
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
        // Fetch fresh user data when screen loads to ensure we have email
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
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left, color: AppTheme.onSurface, size: 28),
                onPressed: () => router.pop(),
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(24),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'e.g. John Doe',
                            hintStyle: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: OutlineInputBorder(borderRadius: AppTheme.borderRadiusMd),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'EMAIL',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            hintStyle: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: AppTheme.surfaceVariant,
                            border: OutlineInputBorder(borderRadius: AppTheme.borderRadiusMd),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.1)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'PHONE NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone number is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'e.g. +234 123 456 7890',
                            hintStyle: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: OutlineInputBorder(borderRadius: AppTheme.borderRadiusMd),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppTheme.borderRadiusMd,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => _submitForm(vm),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

