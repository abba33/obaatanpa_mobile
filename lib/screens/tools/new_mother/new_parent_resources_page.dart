import 'package:flutter/material.dart';

class NewParentResourcesPage extends StatelessWidget {
  const NewParentResourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Parent Resources'),
        backgroundColor: const Color(0xFF9B59B6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildGuideSection('Baby Care Basics', _babyBasics),
            const SizedBox(height: 20),
            _buildGuideSection('Postpartum Recovery', _postpartumGuides),
            const SizedBox(height: 20),
            _buildGuideSection('Mental Health Support', _mentalHealthResources),
            const SizedBox(height: 20),
            _buildEmergencyCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to Resources',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B59B6),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Find helpful guides, tips, and information for your journey as a new parent. We\'re here to support you every step of the way.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection(String title, List<Map<String, dynamic>> guides) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B59B6),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: guides.length,
          itemBuilder: (context, index) {
            final guide = guides[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(guide['icon'] as IconData,
                    color: const Color(0xFF9B59B6)),
                title: Text(guide['title'] as String),
                subtitle: Text(guide['description'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigate to detailed guide page
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmergencyCard() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Resources',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'If you need immediate assistance, don\'t hesitate to reach out:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildEmergencyButton(
              'Contact Healthcare Provider',
              Icons.local_hospital,
              () {
                // TODO: Implement healthcare provider contact
              },
            ),
            const SizedBox(height: 8),
            _buildEmergencyButton(
              'Mental Health Helpline',
              Icons.phone,
              () {
                // TODO: Implement helpline contact
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _babyBasics = [
  {
    'icon': Icons.baby_changing_station,
    'title': 'Newborn Care',
    'description': 'Essential tips for caring for your newborn',
  },
  {
    'icon': Icons.restaurant_menu,
    'title': 'Feeding Guide',
    'description': 'Breastfeeding and bottle feeding basics',
  },
  {
    'icon': Icons.night_shelter,
    'title': 'Sleep Patterns',
    'description': 'Understanding and managing baby sleep',
  },
];

final List<Map<String, dynamic>> _postpartumGuides = [
  {
    'icon': Icons.healing,
    'title': 'Physical Recovery',
    'description': 'Tips for postpartum healing',
  },
  {
    'icon': Icons.fitness_center,
    'title': 'Safe Exercises',
    'description': 'Gentle postpartum workout guides',
  },
  {
    'icon': Icons.restaurant,
    'title': 'Nutrition Guide',
    'description': 'Healthy eating for new mothers',
  },
];

final List<Map<String, dynamic>> _mentalHealthResources = [
  {
    'icon': Icons.mood,
    'title': 'Emotional Wellbeing',
    'description': 'Managing the emotional transition',
  },
  {
    'icon': Icons.people,
    'title': 'Support Groups',
    'description': 'Connect with other new parents',
  },
  {
    'icon': Icons.psychology,
    'title': 'Professional Help',
    'description': 'When and how to seek professional support',
  },
];
