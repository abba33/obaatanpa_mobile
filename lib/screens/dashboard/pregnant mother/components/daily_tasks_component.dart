import 'package:flutter/material.dart';

class DailyTasksCard extends StatefulWidget {
  final int currentWeek;
  final String trimester;

  const DailyTasksCard({
    Key? key,
    required this.currentWeek,
    required this.trimester,
  }) : super(key: key);

  @override
  State<DailyTasksCard> createState() => _DailyTasksCardState();
}

class _DailyTasksCardState extends State<DailyTasksCard> {
  List<TaskItem> tasks = [];

  // Enhanced color scheme
  static const Color primaryColor = Color(0xFFF59297);
  static const Color secondaryColor = Color(0xFF7DA8E6);
  static const Color lightPrimary = Color(0xFFFFF2F3);
  static const Color lightSecondary = Color(0xFFF0F6FF);

  @override
  void initState() {
    super.initState();
    _generateDailyTasks();
  }

  void _generateDailyTasks() {
    tasks = _getTasksForWeek(widget.currentWeek, widget.trimester);
  }

  List<TaskItem> _getTasksForWeek(int week, String trimester) {
    // Generate personalized tasks based on pregnancy week and trimester
    List<TaskItem> weeklyTasks = [];

    if (trimester == 'First') {
      weeklyTasks = [
        TaskItem(
          id: 'prenatal_vitamin',
          title: 'Take prenatal vitamin',
          emoji: '💊',
          backgroundColor: const Color(0xFF4CAF50),
          isCompleted: false,
        ),
        TaskItem(
          id: 'water_intake',
          title: 'Drink 8 glasses of water',
          emoji: '💧',
          backgroundColor: secondaryColor,
          isCompleted: false,
        ),
        TaskItem(
          id: 'morning_sickness',
          title: 'Track symptoms',
          emoji: '📝',
          backgroundColor: const Color(0xFFFF9800),
          isCompleted: false,
        ),
      ];
    } else if (trimester == 'Second') {
      weeklyTasks = [
        TaskItem(
          id: 'prenatal_vitamin',
          title: 'Take prenatal vitamin',
          emoji: '💊',
          backgroundColor: const Color(0xFF4CAF50),
          isCompleted: false,
        ),
        TaskItem(
          id: 'exercise',
          title: '30min gentle exercise',
          emoji: '🏃‍♀️',
          backgroundColor: primaryColor,
          isCompleted: false,
        ),
        TaskItem(
          id: 'baby_shopping',
          title: 'Research baby essentials',
          emoji: '🍼',
          backgroundColor: const Color(0xFF9C27B0),
          isCompleted: false,
        ),
      ];
    } else {
      // Third trimester
      weeklyTasks = [
        TaskItem(
          id: 'prenatal_vitamin',
          title: 'Take prenatal vitamin',
          emoji: '💊',
          backgroundColor: const Color(0xFF4CAF50),
          isCompleted: false,
        ),
        TaskItem(
          id: 'breathing_exercises',
          title: 'Practice breathing exercises',
          emoji: '🧘‍♀️',
          backgroundColor: const Color(0xFF00BCD4),
          isCompleted: false,
        ),
        TaskItem(
          id: 'hospital_bag',
          title: 'Prepare hospital bag',
          emoji: '👜',
          backgroundColor: const Color(0xFFFF5722),
          isCompleted: false,
        ),
      ];
    }

    // Add week-specific tasks
    if (week >= 12 && week <= 16) {
      weeklyTasks.add(TaskItem(
        id: 'genetic_screening',
        title: 'Schedule genetic screening',
        emoji: '🧬',
        backgroundColor: const Color(0xFF607D8B),
        isCompleted: false,
      ));
    } else if (week >= 24 && week <= 28) {
      weeklyTasks.add(TaskItem(
        id: 'glucose_test',
        title: 'Schedule glucose test',
        emoji: '🩸',
        backgroundColor: const Color(0xFFF44336),
        isCompleted: false,
      ));
    } else if (week >= 36) {
      weeklyTasks.add(TaskItem(
        id: 'labor_signs',
        title: 'Review signs of labor',
        emoji: '📋',
        backgroundColor: const Color(0xFF3F51B5),
        isCompleted: false,
      ));
    }

    return weeklyTasks.take(4).toList(); // Return up to 4 tasks
  }

