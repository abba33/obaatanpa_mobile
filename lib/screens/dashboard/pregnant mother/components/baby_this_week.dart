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
    
    return Column(
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
                  colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
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
        
        // Size comparison section with real images
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF59297).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF59297).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Real fruit/vegetable image
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
                  child: Image.network(
                    sizeComparison['imageUrl'],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFFF59297),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback with emoji if image not found
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFF59297).withOpacity(0.2),
                              const Color(0xFF7DA8E6).withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            sizeComparison['emoji'],
                            style: const TextStyle(fontSize: 40),
                          ),
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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF59297),
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
            border: Border.all(
              color: const Color(0xFF7DA8E6).withOpacity(0.3),
              width: 1,
            ),
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
            color: const Color(0xFFF59297).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF59297).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pregnant_woman,
                    color: const Color(0xFFF59297),
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
          child: GestureDetector(
            onTap: () {
              // Handle learn more action
              print('Learn more about week $currentWeek');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59297).withOpacity(0.3),
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
        ),
      ],
    );
  }

  Map<String, dynamic> _getSizeComparison(int week) {
    if (week <= 4) {
      return {
        'name': 'a Poppy Seed',
        'measurement': '2mm',
        'emoji': '•',
        'imageUrl': 'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=400&h=400&fit=crop&crop=center',
        'description': 'Tiny but already forming!'
      };
    } else if (week <= 6) {
      return {
        'name': 'a Sweet Pea',
        'measurement': '4mm',
        'emoji': '🌱',
        'imageUrl': 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400&h=400&fit=crop&crop=center',
        'description': 'Heart is beginning to beat!'
      };
    } else if (week <= 8) {
      return {
        'name': 'a Raspberry',
        'measurement': '1.6cm',
        'emoji': '🫐',
        'imageUrl': 'https://images.unsplash.com/photo-1577003833619-76bfe1a81b75?w=400&h=400&fit=crop&crop=center',
        'description': 'Arms and legs are developing!'
      };
    } else if (week <= 10) {
      return {
        'name': 'a Strawberry',
        'measurement': '3.1cm',
        'emoji': '🍓',
        'imageUrl': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&h=400&fit=crop&crop=center',
        'description': 'Vital organs are forming!'
      };
    } else if (week <= 12) {
      return {
        'name': 'a Lime',
        'measurement': '5.4cm',
        'emoji': '🟢',
        'imageUrl': 'https://images.unsplash.com/photo-1582979512210-99b6a53386f9?w=400&h=400&fit=crop&crop=center',
        'description': 'Reflexes are developing!'
      };
    } else if (week <= 16) {
      return {
        'name': 'an Avocado',
        'measurement': '11.6cm',
        'emoji': '🥑',
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&h=400&fit=crop&crop=center',
        'description': 'Can hear your voice!'
      };
    } else if (week <= 20) {
      return {
        'name': 'a Banana',
        'measurement': '16.4cm',
        'emoji': '🍌',
        'imageUrl': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop&crop=center',
        'description': 'You might feel kicks now!'
      };
    } else if (week <= 24) {
      return {
        'name': 'an Ear of Corn',
        'measurement': '21.3cm',
        'emoji': '🌽',
        'imageUrl': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400&h=400&fit=crop&crop=center',
        'description': 'Hearing is fully developed!'
      };
    } else if (week <= 28) {
      return {
        'name': 'an Eggplant',
        'measurement': '25.4cm',
        'emoji': '🍆',
        'imageUrl': 'https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400&h=400&fit=crop&crop=center',
        'description': 'Eyes are opening!'
      };
    } else if (week <= 32) {
      return {
        'name': 'a Coconut',
        'measurement': '28.9cm',
        'emoji': '🥥',
        'imageUrl': 'https://images.unsplash.com/photo-1605027990121-cbae9d0b26ab?w=400&h=400&fit=crop&crop=center',
        'description': 'Bones are hardening!'
      };
    } else if (week <= 36) {
      return {
        'name': 'a Pineapple',
        'measurement': '32.4cm',
        'emoji': '🍍',
        'imageUrl': 'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=400&h=400&fit=crop&crop=center',
        'description': 'Lungs are maturing!'
      };
    } else {
      return {
        'name': 'a Watermelon',
        'measurement': '36.2cm',
        'emoji': '🍉',
        'imageUrl': 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400&h=400&fit=crop&crop=center',
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