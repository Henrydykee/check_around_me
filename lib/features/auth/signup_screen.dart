import 'package:check_around_me/core/utils/router.dart';
import 'package:check_around_me/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool agreeToTerms = false;
  bool optInMailing = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
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

                // Full name
                Text(
                  'Full Name',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                Text(
                  'Email Address*',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Phone
                Text(
                  'Phone Number',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '+000 000 000 000',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password
                Text(
                  'Password',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
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
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      onChanged: (v) {
                        setState(() => agreeToTerms = v!);
                      },
                      activeColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Opt in checkbox
                Row(
                  children: [
                    Checkbox(
                      value: optInMailing,
                      onChanged: (v) {
                        setState(() => optInMailing = v!);
                      },
                      activeColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      'Opt in to mailing list',
                      style: GoogleFonts.poppins(color: Colors.black87),
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
                    onPressed: () {},
                    child: Text(
                      'Register Account',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Or',
                          style: GoogleFonts.poppins(color: Colors.black54)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),

                // Google register button
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
                  onTap: (){
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
    );
  }
}
