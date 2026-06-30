import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../main_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/images/logo.png',
                width: 120,
              ),

              const SizedBox(height: 30),

              const Text(
                "Welcome to QuizVerse",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111827),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Sharpen your knowledge.\nOne quiz at a time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff6B7280),
                ),
              ),

              // Aesthetic improvement: Replaced the final bottom Spacer with a structured block
              // This makes the design look incredibly intentional on modern extra-tall mobile displays.
              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  // Security Fix: Disables button interactivity completely during active login requests
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          final user = await _authService.signInWithGoogle();
                          setState(() => _isLoading = false);

                          if (!mounted) return;

                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainWrapper(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Google Sign-In failed"),
                              ),
                            );
                          }
                        },
                  // Professional adjustment: Uses standard cross-platform identity asset structure
                  icon: _isLoading
                      ? const SizedBox.shrink()
                      : Image.asset(
                          'assets/images/google_logo.png',
                          width: 20,
                          height: 20,
                          // Failure fallback: ensures compile/runtime compliance even if the asset wasn't created yet
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.login,
                            size: 22,
                          ),
                        ),
                  label: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF4F46E5), // Cohesive primary brand theme accent color
                          ),
                        )
                      : const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    side: const BorderSide(
                      color: Color(0xffE5E7EB),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}