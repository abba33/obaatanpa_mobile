import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/analytics/analytics_summary_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/components/hospital_custom_app_bar.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/patients/patient_list_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/profile/hospital_profile_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/resources/resource_management_card.dart';
import 'components/hospital_stats_overview.dart';
import 'components/practitioner_management_card.dart';
import 'components/appointment_requests_card.dart';
import 'components/notification_center_card.dart';
import 'components/quick_actions_card.dart';
import '../../../widgets/navigation/navigation_menu.dart';

class HospitalDashboardPage extends StatefulWidget {
  const HospitalDashboardPage({Key? key}) : super(key: key);

  @override
  State<HospitalDashboardPage> createState() => _HospitalDashboardPageState();
}

class _HospitalDashboardPageState extends State<HospitalDashboardPage> {
  bool _isMenuOpen = false;
  int _selectedIndex = 0;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToPage(String routeName, int index) {
    setState(() {
      _selectedIndex = index;
      _isMenuOpen = false;
    });
    
    if (routeName != '/hospital/dashboard') {
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // Main Dashboard Content
          _buildDashboardContent(),
          
          // Side Navigation Menu
          if (_isMenuOpen) _buildNavigationMenu(),
          
          // Overlay
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        // Modern App Bar
        _buildModernAppBar(),
        
        // Dashboard Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(),
                const SizedBox(height: 24),
                
                // Hospital Stats Overview
                _buildModernStatsOverview(),
                const SizedBox(height: 28),
                
                // Quick Actions Grid
                _buildQuickActionsGrid(),
                const SizedBox(height: 28),
                
                // Management Cards Section
                _buildManagementSection(),
                const SizedBox(height: 28),
                
                // Patient Management
                _buildSectionTitle('Patient Management', Icons.people_outline),
                const SizedBox(height: 16),
                Container(
                  decoration: _cardDecoration(),
                  child: HospitalPatientsPage(),
                ),
                const SizedBox(height: 28),
                
                // Resources & Analytics
                _buildResourcesAnalyticsSection(),
                const SizedBox(height: 28),
                
                // Notifications & Profile
                _buildBottomSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667EEA),
            const Color(0xFF764BA2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Menu Button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: _toggleMenu,
                  icon: Icon(
                    _isMenuOpen ? Icons.close : Icons.menu_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Title Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hospital Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Manage your hospital operations',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Color(0xFF667EEA),
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.1),
            const Color(0xFF06B6D4).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4F46E5).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here\'s what\'s happening at your hospital today',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Overview', Icons.analytics_outlined),
        const SizedBox(height: 16),
        Container(
          decoration: _cardDecoration(),
          child: HospitalStatsOverview(),
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Quick Actions', Icons.flash_on_outlined),
        const SizedBox(height: 16),
        Container(
          decoration: _cardDecoration(),
          child: QuickActionsCard(),
        ),
      ],
    );
  }

  Widget _buildManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Management', Icons.admin_panel_settings_outlined),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: _cardDecoration(),
                child: PractitionerManagementCard(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: _cardDecoration(),
                child: AppointmentRequestsCard(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResourcesAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Resources & Analytics', Icons.insights_outlined),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: _cardDecoration(),
                child: HospitalResourcesPage(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: _cardDecoration(),
                child: HospitalAnalyticsPage(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // Notifications
        _buildSectionTitle('Notifications', Icons.notifications_outlined),
        const SizedBox(height: 16),
        Container(
          decoration: _cardDecoration(),
          child: NotificationCenterCard(),
        ),
        const SizedBox(height: 28),
        
        // Hospital Profile
        _buildSectionTitle('Hospital Profile', Icons.business_outlined),
        const SizedBox(height: 16),
        Container(
          decoration: _cardDecoration(),
          child: HospitalProfilePage(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF1F2937).withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFF1F2937).withOpacity(0.04),
          blurRadius: 40,
          offset: const Offset(0, 8),
        ),
      ],
      border: Border.all(
        color: const Color(0xFFE5E7EB),
        width: 0.5,
      ),
    );
  }

  Widget _buildNavigationMenu() {
    final menuItems = [
      {'title': 'Dashboard', 'icon': Icons.dashboard_rounded, 'route': '/hospital/dashboard'},
      {'title': 'Practitioners', 'icon': Icons.medical_services_rounded, 'route': '/hospital/practitioners'},
      {'title': 'Appointments', 'icon': Icons.calendar_today_rounded, 'route': '/hospital/appointments'},
      {'title': 'Patients', 'icon': Icons.people_rounded, 'route': '/hospital/patients'},
      {'title': 'Resources', 'icon': Icons.inventory_2_rounded, 'route': '/hospital/resources'},
      {'title': 'Analytics', 'icon': Icons.analytics_rounded, 'route': '/hospital/analytics'},
      {'title': 'Profile', 'icon': Icons.business_rounded, 'route': '/hospital/profile'},
    ];

    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Menu Header
            Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF667EEA),
                    const Color(0xFF764BA2),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_hospital_rounded,
                          color: Color(0xFF667EEA),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Obaatanpa',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Healthcare Management',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleMenu,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Menu Items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: menuItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isActive = _selectedIndex == index;
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _navigateToPage(item['route'] as String, index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: isActive 
                                  ? const Color(0xFF667EEA).withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: isActive 
                                  ? Border.all(
                                      color: const Color(0xFF667EEA).withOpacity(0.3),
                                      width: 1,
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isActive 
                                        ? const Color(0xFF667EEA)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: isActive 
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                    color: isActive 
                                        ? const Color(0xFF667EEA)
                                        : const Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Menu Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF374151),
                    ),
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