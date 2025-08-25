import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Provider imports
import '../../providers/auth_provider.dart';

// Multi-step Signup Screen
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  
  final _formKey = GlobalKey<FormState>();
  final _specificFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // Form controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Additional field controllers
  final _trimesterController = TextEditingController();
  final _babyAgeController = TextEditingController();
  final _professionController = TextEditingController();
  final _workplaceController = TextEditingController();

  String _selectedUserType = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _receiveUpdates = false;
  int _currentStep = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // User type options data
  final List<Map<String, dynamic>> _userTypes = [
    {
      'value': 'pregnant',
      'title': 'Pregnant Mother',
      'subtitle': 'Expecting a baby',
      'emoji': '🤰',
    },
    {
      'value': 'new-mother',
      'title': 'New Mother',
      'subtitle': 'Already have a baby',
      'emoji': '👶',
    },
    {
      'value': 'hospital',
      'title': 'Hospital/Clinic',
      'subtitle': 'Medical facility',
      'emoji': '🏥',
    },
    {
      'value': 'practitioner',
      'title': 'Health Practitioner',
      'subtitle': 'Healthcare professional',
      'emoji': '🧑‍⚕️',
    },
  ];

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
    _pageController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _trimesterController.dispose();
    _babyAgeController.dispose();
    _professionController.dispose();
    _workplaceController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCD7DA), Color(0xFFE7EDFA)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProgressIndicator(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStep1(), // Choose user type
                        _buildStep2(), // Basic info + specific info
                        _buildStep3(), // Password + terms
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/auth/pregnant-mother-hero.png"), 
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF666666).withOpacity(0.7),
              Colors.black.withOpacity(0.8)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_currentStep > 0) {
                        _previousStep();
                      } else {
                        context.go('/');
                      }
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/navbar/maternity-logo.png"), // Replace with your logo name
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'JOIN OBAATANPA',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Companion in Care',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFF59297),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _getStepDescription(),
                style: GoogleFonts.lora(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return 'Tell us who you are so we can personalize your experience.';
      case 1:
        return 'Share some basic information to help us serve you better.';
      case 2:
        return 'Almost done! Just set up your account security.';
      default:
        return 'Welcome to Obaatanpa community!';
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: i <= _currentStep ? const Color(0xFFF59297) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (i < 2) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  // STEP 1: Choose User Type
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1: Choose Who You Are',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the option that best describes you',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          _buildUserTypeSelection(),
          const SizedBox(height: 32),
          _buildContinueButton(
            onPressed: _selectedUserType.isNotEmpty ? _nextStep : null,
            text: 'Continue',
          ),
        ],
      ),
    );
  }

  // STEP 2: Basic Info + Specific Info
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2: Your Information',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us a bit about yourself',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          _buildBasicInfoForm(),
          const SizedBox(height: 24),
          _buildSpecificInfoForm(),
          const SizedBox(height: 32),
          _buildContinueButton(
            onPressed: _canProceedToStep3() ? _nextStep : null,
            text: 'Continue',
          ),
        ],
      ),
    );
  }

  // STEP 3: Password + Terms
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3: Secure Your Account',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your password and review our terms',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          _buildPasswordForm(),
          const SizedBox(height: 24),
          _buildCheckboxes(),
          const SizedBox(height: 32),
          _buildCreateAccountButton(),
          const SizedBox(height: 24),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildContinueButton({
    required VoidCallback? onPressed,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.grey[300],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: onPressed != null
                ? const LinearGradient(
                    colors: [Color(0xFF7DA8E6), Color(0xFFF8A7AB)],
                  )
                : null,
            color: onPressed != null ? null : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canProceedToStep3() {
    return _fullNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        _formKey.currentState?.validate() == true;
  }

  Widget _buildUserTypeSelection() {
    return Column(
      children: _userTypes.map((userType) {
        bool isSelected = _selectedUserType == userType['value'];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedUserType = userType['value'];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFFF59297) : const Color(0xFFE0E0E0),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFFF59297).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
              ),
              child: Row(
                children: [
                  Text(
                    userType['emoji'],
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userType['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          userType['subtitle'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFFF59297),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBasicInfoForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(
            controller: _fullNameController,
            label: 'Full Name *',
            hint: 'Enter your full name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _emailController,
            label: 'Email *',
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _phoneController,
            label: 'Phone Number *',
            hint: '+233 XX XXX XXXX',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _locationController,
            label: 'Location *',
            hint: 'Enter your location',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your location';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificInfoForm() {
    return Form(
      key: _specificFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_getSpecificFields().isNotEmpty) ...[
            Text(
              _getSpecificInfoTitle(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ..._getSpecificFields(),
          ],
        ],
      ),
    );
  }

  String _getSpecificInfoTitle() {
    switch (_selectedUserType) {
      case 'pregnant':
        return 'Pregnancy Details (Optional)';
      case 'new-mother':
        return 'Baby Information (Optional)';
      case 'practitioner':
        return 'Professional Details (Optional)';
      case 'hospital':
        return 'Facility Information (Optional)';
      default:
        return 'Additional Information';
    }
  }

  List<Widget> _getSpecificFields() {
    switch (_selectedUserType) {
      case 'pregnant':
        return [
          _buildTextFormField(
            controller: _trimesterController,
            label: 'Current Trimester',
            hint: 'e.g., 2nd trimester',
          ),
        ];
      case 'new-mother':
        return [
          _buildTextFormField(
            controller: _babyAgeController,
            label: 'Baby\'s Age',
            hint: 'e.g., 3 months',
          ),
        ];
      case 'practitioner':
        return [
          _buildTextFormField(
            controller: _professionController,
            label: 'Profession',
            hint: 'e.g., Midwife, Obstetrician',
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _workplaceController,
            label: 'Workplace',
            hint: 'Hospital or clinic name',
          ),
        ];
      case 'hospital':
        return [
          _buildTextFormField(
            controller: _workplaceController,
            label: 'Facility Name',
            hint: 'Hospital or clinic name',
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildPasswordForm() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        children: [
          _buildTextFormField(
            controller: _passwordController,
            label: 'Password *',
            hint: 'Create a strong password',
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _confirmPasswordController,
            label: 'Confirm Password *',
            hint: 'Confirm your password',
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: (value) => setState(() {}), // Trigger rebuild for button state
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF59297), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          value: _receiveUpdates,
          onChanged: (value) {
            setState(() {
              _receiveUpdates = value ?? false;
            });
          },
          title: Text(
            'I\'d like to receive weekly pregnancy tips',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: const Color(0xFFF59297),
        ),
        CheckboxListTile(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          title: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFF59297),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFF59297),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: const Color(0xFFF59297),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        bool canSubmit = _passwordController.text.isNotEmpty &&
            _confirmPasswordController.text.isNotEmpty &&
            _agreeToTerms;

        return Column(
          children: [
            // Error message
            if (authProvider.error != null)
              Container(
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
                        authProvider.error!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (canSubmit && !authProvider.isLoading) ? _handleSignup : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: canSubmit
                        ? const LinearGradient(
                            colors: [Color(0xFF7DA8E6), Color(0xFFF8A7AB)],
                          )
                        : null,
                    color: canSubmit ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                            'Create my Account',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already on Obaatanpa? ',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () => context.go('/auth/login'),
            child: Text(
              'Login Here',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFFF59297),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignup() async {
    // Validate all forms
    if (!_passwordFormKey.currentState!.validate()) return;
    if (!_agreeToTerms) return;

    final authProvider = context.read<AuthProvider>();

    // Create account without auto-login
    final success = await authProvider.registerWithoutLogin(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _fullNameController.text.split(' ').first,
      lastName: _fullNameController.text.split(' ').skip(1).join(' '),
      userType: _selectedUserType,
      additionalData: {
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
        'trimester': _trimesterController.text.trim(),
        'babyAge': _babyAgeController.text.trim(),
        'profession': _professionController.text.trim(),
        'workplace': _workplaceController.text.trim(),
        'receiveUpdates': _receiveUpdates,
      },
    );

    if (success && mounted) {
      // Show success message and redirect to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎉 Account created successfully! Please log in with your credentials.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to login page
      context.go('/auth/login');
    }
  }
}