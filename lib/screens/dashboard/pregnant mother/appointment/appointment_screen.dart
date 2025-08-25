import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool isMenuOpen = false;

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
    _closeMenu(); // Close menu first
    
    // Navigate to different routes
    if (routeName != '/appointments') {
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8BBD9).withOpacity(0.1),
      body: Stack(
        children: [
          // Main content with gesture detector to close menu when tapped outside
          GestureDetector(
            onTap: _closeMenu,
            child: Column(
              children: [
                // Custom App Bar
                CustomAppBar(
                  isMenuOpen: isMenuOpen,
                  onMenuTap: _toggleMenu,
                  title: 'Appointments',
                ),
                
                // Appointments Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Book an Appointment Header Section
                        Container(
                          width: double.infinity,
                          color: const Color(0xFFF8BBD9).withOpacity(0.3),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const Text(
                                'Book an Appointment',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Search and book appointments with trusted maternity hospitals for baby care, feeding help, vaccination, and more.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              // Search Bar
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search by hospital's name",
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Care Categories
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Care Categories',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6B9BFF),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Text(
                                      'All Services',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: const Text(
                                      'Newborn Care',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Available Hospitals
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Available Hospitals',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Hospital Cards Grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // First Row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernHospitalCard(
                                      context,
                                      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2053&q=80',
                                      'Ridge Hospital',
                                      'Accra, Ghana • 1.8 km away',
                                      '4.7(189 reviews)',
                                      'RIDGE',
                                      hospitalData: {
                                        'hospitalName': 'Ridge Hospital',
                                        'hospitalAddress': 'Castle Road, Ridge, Accra',
                                        'hospitalImage': 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2053&q=80',
                                        'phoneNumber': '+233 30 987 6543',
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildModernHospitalCard(
                                      context,
                                      'https://images.unsplash.com/photo-1516841273335-e39b37888115?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
                                      'Korle-bu Hospital',
                                      'Accra, Ghana • 1.5 km away',
                                      '4.7(189 reviews)',
                                      null,
                                      hospitalData: {
                                        'hospitalName': 'Korle-Bu Teaching Hospital',
                                        'hospitalAddress': 'Guggisberg Avenue, Korle-Bu, Accra',
                                        'hospitalImage': 'https://images.unsplash.com/photo-1516841273335-e39b37888115?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
                                        'phoneNumber': '+233 30 202 0820',
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Second Row - Trust Hospital (left aligned)
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernHospitalCard(
                                      context,
                                      'https://images.unsplash.com/photo-1551190822-a9333d879b1f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                                      'Trust Hospital',
                                      'Accra, Ghana • 1.8 km away',
                                      '4.7(189 reviews)',
                                      null,
                                      hospitalData: {
                                        'hospitalName': 'Trust Hospital',
                                        'hospitalAddress': 'Dzorwulu, Accra',
                                        'hospitalImage': 'https://images.unsplash.com/photo-1551190822-a9333d879b1f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                                        'phoneNumber': '+233 30 278 5555',
                                      },
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()), // Empty space
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // My Upcoming Appointments
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Upcoming Appointments',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Upcoming Appointments List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildAppointmentCard(
                                'Ridge Hospital',
                                'September 20 - 12:30',
                                'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2053&q=80',
                              ),
                              const SizedBox(height: 12),
                              _buildAppointmentCard(
                                'Trust Hospital',
                                'October 30 - 2:30',
                                'https://images.unsplash.com/photo-1551190822-a9333d879b1f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Menu Overlay with better handling
          if (isMenuOpen)
            Stack(
              children: [
                // Semi-transparent background overlay
                GestureDetector(
                  onTap: _closeMenu,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                // Navigation Menu
                _buildNavigationMenu(),
              ],
            ),
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
        onTap: () {}, // Prevent tap from closing menu when tapping on menu itself
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
              // App Bar in Menu
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
                        onTap: () => _navigateToPage('/dashboard/pregnant-mother'),
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
                        isActive: true, // This page is active
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

  Widget _buildModernHospitalCard(
    BuildContext context,
    String imageUrl,
    String hospitalName,
    String location,
    String rating,
    String? badge, {
    required Map<String, String> hospitalData,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to hospital booking page
        context.pushNamed(
          'hospital-booking',
          extra: hospitalData,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hospital Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.local_hospital,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 140,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Hospital Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rating,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Star Rating
                  Row(
                    children: [
                      for (int i = 0; i < 4; i++)
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 16,
                        ),
                      const Icon(
                        Icons.star_outline,
                        color: Color(0xFFFFD700),
                        size: 16,
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

  Widget _buildAppointmentCard(String hospitalName, String dateTime, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hospital Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.local_hospital,
                      size: 30,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Hospital Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospitalName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    dateTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_outlined,
                  color: Colors.blue[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone_outlined,
                  color: Colors.pink[600],
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}