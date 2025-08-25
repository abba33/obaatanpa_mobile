import 'package:flutter/material.dart';

// Personalized Baby This Week Card
class PersonalizedBabyThisWeekCard extends StatelessWidget {
  final Map<String, dynamic> weekInfo;
  final int currentWeek;

  const PersonalizedBabyThisWeekCard({
    Key? key,
    required this.weekInfo,
    required this.currentWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeComparison = _getSizeComparison(currentWeek);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFFF8BBD9).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8BBD9), Color(0xFFF59297)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Baby at Week $currentWeek',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Development milestone',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Size comparison section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sizeComparison['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: sizeComparison['color'].withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Fruit/vegetable image
                Container(
                  width: 80,
                  height: 80,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      sizeComparison['imagePath'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback with emoji if image not found
                        return Center(
                          child: Text(
                            sizeComparison['emoji'],
                            style: const TextStyle(fontSize: 40),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Size info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Size of ${sizeComparison['name']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sizeComparison['measurement'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: sizeComparison['color'],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sizeComparison['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Development info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF7DA8E6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: const Color(0xFF7DA8E6),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'What\'s developing this week:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  weekInfo['babyDevelopment'] ?? _getDefaultDevelopment(currentWeek),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Mother changes
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFA5D6A7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pregnant_woman,
                      color: const Color(0xFFA5D6A7),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'What\'s happening with you:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  weekInfo['motherChanges'] ?? _getDefaultMotherChanges(currentWeek),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Action button
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8BBD9), Color(0xFFF59297)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF8BBD9).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Learn More About Week $currentWeek',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getSizeComparison(int week) {
    if (week <= 4) {
      return {
        'name': 'a Poppy Seed',
        'measurement': '2mm',
        'emoji': '•',
        'imagePath': 'assets/images/sizes/poppy_seed.jpg',
        'color': const Color(0xFF8B4513),
        'description': 'Tiny but already forming!'
      };
    } else if (week <= 6) {
      return {
        'name': 'a Sweet Pea',
        'measurement': '4mm',
        'emoji': '🌱',
        'imagePath': 'assets/images/sizes/sweet_pea.jpg',
        'color': const Color(0xFF90EE90),
        'description': 'Heart is beginning to beat!'
      };
    } else if (week <= 8) {
      return {
        'name': 'a Raspberry',
        'measurement': '1.6cm',
        'emoji': '🍇',
        'imagePath': 'assets/images/sizes/raspberry.jpg',
        'color': const Color(0xFF8B008B),
        'description': 'Arms and legs are developing!'
      };
    } else if (week <= 10) {
      return {
        'name': 'a Strawberry',
        'measurement': '3.1cm',
        'emoji': '🍓',
        'imagePath': 'assets/images/sizes/strawberry.jpg',
        'color': const Color(0xFFFF69B4),
        'description': 'Vital organs are forming!'
      };
    } else if (week <= 12) {
      return {
        'name': 'a Lime',
        'measurement': '5.4cm',
        'emoji': '🟢',
        'imagePath': 'assets/images/sizes/lime.jpg',
        'color': const Color(0xFF32CD32),
        'description': 'Reflexes are developing!'
      };
    } else if (week <= 16) {
      return {
        'name': 'an Avocado',
        'measurement': '11.6cm',
        'emoji': '🥑',
        'imagePath': 'assets/images/sizes/avocado.jpg',
        'color': const Color(0xFF9ACD32),
        'description': 'Can hear your voice!'
      };
    } else if (week <= 20) {
      return {
        'name': 'a Banana',
        'measurement': '16.4cm',
        'emoji': '🍌',
        'imagePath': 'assets/images/sizes/banana.jpg',
        'color': const Color(0xFFFFD700),
        'description': 'You might feel kicks now!'
      };
    } else if (week <= 24) {
      return {
        'name': 'an Ear of Corn',
        'measurement': '21.3cm',
        'emoji': '🌽',
        'imagePath': 'assets/images/sizes/corn.jpg',
        'color': const Color(0xFFFFA500),
        'description': 'Hearing is fully developed!'
      };
    } else if (week <= 28) {
      return {
        'name': 'an Eggplant',
        'measurement': '25.4cm',
        'emoji': '🍆',
        'imagePath': 'assets/images/sizes/eggplant.jpg',
        'color': const Color(0xFF9370DB),
        'description': 'Eyes are opening!'
      };
    } else if (week <= 32) {
      return {
        'name': 'a Coconut',
        'measurement': '28.9cm',
        'emoji': '🥥',
        'imagePath': 'assets/images/sizes/coconut.jpg',
        'color': const Color(0xD2691E),
        'description': 'Bones are hardening!'
      };
    } else if (week <= 36) {
      return {
        'name': 'a Pineapple',
        'measurement': '32.4cm',
        'emoji': '🍍',
        'imagePath': 'assets/images/sizes/pineapple.jpg',
        'color': const Color(0xFFDAA520),
        'description': 'Lungs are maturing!'
      };
    } else {
      return {
        'name': 'a Watermelon',
        'measurement': '36.2cm',
        'emoji': '🍉',
        'imagePath': 'assets/images/sizes/watermelon.jpg',
        'color': const Color(0xFF32CD32),
        'description': 'Ready to meet you soon!'
      };
    }
  }

  String _getDefaultDevelopment(int week) {
    if (week <= 12) {
      return "Major organs are forming and your baby's heart is beating strong!";
    } else if (week <= 24) {
      return "Your baby can hear sounds and is developing sleep-wake cycles.";
    } else if (week <= 32) {
      return "Brain development is rapid and baby is practicing breathing movements.";
    } else {
      return "Baby is gaining weight and preparing for life outside the womb!";
    }
  }

  String _getDefaultMotherChanges(int week) {
    if (week <= 12) {
      return "You might experience morning sickness and fatigue as your body adapts.";
    } else if (week <= 24) {
      return "Energy levels improve and you might start showing more clearly.";
    } else if (week <= 32) {
      return "You'll feel more baby movements and might experience some discomfort.";
    } else {
      return "Preparing for delivery - practice breathing exercises and rest when possible.";
    }
  }
}