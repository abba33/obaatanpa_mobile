import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Core imports

// Provider imports
import '../../providers/auth_provider.dart';
import 'components/pregnancy_info_popup.dart';
import '../../providers/pregnancy_data_provider.dart';

/// Login Screen - Using original UI design with modern functionality
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedUserType = 'pregnant';
  bool _obscurePassword = true;
  bool _rememberMe = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, 0.00),
                end: Alignment(0.50, 1.00),
                colors: [Color(0xFFFCD7DA), Color(0xFFE7EDFA)],
              ),
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Hero image with overlay
                  _buildHeroSection(),

                  // Main content
                  _buildMainContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 375,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.50, 0.00),
          end: const Alignment(0.50, 1.00),
          colors: [
            const Color(0xFF666666).withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
        ),
        color: const Color(0xFF7DA8E6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flexible top spacing instead of fixed 146px
            const Spacer(flex: 3),

            // Constrained content area
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title with responsive font size
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth > 321
                            ? 321
                            : constraints.maxWidth,
                        child: Text(
                          'WELCOME TO OBAATANPA',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: constraints.maxWidth < 350 ? 28 : 32,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth > 321
                            ? 321
                            : constraints.maxWidth,
                        child: Text(
                          'Your Pregnancy & Motherhood Companion',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFF59297),
                            fontSize: constraints.maxWidth < 350 ? 18 : 20,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Description - made flexible to prevent overflow
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth > 321
                              ? 321
                              : constraints.maxWidth,
                          child: Text(
                            'Sign in to access your personalized dashboard, track your progress, and continue receiving the care and support you deserve.',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.3, // Line height for better readability
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Small bottom spacing
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 397),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User type selection
                _buildUserTypeSelection(),

                const SizedBox(height: 25),

                // Sign In section
                _buildSignInSection(authProvider),

                const SizedBox(height: 17),

                // Create account link
                _buildCreateAccountLink(),

                // Add bottom padding to ensure content is not cut off
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserTypeSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I am a:',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // Pregnant Mother option
          _buildUserTypeOption(
            'pregnant',
            '🤰Pregnant Mother',
            isFirst: true,
          ),
          const SizedBox(height: 16),

          // New Mother option
          _buildUserTypeOption(
            'new_mother',
            '👶 New Mother',
          ),
          const SizedBox(height: 16),

          // Hospital/Clinic option
          _buildUserTypeOption(
            'hospital',
            '🏥 Hospital/Clinic',
          ),
          const SizedBox(height: 16),

          // Health Practitioner option
          _buildUserTypeOption(
            'practitioner',
            '🧑‍⚕️ Health Practitioner',
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeOption(String value, String title,
      {bool isFirst = false}) {
    final isSelected = _selectedUserType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = value;
        });
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 320),
        height: 55,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 2 : 1,
              color: isSelected
                  ? const Color(0xFFF59297)
                  : const Color(0x7F666666),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection(AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign In:',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          // Email field
          Text(
            'Email *',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          _buildEmailField(),

          const SizedBox(height: 16),

          // Password field
          Text(
            'Password *',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          _buildPasswordField(),

          const SizedBox(height: 16),

          // Remember me and forgot password row
          _buildRememberMeRow(),

          const SizedBox(height: 22),

          // Error message
          if (authProvider.error != null)
            _buildErrorMessage(authProvider.error!),

          // Login button
          _buildLoginButton(authProvider),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      height: 55,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x7F666666),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: GoogleFonts.inter(
            color: const Color(0x7F666666),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
        ),
        style: GoogleFonts.inter(
          fontSize: 20,
          color: Colors.black,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      height: 55,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x7F666666),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: GoogleFonts.inter(
            color: const Color(0x7F666666),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.all(15),
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0x7F666666),
                size: 20,
              ),
            ),
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 20,
          color: Colors.black,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _rememberMe = !_rememberMe;
            });
          },
          child: Container(
            width: 25,
            height: 25,
            decoration: ShapeDecoration(
              color: _rememberMe ? const Color(0xFFF59297) : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0x7F666666),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: _rememberMe
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Remember Me',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // Handle forgot password
          },
          child: Text(
            'Forgot Password',
            style: GoogleFonts.inter(
              color: const Color(0xFFF59297),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      height: 55,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFF7DA8E6), Color(0xFFF8A7AB)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: authProvider.isLoading ? null : _handleLogin,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            alignment: Alignment.center,
            child: authProvider.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Login',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 67),
      child: SizedBox(
        width: 233,
        child: GestureDetector(
          onTap: () => context.go('/auth/signup'),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'New to Obaatanpa?',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: ' \nCreate an account',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF59297),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      // Navigate directly to appropriate dashboard without any popup
      _navigateToUserDashboard();
    }
  }

  void _navigateToUserDashboard() {
    switch (_selectedUserType) {
      case 'pregnant':
        context.goNamed('pregnant-dashboard');
        break;
      case 'new_mother':
        context.goNamed('new-mother-dashboard');
        break;
      case 'hospital':
        context.goNamed('hospital-dashboard');
        break;
      case 'practitioner':
        context.goNamed('practitioner-dashboard');
        break;
      default:
        context.go('/dashboard');
    }
  }
}