  void _toggleTask(String taskId) {
    setState(() {
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex].isCompleted = !tasks[taskIndex].isCompleted;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12), // Reduced from 16 to 12
        _buildTasksList(),
        const SizedBox(height: 12), // Reduced from 16 to 12
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildHeader() {
    final completedCount = _getCompletedCount();
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8), // Reduced from 10 to 8
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10), // Reduced from 12 to 10
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.task_alt,
            color: Colors.white,
            size: 18, // Reduced from 20 to 18
          ),
        ),
        const SizedBox(width: 10), // Reduced from 12 to 10
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today\'s Tasks',
                style: TextStyle(
                  fontSize: 17, // Reduced from 18 to 17
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Week ${widget.currentWeek} • ${widget.trimester} Trimester',
                style: TextStyle(
                  fontSize: 11, // Reduced from 12 to 11
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced horizontal from 12 to 10
          decoration: BoxDecoration(
            color: completedCount == tasks.length 
              ? primaryColor.withOpacity(0.1)
              : secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14), // Reduced from 16 to 14
            border: Border.all(
              color: completedCount == tasks.length 
                ? primaryColor.withOpacity(0.3)
                : secondaryColor.withOpacity(0.3), 
              width: 1
            ),
          ),
          child: Text(
            '$completedCount/${tasks.length}',
            style: TextStyle(
              fontSize: 12, // Reduced from 13 to 12
              fontWeight: FontWeight.w600,
              color: completedCount == tasks.length 
                ? primaryColor
                : secondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksList() {
    return Column(
      children: tasks.asMap().entries.map((entry) {
        int index = entry.key;
        TaskItem task = entry.value;
        return Container(
          margin: EdgeInsets.only(bottom: index < tasks.length - 1 ? 8 : 0), // Reduced from 10 to 8
          child: _buildTaskItem(task),
        );
      }).toList(),
    );
  }

  Widget _buildTaskItem(TaskItem task) {
    return GestureDetector(
      onTap: () => _toggleTask(task.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Reduced vertical from 12 to 8
        child: Row(
          children: [
            // Compact Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22, // Reduced from 24 to 22
              height: 22, // Reduced from 24 to 22
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted 
                    ? primaryColor
                    : Colors.grey.shade400,
                  width: 2,
                ),
                color: task.isCompleted 
                  ? primaryColor
                  : Colors.transparent,
                boxShadow: task.isCompleted ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: task.isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14, // Reduced from 16 to 14
                  )
                : null,
            ),
            const SizedBox(width: 12), // Reduced from 16 to 12
            
            // Emoji icon
            Container(
              padding: const EdgeInsets.all(6), // Reduced from 8 to 6
              decoration: BoxDecoration(
                color: task.backgroundColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8), // Reduced from 10 to 8
                border: Border.all(
                  color: task.backgroundColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                task.emoji,
                style: const TextStyle(fontSize: 16), // Reduced from 18 to 16
              ),
            ),
            const SizedBox(width: 12), // Reduced from 14 to 12
            
            // Task content
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 14, // Reduced from 15 to 14
                  fontWeight: FontWeight.w600,
                  color: task.isCompleted 
                    ? Colors.grey.shade600 
                    : Colors.black87,
                  decoration: task.isCompleted 
                    ? TextDecoration.lineThrough 
                    : null,
                ),
              ),
            ),
            
            // Completion indicator
            if (task.isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Reduced padding
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.15),
                      secondaryColor.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10), // Reduced from 12 to 10
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '✓ Done',
                  style: TextStyle(
                    fontSize: 10, // Reduced from 11 to 10
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final completedCount = _getCompletedCount();
    final progress = tasks.isNotEmpty ? completedCount / tasks.length : 0.0;
    final isComplete = progress == 1.0;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 12, // Reduced from 13 to 12
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: TextStyle(
                fontSize: 12, // Reduced from 13 to 12
                fontWeight: FontWeight.w600,
                color: isComplete ? primaryColor : secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6), // Reduced from 8 to 6
        Container(
          height: 5, // Reduced from 6 to 5
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2.5),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: progress,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5, // Reduced from 6 to 5
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isComplete 
                        ? [primaryColor, primaryColor.withOpacity(0.8)]
                        : [secondaryColor, secondaryColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(2.5),
                    boxShadow: [
                      BoxShadow(
                        color: (isComplete ? primaryColor : secondaryColor).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isComplete) ...[
          const SizedBox(height: 10), // Reduced from 12 to 10
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Reduced padding
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  secondaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14), // Reduced from 16 to 14
              border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 12)), // Reduced from 14 to 12
                const SizedBox(width: 5), // Reduced from 6 to 5
                Text(
                  'All done! Great job today!',
                  style: TextStyle(
                    fontSize: 11, // Reduced from 12 to 11
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  int _getCompletedCount() {
    return tasks.where((task) => task.isCompleted).length;
  }
}

class TaskItem {
  final String id;
  final String title;
  final String emoji;
  final Color backgroundColor;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.emoji,
    required this.backgroundColor,
    required this.isCompleted,
  });
}