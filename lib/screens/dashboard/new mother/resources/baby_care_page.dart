import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';


class BabyCareePage extends StatefulWidget {
  const BabyCareePage({Key? key}) : super(key: key);

  @override
  State<BabyCareePage> createState() => _BabyCarePageState();
}

class _BabyCarePageState extends State<BabyCareePage> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom App Bar
          CustomAppBar(
            isMenuOpen: _isMenuOpen,
            onMenuTap: _toggleMenu,
            title: 'Baby Care',
          ),
          
          // Baby Care Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baby Info Header
                  _buildBabyInfoSection(),
                  const SizedBox(height: 24),
                  
                  // Quick Care Actions
                  _buildQuickActionsSection(),
                  const SizedBox(height: 24),
                  
                  // Care Essentials
                  _buildCareEssentialsSection(),
                  const SizedBox(height: 24),
                  
                  // Development Milestones
                  _buildDevelopmentSection(),
                  const SizedBox(height: 24),
                  
                  // Care Tips
                  _buildCareTipsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabyInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB6C1), Color(0xFFFFC0CB)],
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
                  Icons.child_care,
                  color: Color(0xFFFFB6C1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Baby Sarah',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '2 weeks old',
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
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBabyStatItem('Weight', '3.2 kg'),
              const SizedBox(width: 24),
              _buildBabyStatItem('Length', '50 cm'),
              const SizedBox(width: 24),
              _buildBabyStatItem('Feeds/day', '8-12'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBabyStatItem(String label, String value) {
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

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Log Feeding',
                Icons.restaurant,
                const Color(0xFF7DA8E6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Track Sleep',
                Icons.bedtime,
                const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Diaper Change',
                Icons.baby_changing_station,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Growth Track',
                Icons.trending_up,
                const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle navigation to specific tracking page
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
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
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareEssentialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Care Essentials',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildCareEssentialCard(
          'Feeding',
          'Newborns need 8-12 feeds per day',
          Icons.restaurant,
          Colors.blue,
          ['Every 2-3 hours', 'Watch for hunger cues', 'Burp after feeding'],
        ),
        const SizedBox(height: 16),
        _buildCareEssentialCard(
          'Sleeping',
          'Newborns sleep 14-17 hours per day',
          Icons.bedtime,
          Colors.purple,
          ['Back sleeping position', 'Safe sleep environment', 'Room sharing'],
        ),
        const SizedBox(height: 16),
        _buildCareEssentialCard(
          'Hygiene',
          'Keep baby clean and comfortable',
          Icons.spa,
          Colors.green,
          ['Gentle sponge baths', 'Clean diaper area', 'Trim nails carefully'],
        ),
      ],
    );
  }

  Widget _buildCareEssentialCard(String title, String description, IconData icon, Color color, List<String> tips) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: color, fontSize: 14)),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildDevelopmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Development Milestones (0-2 weeks)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildMilestoneCard('Physical', 'Reflexes present, irregular sleep patterns'),
        _buildMilestoneCard('Sensory', 'Recognizes mother\'s voice, focuses 8-12 inches'),
        _buildMilestoneCard('Social', 'Makes eye contact, responds to touch'),
        _buildMilestoneCard('Communication', 'Crying to communicate needs'),
      ],
    );
  }

  Widget _buildMilestoneCard(String category, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7DA8E6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7DA8E6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7DA8E6),
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
    );
  }

  Widget _buildCareTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Care Tips',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildTipCard('Support baby\'s head and neck when lifting'),
        _buildTipCard('Skin-to-skin contact promotes bonding'),
        _buildTipCard('Watch for signs of overstimulation'),
        _buildTipCard('Create a calm environment for sleep'),
        _buildTipCard('Trust your instincts - you know your baby'),
      ],
    );
  }

  Widget _buildTipCard(String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.tips_and_updates,
            color: Color(0xFF7DA8E6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
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
}