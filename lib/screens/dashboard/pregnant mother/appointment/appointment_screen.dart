import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool isMenuOpen = false;
  String selectedCategory = 'All Services';

  // ✅ Hospital data with categories
  final List<Map<String, dynamic>> hospitals = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=2053&q=80',
      'hospitalName': 'Ridge Hospital',
      'location': 'Castle Road, Ridge • 1.8 km',
      'rating': 4.7,
      'reviews': 189,
      'phoneNumber': '+233 30 987 6543',
      'category': 'Prenatal Care',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1516841273335-e39b37888115?auto=format&fit=crop&w=2071&q=80',
      'hospitalName': 'Korle-Bu Hospital',
      'location': 'Guggisberg Ave • 1.5 km',
      'rating': 4.8,
      'reviews': 245,
      'phoneNumber': '+233 30 202 0820',
      'category': 'Newborn Care',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1551190822-a9333d879b1f?auto=format&fit=crop&w=2070&q=80',
      'hospitalName': 'Trust Hospital',
      'location': 'Dzorwulu • 1.8 km',
      'rating': 4.6,
      'reviews': 156,
      'phoneNumber': '+233 30 278 5555',
      'category': 'Vaccination',
    },
  ];

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _closeMenu() {
    if (isMenuOpen) {
      setState(() {
        isMenuOpen = false;
      });
    }
  }

  void _navigateToPage(String routeName) {
    _closeMenu();
    if (routeName != '/appointments') {
      context.go(routeName);
    }
  }

  void _showChatDialog(String doctorName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chat with $doctorName'),
          content: const Text(
              'This feature will allow you to chat with your doctor. Coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(String hospitalName) async {
    String phoneNumber = _getHospitalPhoneNumber(hospitalName);
    final phoneUrl = Uri.parse('tel:$phoneNumber');

    try {
      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not make phone call')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make phone call')),
      );
    }
  }

  String _getHospitalPhoneNumber(String hospitalName) {
    final hospital = hospitals.firstWhere(
      (h) => h['hospitalName'].toLowerCase() == hospitalName.toLowerCase(),
      orElse: () => {'phoneNumber': '+233 30 123 4567'},
    );
    return hospital['phoneNumber'];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    // ✅ Filter hospitals by category
    List<Map<String, dynamic>> filteredHospitals = selectedCategory == 'All Services'
        ? hospitals
        : hospitals.where((h) => h['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _closeMenu,
            child: Column(
              children: [
                CustomAppBar(
                  isMenuOpen: isMenuOpen,
                  onMenuTap: _toggleMenu,
                  title: 'Appointments',
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText:
                                    "Search hospitals, doctors, or services",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 15,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[400],
                                  size: 22,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Categories
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Medical Services',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildCategoryChip('All Services'),
                                    const SizedBox(width: 12),
                                    _buildCategoryChip('Prenatal Care'),
                                    const SizedBox(width: 12),
                                    _buildCategoryChip('Newborn Care'),
                                    const SizedBox(width: 12),
                                    _buildCategoryChip('Vaccination'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Hospitals Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            'Featured Hospitals',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: filteredHospitals.map((hospital) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: _buildHospitalCard(
                                  context,
                                  hospital['imageUrl'],
                                  hospital['hospitalName'],
                                  hospital['location'],
                                  hospital['rating'],
                                  hospital['reviews'],
                                  hospitalData: {
                                    'hospitalName': hospital['hospitalName'],
                                    'hospitalAddress': hospital['location'],
                                    'hospitalImage': hospital['imageUrl'],
                                    'phoneNumber': hospital['phoneNumber'],
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Upcoming Appointments (unchanged)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Menu
          if (isMenuOpen) _buildNavigationMenu(),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 120,
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8BBD9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Obaatanpa',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Your Pregnancy Dashboard',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _toggleMenu,
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavigationMenuItem(
                        title: 'Dashboard',
                        textColor: Colors.black87,
                        onTap: () =>
                            _navigateToPage('/dashboard/pregnant-mother'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Resources',
                        textColor: Colors.black87,
                        onTap: () => _navigateToPage('/resources'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Appointments',
                        isActive: true,
                        textColor: const Color(0xFFF8BBD9),
                        onTap: () => _navigateToPage('/appointments'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Nutrition',
                        textColor: Colors.black87,
                        onTap: () => _navigateToPage('/nutrition'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Health',
                        textColor: Colors.black87,
                        onTap: () => _navigateToPage('/health'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    final bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7DA8E6) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF7DA8E6) : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7DA8E6).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4A5568),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(
    BuildContext context,
    String imageUrl,
    String hospitalName,
    String location,
    double rating,
    int reviews, {
    required Map<String, String> hospitalData,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'hospital-booking',
          extra: hospitalData,
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.local_hospital,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFA726),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        ' ($reviews reviews)',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
