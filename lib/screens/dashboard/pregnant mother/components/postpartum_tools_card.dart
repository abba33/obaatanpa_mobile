import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/pregnancy_data_provider.dart';

// Personalized Tools Card Component
class PersonalizedToolsCard extends StatelessWidget {
  final String trimester;
  final int currentWeek;

  const PersonalizedToolsCard({
    Key? key,
    required this.trimester,
    required this.currentWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tools = _getPersonalizedTools(trimester, currentWeek);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8BBD9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.build,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${trimester} Trimester Tools',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Week $currentWeek essentials',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          
          // Grid of tools
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return _buildToolCard(tool);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(Map<String, dynamic> tool) {
    return GestureDetector(
      onTap: () {
        // Handle tool tap - navigate to specific tool
        print('Tapped on ${tool['title']}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background image
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  tool['imagePath'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback gradient if image not found
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            tool['color'].withOpacity(0.8),
                            tool['color'].withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Gradient overlay for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        tool['icon'],
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Title
                    Text(
                      tool['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Subtitle
                    Text(
                      tool['subtitle'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9),
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Tap indicator
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getPersonalizedTools(String trimester, int week) {
    if (trimester == 'First') {
      return [
        {
          'title': 'Symptom Tracker',
          'subtitle': 'Track morning sickness & fatigue',
          'color': const Color(0xFF90EE90),
          'icon': Icons.track_changes,
          'imagePath': 'assets/images/tools/symptom_tracker.png',
        },
        {
          'title': 'Appointment Scheduler',
          'subtitle': 'First prenatal visits',
          'color': const Color(0xFF6B9BFF),
          'icon': Icons.calendar_today,
          'imagePath': 'assets/images/tools/appointment_scheduler.jpg',
        },
        {
          'title': 'Nutrition Guide',
          'subtitle': 'What to eat & avoid',
          'color': const Color(0xFFFFB6C1),
          'icon': Icons.restaurant,
          'imagePath': 'assets/images/tools/nutrition_guide.jpg',
        },
        {
          'title': 'Early Pregnancy Tips',
          'subtitle': 'Essential first trimester advice',
          'color': const Color(0xFFDDA0DD),
          'icon': Icons.lightbulb,
          'imagePath': 'assets/images/tools/early_pregnancy_tips.jpg',
        },
      ];
    } else if (trimester == 'Second') {
      return [
        {
          'title': 'Kick Counter',
          'subtitle': 'Track baby movements',
          'color': const Color(0xFFF8BBD9),
          'icon': Icons.child_friendly,
          'imagePath': 'assets/images/tools/kick_counter.png',
        },
        {
          'title': 'Weight Tracker',
          'subtitle': 'Monitor healthy gain',
          'color': const Color(0xFF90EE90),
          'icon': Icons.monitor_weight,
          'imagePath': 'assets/images/tools/weight_tracker.png',
        },
        {
          'title': 'Baby Shopping List',
          'subtitle': 'Essential items checklist',
          'color': const Color(0xFFFFE066),
          'icon': Icons.shopping_cart,
          'imagePath': 'assets/images/tools/baby_shopping_list.png',
        },
        {
          'title': 'Gender Reveal Ideas',
          'subtitle': 'Creative announcement ideas',
          'color': const Color(0xFF87CEEB),
          'icon': Icons.celebration,
          'imagePath': 'assets/images/tools/gender_reveal_ideas.png',
        },
      ];
    } else {
      return [
        {
          'title': 'Contraction Timer',
          'subtitle': 'Time labor contractions',
          'color': const Color(0xFFFF6B6B),
          'icon': Icons.timer,
          'imagePath': 'assets/images/tools/contraction_timer.jpg',
        },
        {
          'title': 'Hospital Bag',
          'subtitle': 'Delivery essentials list',
          'color': const Color(0xFF87CEEB),
          'icon': Icons.luggage,
          'imagePath': 'assets/images/tools/hospital_bag.jpg',
        },
        {
          'title': 'Birth Plan',
          'subtitle': 'Plan your ideal delivery',
          'color': const Color(0xFFDDA0DD),
          'icon': Icons.assignment,
          'imagePath': 'assets/images/tools/birth_plan.jpg',
        },
        {
          'title': 'Newborn Care',
          'subtitle': 'Essential baby care tips',
          'color': const Color(0xFFFFB6C1),
          'icon': Icons.baby_changing_station,
          'imagePath': 'assets/images/tools/newborn_care.jpg',
        },
      ];
    }
  }
}