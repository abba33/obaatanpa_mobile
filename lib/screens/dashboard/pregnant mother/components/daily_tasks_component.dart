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
          title: 'Take your daily prenatal vitamin',
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
          title: 'Track morning sickness symptoms',
          emoji: '📝',
          backgroundColor: const Color(0xFFFF9800),
          isCompleted: false,
        ),
      ];
    } else if (trimester == 'Second') {
      weeklyTasks = [
        TaskItem(
          id: 'prenatal_vitamin',
          title: 'Take your daily prenatal vitamin',
          emoji: '💊',
          backgroundColor: const Color(0xFF4CAF50),
          isCompleted: false,
        ),
        TaskItem(
          id: 'exercise',
          title: 'Do 30 minutes of gentle exercise',
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
          title: 'Take your daily prenatal vitamin',
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
          title: 'Prepare hospital bag checklist',
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
        title: 'Schedule glucose screening test',
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

    return weeklyTasks.take(3).toList(); // Return only 3 tasks
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          ...tasks.asMap().entries.map((entry) {
            int index = entry.key;
            TaskItem task = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: index < tasks.length - 1 ? 16 : 0),
              child: _buildTaskItem(task),
            );
          }).toList(),
          const SizedBox(height: 16),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: lightPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
          ),
          child: const Text(
            '📋',
            style: TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today\'s Tasks',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Week ${widget.currentWeek} • ${widget.trimester} Trimester',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: secondaryColor.withOpacity(0.3), width: 1),
          ),
          child: Text(
            '${_getCompletedCount()}/${tasks.length}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(TaskItem task) {
    return GestureDetector(
      onTap: () => _toggleTask(task.id),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: task.isCompleted 
            ? lightPrimary
            : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: task.isCompleted 
              ? primaryColor.withOpacity(0.3)
              : Colors.grey[200]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: task.isCompleted 
                ? primaryColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Enhanced Checkbox
            Container(
              width: 28,
              height: 28,
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
                  : Colors.white,
                boxShadow: task.isCompleted ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: task.isCompleted
                ? const Center(
                    child: Text(
                      '✓',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            ),
            const SizedBox(width: 18),
            
            // Task content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted 
                        ? Colors.grey.shade600 
                        : Colors.black87,
                      decoration: task.isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                      height: 1.3,
                    ),
                  ),
                  if (task.isCompleted) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Completed! Great job 👏',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Enhanced Icon with background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: task.isCompleted 
                  ? task.backgroundColor.withOpacity(0.15)
                  : task.backgroundColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: task.backgroundColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                task.emoji,
                style: const TextStyle(
                  fontSize: 24,
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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Progress',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: progress == 1.0 ? primaryColor : secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: progress == 1.0 ? primaryColor : secondaryColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: (progress == 1.0 ? primaryColor : secondaryColor).withOpacity(0.3),
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
        if (progress == 1.0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: lightPrimary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  'All tasks completed for today!',
                  style: TextStyle(
                    fontSize: 12,
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