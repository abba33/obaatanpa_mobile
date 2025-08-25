import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

/// Home Screen - Simple version matching web app design
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryWeb,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryWeb.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 60,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'Welcome to Obaatanpa',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Ghana\'s Premier Maternal Care Platform',
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    color: AppColors.gray700,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Description
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🎉 Flutter Mobile App Successfully Created!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryWeb,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Your Flutter mobile app is now running standalone! This app replicates the exact same UI and functionality as your web application, with mock authentication for easy testing.',
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          color: AppColors.gray700,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Features list
                      _buildFeatureItem(
                          '✅ Exact color scheme matching web app'),
                      _buildFeatureItem('✅ Same typography (Poppins + Lora)'),
                      _buildFeatureItem('✅ Standalone - no backend required'),
                      _buildFeatureItem('✅ Mock authentication system'),
                      _buildFeatureItem('✅ Theme management (light/dark)'),
                      _buildFeatureItem('✅ Responsive mobile design'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // CTA Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.go('/auth/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryWeb,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => context.go('/auth/signup'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryWeb,
                            side: const BorderSide(
                                color: AppColors.primaryWeb, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.gray800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
