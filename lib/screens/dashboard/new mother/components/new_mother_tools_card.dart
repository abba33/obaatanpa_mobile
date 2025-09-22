import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewMotherToolsCard extends StatelessWidget {
  final int currentWeek;

  const NewMotherToolsCard({
    Key? key,
    required this.currentWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tools = _getPostpartumTools(currentWeek);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF9B59B6), // Purple theme for new mother
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.build,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Postpartum Care Tools',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Week $currentWeek recovery essentials',
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
    );
  }

  Widget _buildToolCard(Map<String, dynamic> tool) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Navigate to appropriate page based on tool type
          _navigateToTool(context, tool['title']);
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
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
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
                      Icon(
                        tool['icon'] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tool['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tool['subtitle'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTool(BuildContext context, String toolTitle) {
    // Navigate to appropriate page based on tool type
    switch (toolTitle) {
      case 'Recovery Tracker':
      case 'Pain Monitor':
      case 'Mood Tracker':
        context.go('/new-mother/health/recovery');
        break;
      case 'Feeding Log':
      case 'Sleep Tracker':
        context.go('/new-mother/resources/baby-care');
        break;
      case 'Exercise Guide':
        context.go('/new-mother/health/recovery');
        break;
      case 'Baby Care':
        context.go('/new-mother/resources/baby-care');
        break;
      case 'Nutrition Guide':
        context.go('/new-mother/resources/nutrition');
        break;
      case 'Support Network':
        context.go('/new-mother/resources/support');
        break;
      default:
        context.go('/new-mother/resources');
    }
  }

  List<Map<String, dynamic>> _getPostpartumTools(int week) {
    return [
      {
        'title': 'Recovery Tracker',
        'subtitle': 'Monitor healing progress',
        'color': const Color(0xFF9B59B6),
        'icon': Icons.trending_up,
        'imagePath': 'assets/images/tools/recovery_tracker.png',
      },
      {
        'title': 'Feeding Log',
        'subtitle': 'Track baby\'s feedings',
        'color': const Color(0xFF2ECC71),
        'icon': Icons.child_care,
        'imagePath': 'assets/images/tools/feeding_log.png',
      },
      {
        'title': 'Sleep Tracker',
        'subtitle': 'Baby sleep patterns',
        'color': const Color(0xFF3498DB),
        'icon': Icons.nightlight_round,
        'imagePath': 'assets/images/tools/sleep_tracker.png',
      },
      {
        'title': 'Mood Tracker',
        'subtitle': 'Emotional wellbeing',
        'color': const Color(0xFFE74C3C),
        'icon': Icons.mood,
        'imagePath': 'assets/images/tools/mood_tracker.png',
      },
      {
        'title': 'Exercise Guide',
        'subtitle': 'Safe postpartum workouts',
        'color': const Color(0xFFF1C40F),
        'icon': Icons.fitness_center,
        'imagePath': 'assets/images/tools/exercise_guide.png',
      },
      {
        'title': 'Support Network',
        'subtitle': 'Connect with others',
        'color': const Color(0xFF1ABC9C),
        'icon': Icons.people,
        'imagePath': 'assets/images/tools/support_network.png',
      },
    ];
  }
}
