import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/pregnancy_data_provider.dart';

class PersonalizedQuickActionsRow extends StatefulWidget {
  final int currentWeek;
  final String trimester;

  const PersonalizedQuickActionsRow({
    Key? key,
    required this.currentWeek,
    required this.trimester,
  }) : super(key: key);

  @override
  State<PersonalizedQuickActionsRow> createState() => _PersonalizedQuickActionsRowState();
}

class _PersonalizedQuickActionsRowState extends State<PersonalizedQuickActionsRow> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weekFocusData = _getWeekSpecificActionsData(widget.currentWeek);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Scrollable Cards - Personalized based on pregnancy stage
        Container(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 16, bottom: 10, top: 5),
            itemCount: _getPersonalizedActionsData(widget.currentWeek, widget.trimester).length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final actionData = _getPersonalizedActionsData(widget.currentWeek, widget.trimester)[index];
              return _buildScrollableQuickAction(
                icon: actionData['icon'],
                title: actionData['title'],
                subtitle: actionData['subtitle'],
                color: actionData['color'],
                onTap: actionData['onTap'],
              );
            },
          ),
        ),
        
        const SizedBox(height: 20),
        
        // This Week's Focus - Horizontal Scrollable with dots
        Row(
          children: [
            const Text(
              'This Week\'s Focus',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.lightbulb_outline,
              color: Colors.orange,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Horizontal PageView for This Week's Focus - Updated UI
        Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 15),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: weekFocusData.length,
            itemBuilder: (context, index) {
              final focusData = weekFocusData[index];
              return Container(
                margin: const EdgeInsets.only(right: 16, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF87CEEB), // Light sky blue
                      Color(0xFF4FC3F7), // Light blue
                      Color(0xFF29B6F6), // Blue
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with icon and title
                          Row(
                            children: [
                              Text(
                                'This Week\'s Focus',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.lightbulb,
                                color: Colors.yellow,
                                size: 14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          
                          // Focus title
                          Text(
                            focusData['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          
                          // Description
                          Expanded(
                            child: Text(
                              focusData['description'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                height: 1.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Decorative circles - matching the image
                    Positioned(
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      right: 15,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 40,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Pagination dots - matching the image style
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            weekFocusData.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPage == index 
                  ? const Color(0xFFF8BBD9) // Pink for active dot
                  : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getPersonalizedActionsData(int week, String trimester) {
    List<Map<String, dynamic>> actions = [];
    
    // Base actions always available
    actions.addAll([
      {
        'icon': Icons.restaurant_menu,
        'title': "${trimester} Meals",
        'subtitle': 'Trimester-specific nutrition',
        'color': const Color(0xFFFF6B6B),
        'onTap': () {},
      },
      {
        'icon': Icons.favorite_border,
        'title': 'Health Tips',
        'subtitle': 'Daily wellness advice',
        'color': const Color(0xFFFF9800),
        'onTap': () {},
      },
      {
        'icon': Icons.book_outlined,
        'title': 'Learn',
        'subtitle': 'Pregnancy education',
        'color': const Color(0xFF4CAF50),
        'onTap': () {},
      },
      {
        'icon': Icons.schedule,
        'title': 'Appointments',
        'subtitle': 'Track your visits',
        'color': const Color(0xFF2196F3),
        'onTap': () {},
      },
      {
        'icon': Icons.baby_changing_station,
        'title': 'Baby Prep',
        'subtitle': 'Get ready for baby',
        'color': const Color(0xFF9C27B0),
        'onTap': () {},
      },
    ]);

    // Trimester-specific actions
    if (trimester == 'First') {
      actions.addAll([
        {
          'icon': Icons.medical_information,
          'title': 'First Visit',
          'subtitle': 'Prenatal appointment',
          'color': const Color(0xFF90EE90),
          'onTap': () {},
        },
        {
          'icon': Icons.sick,
          'title': 'Morning Sickness',
          'subtitle': 'Relief tips & tracking',
          'color': const Color(0xFFDDA0DD),
          'onTap': () {},
        },
        {
          'icon': Icons.medication,
          'title': 'Vitamins',
          'subtitle': 'Prenatal supplements',
          'color': const Color(0xFFE91E63),
          'onTap': () {},
        },
      ]);
    } else if (trimester == 'Second') {
      actions.addAll([
        {
          'icon': Icons.fitness_center,
          'title': 'Safe Exercise',
          'subtitle': 'Second trimester workouts',
          'color': const Color(0xFFFFE066),
          'onTap': () {},
        },
        {
          'icon': Icons.child_care,
          'title': 'Baby Movement',
          'subtitle': 'Track kicks & movement',
          'color': const Color(0xFFFFB6C1),
          'onTap': () {},
        },
        {
          'icon': Icons.camera_alt,
          'title': 'Ultrasound',
          'subtitle': 'Anatomy scan prep',
          'color': const Color(0xFF00BCD4),
          'onTap': () {},
        },
      ]);
    } else { // Third trimester
      actions.addAll([
        {
          'icon': Icons.local_hospital,
          'title': 'Hospital Bag',
          'subtitle': 'Delivery prep checklist',
          'color': const Color(0xFF87CEEB),
          'onTap': () {},
        },
        {
          'icon': Icons.timer,
          'title': 'Contraction Timer',
          'subtitle': 'Track labor signs',
          'color': const Color(0xFFFFA07A),
          'onTap': () {},
        },
        {
          'icon': Icons.school,
          'title': 'Birth Classes',
          'subtitle': 'Labor preparation',
          'color': const Color(0xFF8BC34A),
          'onTap': () {},
        },
      ]);
    }

    return actions;
  }

  List<Map<String, dynamic>> _getWeekSpecificActionsData(int week) {
    List<Map<String, dynamic>> actions = [];
    
    // Early pregnancy (weeks 1-12)
    if (week <= 12) {
      actions.addAll([
        {
          'title': 'Prenatal Vitamins',
          'description': 'They provide essential nutrients like folic acid, iron, calcium, and DHA, which support the healthy development of the baby',
        },
        {
          'title': 'What to Avoid',
          'description': 'Learn about foods and activities to avoid during early pregnancy for your safety and baby\'s development',
        },
        {
          'title': 'Early Symptoms',
          'description': 'Understanding common early pregnancy symptoms and when to contact your healthcare provider',
        },
      ]);
    } 
    // Mid pregnancy (weeks 13-27)
    else if (week <= 27) {
      actions.addAll([
        {
          'title': 'Ultrasound Preparation',
          'description': 'Get ready for your anatomy scan and learn what to expect during this important milestone',
        },
        {
          'title': 'Baby Shopping',
          'description': 'Essential items checklist for your growing baby and preparing your home for arrival',
        },
        {
          'title': 'Exercise Guidelines',
          'description': 'Safe exercises and activities recommended during the second trimester for optimal health',
        },
      ]);
    } 
    // Late pregnancy (weeks 28+)
    else {
      actions.addAll([
        {
          'title': 'Birth Classes',
          'description': 'Prepare for delivery with comprehensive birth education and breathing techniques',
        },
        {
          'title': 'Nursery Setup',
          'description': 'Complete checklist for setting up your baby\'s room and essential items needed',
        },
        {
          'title': 'Hospital Bag',
          'description': 'What to pack for your hospital stay and delivery day essentials for you and baby',
        },
      ]);
    }

    return actions;
  }

  Widget _buildScrollableQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}