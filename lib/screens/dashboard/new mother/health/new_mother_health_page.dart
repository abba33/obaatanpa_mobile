import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class NewMotherHealthPage extends StatefulWidget {
  const NewMotherHealthPage({super.key});

  @override
  State<NewMotherHealthPage> createState() => _NewMotherHealthPageState();
}

class _NewMotherHealthPageState extends State<NewMotherHealthPage> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu();
    if (routeName != '/new-mother/health') {
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
                title: 'Health',
              ),
              
              // Health Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Header
                      const Text(
                        'Health & Wellness',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Monitor your recovery and wellbeing',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Health Categories
                      _buildHealthCard(
                        'Recovery Tracking',
                        'Monitor your postpartum healing',
                        Icons.trending_up,
                        const Color(0xFF7DA8E6),
                        () => context.go('/new-mother/health/recovery'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildHealthCard(
                        'Mental Health',
                        'Mood tracking and emotional support',
                        Icons.psychology,
                        const Color(0xFF9C27B0),
                        () => context.go('/new-mother/health/mental-health'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildHealthCard(
                        'Baby Development',
                        'Track your baby\'s milestones',
                        Icons.child_care,
                        const Color(0xFF4CAF50),
                        () => context.go('/new-mother/health/baby-development'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildHealthCard(
                        'Physical Wellness',
                        'Exercise and activity guidance',
                        Icons.fitness_center,
                        const Color(0xFFFF9800),
                        () => context.go('/new-mother/health/physical-wellness'),
                      ),
                      const SizedBox(height: 24),
                      
                      // Health Overview
                      _buildHealthOverviewSection(),
                      const SizedBox(height: 24),
                      
                      // Today's Checklist
                      _buildTodayChecklistSection(),
                      const SizedBox(height: 24),
                      
                      // Warning Signs
                      _buildWarningSignsSection(),
                      const SizedBox(height: 24),
                      
                      // Health Tips
                      _buildHealthTipsSection(),
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

  Widget _buildHealthCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
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

  Widget _buildHealthOverviewSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Color(0xFF9C27B0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '2 weeks postpartum',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHealthStat('Recovery', '65%'),
              _buildHealthStat('Mood Score', '8/10'),
              _buildHealthStat('Energy', 'Good'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to quick health check
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quick Health Check - Coming Soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF9C27B0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Quick Health Check'),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Health Checklist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildChecklistItem('Take prenatal vitamin', true),
        _buildChecklistItem('Check bleeding/discharge', false),
        _buildChecklistItem('Monitor mood and energy', true),
        _buildChecklistItem('Do pelvic floor exercises', false),
        _buildChecklistItem('Get adequate rest', true),
        _buildChecklistItem('Stay hydrated', false),
      ],
    );
  }

  Widget _buildChecklistItem(String item, bool isCompleted) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle completion status (you can implement actual state management here)
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$item ${isCompleted ? 'unchecked' : 'checked'}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCompleted ? Colors.green[200]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey[400]!,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningSignsSection() {
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
              Icon(Icons.warning, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'When to Contact Your Doctor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildWarningItem('Heavy bleeding (soaking a pad per hour)'),
          _buildWarningItem('Fever over 100.4°F (38°C)'),
          _buildWarningItem('Severe abdominal or pelvic pain'),
          _buildWarningItem('Foul-smelling discharge'),
          _buildWarningItem('Signs of blood clots (leg pain, swelling)'),
          _buildWarningItem('Difficulty breathing or chest pain'),
          _buildWarningItem('Severe mood changes or thoughts of harm'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _showEmergencyContactDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Emergency Contact', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String warning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.red, fontSize: 16)),
          Expanded(
            child: Text(
              warning,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Health Tips',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildHealthTipCard(
          'Sleep & Rest',
          'Rest when your baby rests. Sleep is crucial for recovery.',
          Icons.bedtime,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildHealthTipCard(
          'Gentle Movement',
          'Start with short walks when cleared by your doctor.',
          Icons.directions_walk,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildHealthTipCard(
          'Emotional Care',
          'Talk about your feelings. It\'s normal to have ups and downs.',
          Icons.favorite,
          Colors.pink,
        ),
        const SizedBox(height: 12),
        _buildHealthTipCard(
          'Ask for Help',
          'Don\'t hesitate to ask family and friends for support.',
          Icons.support_agent,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildHealthTipCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
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
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
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
                      onTap: () => _navigateToPage('/new-mother/dashboard'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      onTap: () => _navigateToPage('/new-mother/resources'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      onTap: () => _navigateToPage('/new-mother/appointments'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Nutrition',
                      onTap: () => _navigateToPage('/new-mother/nutrition'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Health',
                      isActive: true,
                      onTap: () => _navigateToPage('/new-mother/health'),
                      textColor: const Color(0xFF7DA8E6),
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

  void _showEmergencyContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.emergency, color: Colors.red),
              SizedBox(width: 8),
              Text('Emergency Contacts'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Emergency Services: 911'),
              SizedBox(height: 8),
              Text('Your Doctor: [Your doctor\'s number]'),
              SizedBox(height: 8),
              Text('Hospital: [Hospital number]'),
              SizedBox(height: 8),
              Text('Postpartum Support: [Support line]'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // You can implement actual calling functionality here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling emergency services...')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Call 911', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}