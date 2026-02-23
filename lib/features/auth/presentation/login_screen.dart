import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/core/vm/provider_view_model.dart';
import 'package:check_around_me/core/widget/loader_wrapper.dart';
import 'package:check_around_me/features/auth/presentation/signup_screen.dart';
import 'package:check_around_me/vm/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/local_storage.dart';
import '../../../core/vm/provider_initilizers.dart';
import '../../../core/widget/error.dart';
import '../../navbar/check_navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  void _loadSavedEmail() {
    final storage = inject<LocalStorageService>();
    final saved = storage.getString("savedUserEmail");
    if (saved != null && saved.isNotEmpty) {
      emailCtrl.text = saved;
    } else {
      final user = storage.getJson("user");
      final email = user?["email"]?.toString();
      if (email != null && email.isNotEmpty) {
        emailCtrl.text = email;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<AuthProvider>(),
      builder: (context, vm, child) {
        return LoaderWrapper(
          isLoading: vm.isLoading,
          view: Scaffold(
            backgroundColor: AppTheme.surface,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        Text(
                          'Welcome Back! 👋',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Please login to your account',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Email Input
                        Text(
                          'Email Address',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: emailCtrl,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            final emailRegex = RegExp(r"^[^@]+@[^@]+\.[^@]+");
                            if (!emailRegex.hasMatch(value)) return 'Invalid email';
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: GoogleFonts.poppins(color: AppTheme.onSurfaceVariant),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.2)),
                            ),
                            border: OutlineInputBorder(borderRadius: AppTheme.borderRadiusMd),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Password',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: passwordCtrl,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Required' : null,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            hintText: '********',
                            hintStyle: GoogleFonts.poppins(color: AppTheme.onSurfaceVariant),
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: AppTheme.onSurfaceVariant,
                              ),
                              onPressed: () => setState(() => obscurePassword = !obscurePassword),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.2)),
                            ),
                            border: OutlineInputBorder(borderRadius: AppTheme.borderRadiusMd),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                              borderSide: BorderSide(color: AppTheme.primary),
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppTheme.borderRadiusMd,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await vm.login(email: emailCtrl.text.toString() , password: passwordCtrl.text.toString());
                                if (vm.isLoading == false && vm.error != null) {
                                  return showErrorDialog(context, "Error", vm.error!.message);
                                }else{
                                  router.pushReplacement(CheckNavbar());
                                }

                                if (vm.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.error!.message),
                                    ),
                                  );
                                  return;
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CheckNavbar(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Sign in with Google - commented out for now
                        // Row(
                        //   children: [
                        //     const Expanded(child: Divider()),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 8),
                        //       child: Text('Or',
                        //           style: GoogleFonts.poppins(color: Colors.black54)),
                        //     ),
                        //     const Expanded(child: Divider()),
                        //   ],
                        // ),
                        // const SizedBox(height: 20),
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 52,
                        //   child: OutlinedButton.icon(
                        //     style: OutlinedButton.styleFrom(
                        //       backgroundColor: AppTheme.onSurface,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: AppTheme.borderRadiusMd,
                        //       ),
                        //     ),
                        //     icon: const FaIcon(
                        //       FontAwesomeIcons.google,
                        //       color: Colors.white,
                        //       size: 18,
                        //     ),
                        //     label: Text(
                        //       'Sign in with Google',
                        //       style: GoogleFonts.poppins(
                        //         color: Colors.white,
                        //         fontSize: 16,
                        //       ),
                        //     ),
                        //     onPressed: () async {
                        //       final success = await vm.loginWithGoogle();
                        //       if (!context.mounted) return;
                        //       if (!success && vm.error != null) {
                        //         showErrorDialog(context, 'Sign in with Google', vm.error!.message);
                        //         return;
                        //       }
                        //       if (success) {
                        //         router.pushReplacement(CheckNavbar());
                        //       }
                        //     },
                        //   ),
                        // ),
                        // const SizedBox(height: 25),

                        const SizedBox(height: 25),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Forgot your password? ',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Reset Password',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
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
