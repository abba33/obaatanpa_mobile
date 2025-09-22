import 'package:flutter/material.dart';

class PostpartumDailyTasksCard extends StatefulWidget {
  final int currentWeek;

  const PostpartumDailyTasksCard({
    Key? key,
    required this.currentWeek,
  }) : super(key: key);

  @override
  State<PostpartumDailyTasksCard> createState() =>
      _PostpartumDailyTasksCardState();
}

class _PostpartumDailyTasksCardState extends State<PostpartumDailyTasksCard> {
  List<TaskItem> tasks = [];

  // Enhanced color scheme - using purple theme for new mother
  static const Color primaryColor = Color(0xFF9B59B6);
  static const Color secondaryColor = Color(0xFF7DA8E6);
  static const Color lightPrimary = Color(0xFFF5EFF8);
  static const Color lightSecondary = Color(0xFFF0F6FF);

  @override
  void initState() {
    super.initState();
    _generateDailyTasks();
  }

  void _generateDailyTasks() {
    tasks = _getTasksForPostpartumWeek(widget.currentWeek);
  }

  List<TaskItem> _getTasksForPostpartumWeek(int week) {
    List<TaskItem> weeklyTasks = [
      // Core daily tasks for all weeks
      TaskItem(
        id: 'rest_sleep',
        title: 'Rest when baby sleeps',
        emoji: '😴',
        backgroundColor: const Color(0xFF4CAF50),
        isCompleted: false,
      ),
      TaskItem(
        id: 'water_intake',
        title: 'Drink 8-10 glasses of water',
        emoji: '💧',
        backgroundColor: secondaryColor,
        isCompleted: false,
      ),
    ];

    // Week-specific tasks
    if (week <= 2) {
      weeklyTasks.addAll([
        TaskItem(
          id: 'feeding_tracking',
          title: 'Track feeding sessions',
          emoji: '🍼',
          backgroundColor: const Color(0xFFFF9800),
          isCompleted: false,
        ),
        TaskItem(
          id: 'wound_care',
          title: 'Perineal/C-section care',
          emoji: '🏥',
          backgroundColor: const Color(0xFFF44336),
          isCompleted: false,
        ),
      ]);
    } else if (week <= 6) {
      weeklyTasks.addAll([
        TaskItem(
          id: 'light_exercise',
          title: 'Gentle walking',
          emoji: '🚶‍♀️',
          backgroundColor: primaryColor,
          isCompleted: false,
        ),
        TaskItem(
          id: 'baby_check',
          title: 'Monitor baby\'s health',
          emoji: '👶',
          backgroundColor: const Color(0xFF009688),
          isCompleted: false,
        ),
      ]);
    } else {
      weeklyTasks.addAll([
        TaskItem(
          id: 'postpartum_exercise',
          title: 'Postpartum exercises',
          emoji: '🧘‍♀️',
          backgroundColor: const Color(0xFF00BCD4),
          isCompleted: false,
        ),
        TaskItem(
          id: 'self_care',
          title: 'Self-care routine',
          emoji: '❤️',
          backgroundColor: const Color(0xFFE91E63),
          isCompleted: false,
        ),
      ]);
    }

    return weeklyTasks;
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
        const SizedBox(height: 12),
        _buildTasksList(),
        const SizedBox(height: 12),
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildHeader() {
    final completedCount = _getCompletedCount();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
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
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today\'s Tasks',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Postpartum Week ${widget.currentWeek}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: completedCount == tasks.length
                ? primaryColor.withOpacity(0.1)
                : secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: completedCount == tasks.length
                    ? primaryColor.withOpacity(0.3)
                    : secondaryColor.withOpacity(0.3),
                width: 1),
          ),
          child: Text(
            '$completedCount/${tasks.length}',
            style: TextStyle(
              fontSize: 12,
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
          margin: EdgeInsets.only(bottom: index < tasks.length - 1 ? 8 : 0),
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
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted ? primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
                color: task.isCompleted ? primaryColor : Colors.transparent,
                boxShadow: task.isCompleted
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: task.backgroundColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: task.backgroundColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                task.emoji,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      task.isCompleted ? Colors.grey.shade600 : Colors.black87,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (task.isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.15),
                      secondaryColor.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '✓ Done',
                  style: TextStyle(
                    fontSize: 10,
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
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isComplete ? primaryColor : secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 5,
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
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isComplete
                          ? [primaryColor, primaryColor.withOpacity(0.8)]
                          : [secondaryColor, secondaryColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(2.5),
                    boxShadow: [
                      BoxShadow(
                        color: (isComplete ? primaryColor : secondaryColor)
                            .withOpacity(0.3),
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  secondaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: primaryColor.withOpacity(0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 5),
                Text(
                  'All done! Great job today!',
                  style: TextStyle(
                    fontSize: 11,
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
