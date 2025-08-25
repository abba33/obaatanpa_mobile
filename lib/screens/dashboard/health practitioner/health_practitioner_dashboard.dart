import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'components/practitioner_profile_card.dart';
import 'components/appointment_overview_card.dart';
import 'components/patient_list_card.dart';
import 'components/quick_actions_card.dart';
import 'components/analytics_overview_card.dart';
import 'components/notifications_card.dart';
import 'components/resource_contribution_card.dart';
import 'components/recent_activities_card.dart';
import '../../../widgets/navigation/navigation_menu.dart';

// Main Health Practitioner Dashboard Page
class HealthPractitionerDashboardPage extends StatefulWidget {
  const HealthPractitionerDashboardPage({Key? key}) : super(key: key);

  @override
  State<HealthPractitionerDashboardPage> createState() =>
      _HealthPractitionerDashboardPageState();
}

class _HealthPractitionerDashboardPageState
    extends State<HealthPractitionerDashboardPage> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu(); // Close menu first

    // Use GoRouter navigation instead of Navigator.pushNamed
    if (routeName != '/practitioner/dashboard') {
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Dashboard Content
          _buildDashboardContent(),

          // Side Navigation Menu
          if (_isMenuOpen) _buildNavigationMenu(),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        // Custom App Bar
        CustomAppBar(
          isMenuOpen: _isMenuOpen,
          onMenuTap: _toggleMenu,
          title: '',
        ),

        // Dashboard Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Practitioner profile card
                PractitionerProfilePage(),
                const SizedBox(height: 20),

                // Quick actions for practitioner
                QuickActionsCard(),
                const SizedBox(height: 24),

                // Two-column layout for appointments and notifications
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: PractitionerAppointmentsPage()),
                    const SizedBox(width: 12),
                    Expanded(child: NotificationsCard()),
                  ],
                ),
                const SizedBox(height: 20),

                // Analytics overview
                PractitionerAnalyticsPage(),
                const SizedBox(height: 24),

                // Patient list card
                PractitionerPatientsPage(),
                const SizedBox(height: 20),

                // Resource contribution card
                PractitionerResourcesPage(),
                const SizedBox(height: 20),

                // Recent activities
                RecentActivitiesCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationMenu() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: Color(0xFFF59297),
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
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Practitioner Dashboard',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleMenu,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items with Navigation
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationMenuItem(
                      title: 'Dashboard',
                      isActive: true,
                      textColor: const Color(0xFFF59297),
                      onTap: () => _navigateToPage('/practitioner/dashboard'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      textColor: Colors.black87,
                      onTap: () =>
                          _navigateToPage('/practitioner/appointments'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Patients',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/practitioner/patients'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/practitioner/resources'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Analytics',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/practitioner/analytics'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Profile',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/practitioner/profile'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
