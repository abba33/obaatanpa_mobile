import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Create animations
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
    
    _startAnimation();
    _navigateNext();
  }
  
  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
  }
  
  void _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    if (mounted) {
      // Check if user is logged in
      bool isLoggedIn = await _checkUserLoginStatus();
      
      if (isLoggedIn) {
        // Get user type and navigate to appropriate dashboard
        String userType = await _getUserType();
        switch (userType) {
          case 'pregnant_mother':
            context.go('/dashboard/pregnant-mother');
            break;
          case 'new_mother':
            context.go('/new-mother/dashboard');
            break;
          case 'health_practitioner':
            context.go('/practitioner/dashboard');
            break;
          case 'hospital':
            context.go('/hospital/dashboard');
            break;
          default:
            context.go('/dashboard/pregnant-mother');
        }
      } else {
        // Navigate to onboarding page for new users
        context.go('/onboarding');
      }
    }
  }
  
  // Replace this with your actual authentication check
  Future<bool> _checkUserLoginStatus() async {
    // Example: Check SharedPreferences, secure storage, or authentication state
    // return await AuthService.isUserLoggedIn();
    
    // For testing purposes, return false to always show onboarding
    // Change this to your actual authentication logic later
    return false;
  }
  
  // Get user type from storage/preferences
  Future<String> _getUserType() async {
    // Replace with your actual user type retrieval logic
    // return await UserPreferences.getUserType();
    
    // For testing purposes, return default type
    return 'pregnant_mother';
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCD7DA), // Light pink
              Color(0xFFE7EDFA), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Image
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Container(
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/images/navbar/maternity-logo.png', // Replace with your logo path
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                          // Fallback widget in case image fails to load
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8FA3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Fallback heart icon
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                  // Mother and child silhouette (simplified)
                                  Positioned(
                                    child: Icon(
                                      Icons.people,
                                      color: Color(0xFFFF8FA3),
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // App Name
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'OBAA',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: 'TANPA',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF8FA3),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Optional: App tagline/subtitle
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: Text(
                    'Your Maternal Health Companion',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}