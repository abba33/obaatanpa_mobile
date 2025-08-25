import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';


class NewMotherResourcesPage extends StatefulWidget {
  const NewMotherResourcesPage({super.key});

  @override
  State<NewMotherResourcesPage> createState() => _NewMotherResourcesPageState();
}

class _NewMotherResourcesPageState extends State<NewMotherResourcesPage> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu();
    if (routeName != '/new_mother/resources') {
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Custom App Bar
              CustomAppBar(
                isMenuOpen: _isMenuOpen,
                onMenuTap: _toggleMenu,
                title: 'Resources',
              ),
              
              // Resources Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Header
                      const Text(
                        'Postpartum Resources',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Essential guides and support for your journey',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Resource Categories
                      _buildResourceCard(
                        'Recovery Guide',
                        'Comprehensive postpartum recovery information',
                        Icons.healing,
                        const Color(0xFF7DA8E6),
                        () => context.go('/new-mother/resources/recovery'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildResourceCard(
                        'Baby Care',
                        'Essential baby care tips and guidelines',
                        Icons.child_care,
                        const Color(0xFFFFB6C1),
                        () => context.go('/new-mother/resources/baby-care'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildResourceCard(
                        'Breastfeeding Support',
                        'Feeding guides, tips, and troubleshooting',
                        Icons.child_friendly,
                        const Color(0xFF4CAF50),
                        () => context.go('/new-mother/resources/breastfeeding'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildResourceCard(
                        'Mental Health',
                        'Emotional wellness and support resources',
                        Icons.psychology,
                        const Color(0xFF9C27B0),
                        () => context.go('/new-mother/resources/mental-health'),
                      ),
                      const SizedBox(height: 24),
                      
                      // Educational Articles
                      _buildEducationalSection(),
                      const SizedBox(height: 24),
                      
                      // Support Groups
                      _buildSupportGroupsSection(),
                      const SizedBox(height: 24),
                      
                      // Emergency Contacts
                      _buildEmergencyContactsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Side Navigation Menu
          if (_isMenuOpen) _buildNavigationMenu(),
        ],
      ),
    );
  }

  Widget _buildResourceCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Educational Articles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildArticleCard(
          'Understanding Baby\'s Sleep Patterns',
          'Learn about newborn sleep cycles',
          'Dr. Sarah Johnson',
          '5 min read',
        ),
        _buildArticleCard(
          'Postpartum Depression: Signs & Support',
          'Recognizing and addressing mental health',
          'Dr. Emily Chen',
          '8 min read',
        ),
        _buildArticleCard(
          'Establishing Breastfeeding Success',
          'Tips for a successful feeding journey',
          'Lactation Consultant Mary',
          '6 min read',
        ),
      ],
    );
  }

  Widget _buildArticleCard(String title, String subtitle, String author, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF7DA8E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.article, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$author • $duration',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support Groups',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildSupportGroupCard(
          'New Mom Circle',
          'Weekly virtual meetings for new mothers',
          'Tuesdays, 7:00 PM',
          Icons.group,
        ),
        _buildSupportGroupCard(
          'Breastfeeding Support',
          'Get help with breastfeeding challenges',
          'Daily online chat',
          Icons.chat,
        ),
        _buildSupportGroupCard(
          'Postpartum Wellness',
          'Focus on mental and physical recovery',
          'Thursdays, 6:00 PM',
          Icons.favorite,
        ),
      ],
    );
  }

  Widget _buildSupportGroupCard(String name, String description, String schedule, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  schedule,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emergency, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'Emergency Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactItem('Emergency Services', '911'),
          _buildContactItem('Postpartum Crisis Line', '+1-800-PPD-MOMS'),
          _buildContactItem('Lactation Helpline', '+1-800-LALECHE'),
          _buildContactItem('Your Healthcare Provider', 'Call clinic directly'),
        ],
      ),
    );
  }

  Widget _buildContactItem(String service, String contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            service,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            contact,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
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
                      color: Color(0xFF7DA8E6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.baby_changing_station,
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
                        'New Mother Dashboard',
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
                      onTap: () => _navigateToPage('/new-mother/dashboard'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      isActive: true,
                      textColor: const Color(0xFF7DA8E6), // Active color for Resources menu item
                      onTap: () => _navigateToPage('/new-mother/resources'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/new-mother/appointments'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Nutrition',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/new-mother/nutrition'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Health',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/new-mother/health'),
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