import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/core/vm/provider_initilizers.dart';
import 'package:check_around_me/core/vm/provider_view_model.dart';
import 'package:check_around_me/core/widget/error.dart';
import 'package:check_around_me/core/widget/loader_wrapper.dart';
import 'package:check_around_me/data/model/create_account_payload.dart';
import 'package:check_around_me/features/auth/presentation/login_screen.dart';
import 'package:check_around_me/vm/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool agreeToTerms = false;
  bool optInMailing = false;
  bool obscurePassword = true;

  Future<void> showSuccessDialog(
      BuildContext context,
      String message, {
        VoidCallback? onContinue,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Green Check Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              "Success",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onContinue != null) onContinue();
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      viewModel: inject<AuthProvider>(),
      builder: (context, vm, child) {
        return LoaderWrapper(
          isLoading: vm.isLoading,
          view: Scaffold(
            backgroundColor: Colors.white,
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
                          'Welcome! 👋',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Kindly fill in your details below to create an account',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 35),

                        // First Name
                        Text('First Name',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: firstNameCtrl,
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                          decoration: InputDecoration(
                            hintText: 'Enter your firstname',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Last Name
                        Text('Last Name',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: lastNameCtrl,
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                          decoration: InputDecoration(
                            hintText: 'Enter your lastname',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email
                        Text('Email Address*',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailCtrl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final emailRegex = RegExp(r"^[^@]+@[^@]+\.[^@]+");
                            if (!emailRegex.hasMatch(value)) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Phone Number
                        Text('Phone Number',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: phoneCtrl,
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '+000 000 000 000',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password
                        Text('Password',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: passwordCtrl,
                          validator: (value) =>
                          value == null || value.length < 6
                              ? 'Must be at least 6 characters'
                              : null,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            hintText: '********',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() => obscurePassword = !obscurePassword);
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Terms
                        Row(
                          children: [
                            Checkbox(
                              value: agreeToTerms,
                              onChanged: (v) {
                                setState(() => agreeToTerms = v!);
                              },
                              activeColor: Colors.black,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: GoogleFonts.poppins(color: Colors.black87),
                                  children: [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Mailing List
                        Row(
                          children: [
                            Checkbox(
                              value: optInMailing,
                              onChanged: (v) {
                                setState(() => optInMailing = v!);
                              },
                              activeColor: Colors.black,
                            ),
                            Text(
                              'Opt in to mailing list',
                              style:
                              GoogleFonts.poppins(color: Colors.black87),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Register button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAAB7D1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (!agreeToTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('You must agree to continue'),
                                    ),
                                  );
                                  return;
                                }

                                CreateAccountModel params = CreateAccountModel(
                                  name: "${firstNameCtrl.text} ${lastNameCtrl.text}",
                                  email: emailCtrl.text,
                                  phone: phoneCtrl.text,
                                  password: passwordCtrl.text,
                                  login: true,
                                  referralCode: "",
                                  optInMailingList: optInMailing,
                                );

                                await vm.register(params);

                                if (vm.isLoading == false && vm.error != null) {
                                  return showErrorDialog(context, "Error", vm.error!.message);
                                }

                                if (vm.isLoading == false && vm.error == null) {
                                  // Show success dialog first
                                  await showSuccessDialog(
                                    context,
                                    "Your account has been created successfully",
                                  );

                                  // Then navigate
                                  router.push(LoginScreen());
                                }
                              }
                            },

                            child: Text(
                              'Register Account',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Or',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black54)),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Google Signup
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: Text(
                              'Register with Google',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),

                        const SizedBox(height: 25),

                        GestureDetector(
                          onTap: () {
                            router.push(LoginScreen());
                          },
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
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
