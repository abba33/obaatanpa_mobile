import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'components/new_mother_quick_actions_row.dart';
import 'components/feeding_tracker_card.dart';
import 'components/mental_wellness_card.dart';

import 'components/recovery_nutrition_card.dart';

import 'components/baby_development_card.dart';
import 'components/postpartum_week_card.dart';
import 'components/postpartum_daily_tasks.dart';
import 'components/new_mother_tools_card.dart';
// ... other component imports
import '../../../widgets/navigation/navigation_menu.dart';

// Main New Mother Dashboard Page
class NewMotherDashboardPage extends StatefulWidget {
  const NewMotherDashboardPage({Key? key}) : super(key: key);

  @override
  State<NewMotherDashboardPage> createState() => _NewMotherDashboardPageState();
}

class _NewMotherDashboardPageState extends State<NewMotherDashboardPage> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu(); // Close menu first

    // Use GoRouter navigation instead of Navigator.pushNamed
    if (routeName != '/new-mother/dashboard') {
      // ✅ Fixed the dashboard route check
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildDashboardContent(),
          if (_isMenuOpen) _buildNavigationMenu(),
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'chatbot',
            onPressed: () {
              // Show chatbot
            },
            backgroundColor: const Color(0xFF9B59B6),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'sos',
            onPressed: () {
              // Show emergency contacts/help
              context.go('/emergency-contacts');
            },
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.emergency_outlined,
              color: Colors.white,
            ),
          ),
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
                // Postpartum week card (similar to pregnancy week card)
                const PostpartumWeekCard(),
                const SizedBox(height: 20),

                // Quick actions for baby care
                NewMotherQuickActionsRow(),
                const SizedBox(height: 24),

                // Daily tasks tracking
                const PostpartumDailyTasksCard(
                    currentWeek: 1), // TODO: Update with actual week
                const SizedBox(height: 24),

                // Mental wellness tips and mood tracker
                const MentalWellnessCard(),
                const SizedBox(height: 24),

                // Baby development tracker
                const BabyDevelopmentCard(),
                const SizedBox(height: 24),

                // Recovery nutrition card
                RecoveryNutritionCard(),
                const SizedBox(height: 20),

                // Tools section
                const NewMotherToolsCard(
                    currentWeek: 1), // TODO: Update with actual week
                const SizedBox(height: 20),
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
                      color: Color(
                          0xFF9B59B6), // Purple color for new mother theme
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
                        'Your New Mother Dashboard',
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

            // Menu Items with Navigation - FIXED ROUTES
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationMenuItem(
                      title: 'Dashboard',
                      isActive: true,
                      textColor: const Color(
                          0xFF9B59B6), // Active color for Dashboard menu item
                      onTap: () =>
                          _navigateToPage('/new-mother/dashboard'), // ✅ Fixed
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      textColor: Colors.black87,
                      onTap: () =>
                          _navigateToPage('/new-mother/resources'), // ✅ Fixed
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage(
                          '/new-mother/appointments'), // ✅ Fixed
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Nutrition',
                      textColor: Colors.black87,
                      onTap: () =>
                          _navigateToPage('/new-mother/nutrition'), // ✅ Fixed
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Health',
                      textColor: Colors.black87,
                      onTap: () =>
                          _navigateToPage('/new-mother/health'), // ✅ Fixed
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
