import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';


class BreastfeedingPage extends StatefulWidget {
  const BreastfeedingPage({Key? key}) : super(key: key);

  @override
  State<BreastfeedingPage> createState() => _BreastfeedingPageState();
}

class _BreastfeedingPageState extends State<BreastfeedingPage> {
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
            title: 'Breastfeeding',
          ),
          
          // Breastfeeding Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Feeding Overview
                  _buildFeedingOverviewSection(),
                  const SizedBox(height: 24),
                  
                  // Quick Actions
                  _buildQuickActionsSection(),
                  const SizedBox(height: 24),
                  
                  // Feeding Guide
                  _buildFeedingGuideSection(),
                  const SizedBox(height: 24),
                  
                  // Common Challenges
                  _buildChallengesSection(),
                  const SizedBox(height: 24),
                  
                  // Tips and Resources
                  _buildTipsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedingOverviewSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
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
                decoration: BoxDecoration(
                  color: const Color(0xFF7DA8E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Feeding',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    Text(
                      '8 feeds completed',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF424242),
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
              _buildFeedingStat('Last Feed', '2 hours ago'),
              _buildFeedingStat('Duration', '25 minutes'),
              _buildFeedingStat('Side', 'Left breast'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedingStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
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
                'Start Feeding',
                Icons.play_arrow,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'View History',
                Icons.history,
                const Color(0xFF7DA8E6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Set Reminder',
                Icons.notifications,
                const Color(0xFFFF9800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Lactation Help',
                Icons.support_agent,
                const Color(0xFF9C27B0),
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
        // Handle action
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

  Widget _buildFeedingGuideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feeding Guide',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildGuideCard(
          'Proper Latch',
          'Ensure baby\'s mouth covers areola, not just nipple',
          Icons.info_outline,
          Colors.blue,
          [
            'Baby\'s mouth wide open',
            'Lips flared outward',
            'More areola visible above lip',
            'No pain during feeding',
          ],
        ),
        const SizedBox(height: 16),
        _buildGuideCard(
          'Feeding Positions',
          'Try different positions for comfort',
          Icons.accessibility,
          Colors.green,
          [
            'Cradle hold',
            'Cross-cradle hold',
            'Football/clutch hold',
            'Side-lying position',
          ],
        ),
        const SizedBox(height: 16),
        _buildGuideCard(
          'Feeding Frequency',
          'Newborns feed 8-12 times per day',
          Icons.schedule,
          Colors.orange,
          [
            'Every 2-3 hours',
            'Watch for hunger cues',
            'Don\'t wait for crying',
            'Follow baby\'s lead',
          ],
        ),
      ],
    );
  }

  Widget _buildGuideCard(String title, String description, IconData icon, Color color, List<String> points) {
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
          ...points.map((point) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: color, fontSize: 14)),
                Expanded(
                  child: Text(
                    point,
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

  Widget _buildChallengesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Common Challenges & Solutions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildChallengeCard(
          'Sore Nipples',
          'Try different positions, check latch, use nipple cream',
          Icons.healing,
          Colors.red,
        ),
        _buildChallengeCard(
          'Low Milk Supply',
          'Frequent feeding, proper hydration, rest',
          Icons.opacity,
          Colors.blue,
        ),
        _buildChallengeCard(
          'Engorgement',
          'Frequent feeding, cold compress, gentle massage',
          Icons.warning,
          Colors.orange,
        ),
        _buildChallengeCard(
          'Baby Won\'t Latch',
          'Skin-to-skin contact, try when baby is calm',
          Icons.baby_changing_station,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildChallengeCard(String challenge, String solution, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  solution,
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

  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Helpful Tips',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildTipCard('Stay hydrated - drink water before, during, and after feeding'),
        _buildTipCard('Eat a balanced diet rich in nutrients'),
        _buildTipCard('Get plenty of rest when possible'),
        _buildTipCard('Trust your body - you\'re making enough milk'),
        _buildTipCard('Seek help from lactation consultants if needed'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.phone, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Contact your lactation consultant or healthcare provider if you\'re experiencing persistent challenges. Early support can make a big difference!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Handle contact action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Contact Support'),
              ),
            ],
          ),
        ),
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