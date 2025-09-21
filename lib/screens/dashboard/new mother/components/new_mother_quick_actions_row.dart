import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewMotherQuickActionsRow extends StatefulWidget {
  final int currentWeek;
  final String recoveryPhase;

  const NewMotherQuickActionsRow({
    Key? key,
    this.currentWeek = 4,
    this.recoveryPhase = "Postpartum",
  }) : super(key: key);

  @override
  State<NewMotherQuickActionsRow> createState() =>
      _NewMotherQuickActionsRowState();
}

class _NewMotherQuickActionsRowState
    extends State<NewMotherQuickActionsRow> {
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
        // Horizontal Scrollable Cards - Personalized based on postpartum stage
        Container(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 16, bottom: 10, top: 5),
            itemCount: _getPersonalizedActionsData(
                    widget.currentWeek, widget.recoveryPhase)
                .length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final actionData = _getPersonalizedActionsData(
                  widget.currentWeek, widget.recoveryPhase)[index];
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
              Icons.favorite,
              color: Color(0xFFF59297),
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal PageView for This Week's Focus - Updated UI with recovery theme
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
                      Color(0xFF4CAF50), // Green for recovery
                      Color(0xFF66BB6A), // Light green
                      Color(0xFF81C784), // Lighter green
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
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
                                Icons.favorite,
                                color: Color(0xFFF59297),
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

                    // Decorative circles - matching the design
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
                    ? const Color(0xFFF59297) // Pink for active dot
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getPersonalizedActionsData(
      int week, String recoveryPhase) {
    List<Map<String, dynamic>> actions = [];

    // Base actions always available for new mothers
    actions.addAll([
      {
        'icon': Icons.restaurant_menu,
        'title': "Recovery Meals",
        'subtitle': 'Postpartum nutrition',
        'color': const Color(0xFFFF6B6B),
        'onTap': () => context.go('/recovery-nutrition'),
      },
      {
        'icon': Icons.baby_changing_station,
        'title': 'Baby Care',
        'subtitle': 'Feeding & diaper logs',
        'color': const Color(0xFF4CAF50),
        'onTap': () => context.go('/baby-care'),
      },
      {
        'icon': Icons.bedtime,
        'title': 'Sleep Tracker',
        'subtitle': 'Track rest patterns',
        'color': const Color(0xFF2196F3),
        'onTap': () => context.go('/sleep-tracker'),
      },
      {
        'icon': Icons.medical_services,
        'title': 'Health Check',
        'subtitle': 'Recovery monitoring',
        'color': const Color(0xFF9C27B0),
        'onTap': () => context.go('/health-check'),
      },
      {
        'icon': Icons.book_outlined,
        'title': 'Resources',
        'subtitle': 'New parent guides',
        'color': const Color(0xFFFF9800),
        'onTap': () => context.go('/new-parent-resources'),
      },
    ]);

    // Week-specific actions for postpartum recovery
    if (week <= 2) {
      // First 2 weeks - focus on immediate recovery
      actions.addAll([
        {
          'icon': Icons.healing,
          'title': 'Recovery Tips',
          'subtitle': 'Immediate postpartum care',
          'color': const Color(0xFFE91E63),
          'onTap': () => context.go('/recovery-tips'),
        },
        {
          'icon': Icons.support_agent,
          'title': 'Support Groups',
          'subtitle': 'Connect with new moms',
          'color': const Color(0xFF00BCD4),
          'onTap': () => context.go('/support-groups'),
        },
      ]);
    } else if (week <= 6) {
      // 2-6 weeks - establishing routines
      actions.addAll([
        {
          'icon': Icons.fitness_center,
          'title': 'Gentle Exercise',
          'subtitle': 'Safe postpartum workouts',
          'color': const Color(0xFF8BC34A),
          'onTap': () => context.go('/postpartum-exercise'),
        },
        {
          'icon': Icons.schedule,
          'title': 'Check-up',
          'subtitle': '6-week appointment prep',
          'color': const Color(0xFFFFC107),
          'onTap': () => context.go('/checkup-prep'),
        },
      ]);
    } else {
      // 6+ weeks - long-term adjustment
      actions.addAll([
        {
          'icon': Icons.self_improvement,
          'title': 'Self Care',
          'subtitle': 'Mental health & wellness',
          'color': const Color(0xFF673AB7),
          'onTap': () => context.go('/self-care'),
        },
        {
          'icon': Icons.work_outline,
          'title': 'Return to Work',
          'subtitle': 'Planning & preparation',
          'color': const Color(0xFF795548),
          'onTap': () => context.go('/return-to-work'),
        },
      ]);
    }

    return actions;
  }

  List<Map<String, dynamic>> _getWeekSpecificActionsData(int week) {
    List<Map<String, dynamic>> actions = [];

    // Early postpartum (weeks 1-2)
    if (week <= 2) {
      actions.addAll([
        {
          'title': 'Rest & Recovery',
          'description':
              'Focus on healing, getting adequate rest, and allowing your body to recover from childbirth',
        },
        {
          'title': 'Feeding Support',
          'description':
              'Whether breastfeeding or bottle feeding, establish a routine that works for you and baby',
        },
        {
          'title': 'Emotional Wellness',
          'description':
              'It\'s normal to feel overwhelmed. Seek support and don\'t hesitate to ask for help',
        },
      ]);
    }
    // Early recovery (weeks 3-6)
    else if (week <= 6) {
      actions.addAll([
        {
          'title': 'Establishing Routines',
          'description':
              'Create flexible schedules for feeding, sleeping, and self-care that work for your family',
        },
        {
          'title': 'Physical Recovery',
          'description':
              'Gentle movement and proper nutrition support your healing journey and energy levels',
        },
        {
          'title': 'Bonding Time',
          'description':
              'Enjoy skin-to-skin contact, reading, and talking to strengthen your bond with baby',
        },
      ]);
    }
    // Extended recovery (weeks 7+)
    else {
      actions.addAll([
        {
          'title': 'New Normal',
          'description':
              'Adjust to life with baby, including managing expectations and celebrating small wins',
        },
        {
          'title': 'Self Care',
          'description':
              'Prioritize your mental and physical health - you can\'t pour from an empty cup',
        },
        {
          'title': 'Future Planning',
          'description':
              'Consider childcare, work arrangements, and family planning as you look ahead',
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