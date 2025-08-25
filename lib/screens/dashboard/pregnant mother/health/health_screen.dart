import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int selectedTabIndex = 0;
  final List<String> healthTabs = [
    'Overview',
    'Symptoms',
    'Checkups',
    'Records',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/dashboard/pregnant-mother'),
        ),
        title: const Text(
          'Health Tracker',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {
              // Add new health record
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Health Status Overview Card
          _buildHealthOverviewCard(),
          
          // Tab Navigation
          _buildTabNavigation(),
          
          // Tab Content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthOverviewCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF8BBD9).withOpacity(0.3),
            const Color(0xFFF8BBD9).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Week 28',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '2nd Trimester • 12 weeks to go',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildHealthIndicator('Weight', '+12 kg', Colors.green, Icons.trending_up),
                        const SizedBox(width: 20),
                        _buildHealthIndicator('BP', '120/80', Colors.blue, Icons.favorite),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pregnant_woman,
                  size: 40,
                  color: Color(0xFFF8BBD9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Next Checkup',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Sept 25, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthIndicator(String label, String value, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: healthTabs.length,
        itemBuilder: (context, index) {
          final tab = healthTabs[index];
          final isSelected = index == selectedTabIndex;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTabIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                right: index < healthTabs.length - 1 ? 16 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF8BBD9) : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? const Color(0xFFF8BBD9) : Colors.grey.shade300,
                ),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildSymptomsTab();
      case 2:
        return _buildCheckupsTab();
      case 3:
        return _buildRecordsTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Metrics Cards
          _buildHealthMetricsSection(),
          
          const SizedBox(height: 24),
          
          // Today's Health Tasks
          _buildHealthTasksSection(),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          _buildRecentActivitySection(),
          
          const SizedBox(height: 24),
          
          // Health Insights
          _buildHealthInsightsSection(),
        ],
      ),
    );
  }

  Widget _buildHealthMetricsSection() {
    final metrics = [
      {
        'title': 'Weight Gain',
        'value': '+12 kg',
        'target': 'Target: 11-16 kg',
        'color': const Color(0xFF81C784),
        'icon': Icons.monitor_weight,
        'progress': 0.75,
      },
      {
        'title': 'Blood Pressure',
        'value': '120/80',
        'target': 'Normal range',
        'color': const Color(0xFF64B5F6),
        'icon': Icons.favorite,
        'progress': 1.0,
      },
      {
        'title': 'Baby Kicks',
        'value': '28 today',
        'target': 'Goal: 10+ per day',
        'color': const Color(0xFFF8BBD9),
        'icon': Icons.child_care,
        'progress': 1.0,
      },
      {
        'title': 'Sleep Quality',
        'value': '6.5 hours',
        'target': 'Goal: 7-9 hours',
        'color': const Color(0xFFFFB74D),
        'icon': Icons.bedtime,
        'progress': 0.72,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health Metrics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (metric['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          metric['icon'] as IconData,
                          color: metric['color'] as Color,
                          size: 20,
                        ),
                      ),
                      CircularProgressIndicator(
                        value: metric['progress'] as double,
                        backgroundColor: (metric['color'] as Color).withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(metric['color'] as Color),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    metric['title'].toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    metric['value'].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    metric['target'].toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHealthTasksSection() {
    final tasks = [
      {
        'task': 'Take prenatal vitamin',
        'time': '9:00 AM',
        'completed': true,
        'icon': Icons.medication,
      },
      {
        'task': 'Record baby kicks',
        'time': '2:00 PM',
        'completed': false,
        'icon': Icons.child_care,
      },
      {
        'task': 'Evening walk',
        'time': '6:00 PM',
        'completed': false,
        'icon': Icons.directions_walk,
      },
      {
        'task': 'Blood pressure check',
        'time': '8:00 PM',
        'completed': false,
        'icon': Icons.favorite,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Health Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: tasks.map((task) {
            final completed = task['completed'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: completed ? const Color(0xFFF8BBD9) : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFFF8BBD9),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: completed
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8BBD9).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      task['icon'] as IconData,
                      color: const Color(0xFFF8BBD9),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['task'].toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: completed ? TextDecoration.lineThrough : null,
                            color: completed ? Colors.grey : Colors.black,
                          ),
                        ),
                        Text(
                          task['time'].toString(),
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
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    final activities = [
      {
        'title': 'Weight Recorded',
        'subtitle': '65.5 kg (+0.5 kg this week)',
        'time': '2 hours ago',
        'icon': Icons.monitor_weight,
        'color': const Color(0xFF81C784),
      },
      {
        'title': 'Baby Kicks Logged',
        'subtitle': '15 kicks between 2-3 PM',
        'time': '5 hours ago',
        'icon': Icons.child_care,
        'color': const Color(0xFFF8BBD9),
      },
      {
        'title': 'Blood Pressure Check',
        'subtitle': '118/75 mmHg - Normal',
        'time': 'Yesterday',
        'icon': Icons.favorite,
        'color': const Color(0xFF64B5F6),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: activities.map((activity) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (activity['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      color: activity['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity['subtitle'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    activity['time'].toString(),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHealthInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF64B5F6).withOpacity(0.1),
                const Color(0xFF64B5F6).withOpacity(0.05),
              ],
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lightbulb,
                      color: Color(0xFF64B5F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Weekly Insight',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Your weight gain is on track! You\'ve gained 12kg, which is within the healthy range for your stage of pregnancy. Keep up the balanced nutrition and regular movement.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsTab() {
    final symptoms = [
      {
        'name': 'Morning Sickness',
        'severity': 'Mild',
        'lastOccurred': 'Yesterday',
        'color': const Color(0xFF81C784),
      },
      {
        'name': 'Back Pain',
        'severity': 'Moderate',
        'lastOccurred': 'Today',
        'color': const Color(0xFFFFB74D),
      },
      {
        'name': 'Heartburn',
        'severity': 'Mild',
        'lastOccurred': '2 days ago',
        'color': const Color(0xFF81C784),
      },
      {
        'name': 'Swollen Feet',
        'severity': 'Moderate',
        'lastOccurred': 'Today',
        'color': const Color(0xFFFFB74D),
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Symptom Tracker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: symptoms.map((symptom) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 40,
                      decoration: BoxDecoration(
                        color: symptom['color'] as Color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            symptom['name'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Severity: ${symptom['severity']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Last occurred: ${symptom['lastOccurred']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckupsTab() {
    final checkups = [
      {
        'date': 'Sept 25, 2024',
        'type': 'Routine Checkup',
        'doctor': 'Dr. Sarah Johnson',
        'status': 'Upcoming',
        'color': const Color(0xFF64B5F6),
      },
      {
        'date': 'Sept 11, 2024',
        'type': 'Ultrasound Scan',
        'doctor': 'Dr. Michael Chen',
        'status': 'Completed',
        'color': const Color(0xFF81C784),
      },
      {
        'date': 'Aug 28, 2024',
        'type': 'Blood Test',
        'doctor': 'Dr. Sarah Johnson',
        'status': 'Completed',
        'color': const Color(0xFF81C784),
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical Checkups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: checkups.map((checkup) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          checkup['type'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (checkup['color'] as Color).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            checkup['status'].toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: checkup['color'] as Color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      checkup['date'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      checkup['doctor'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsTab() {
    final records = [
      {
        'title': 'Blood Test Results',
        'date': 'Sept 11, 2024',
        'type': 'Lab Report',
        'icon': Icons.science,
      },
      {
        'title': 'Ultrasound Images',
        'date': 'Sept 11, 2024',
        'type': 'Imaging',
        'icon': Icons.image,
      },
      {
        'title': 'Prescription',
        'date': 'Aug 28, 2024',
        'type': 'Medication',
        'icon': Icons.medication,
      },
      {
        'title': 'Weight Chart',
        'date': 'Ongoing',
        'type': 'Tracking',
        'icon': Icons.show_chart,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Records',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: records.map((record) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8BBD9).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        record['icon'] as IconData,
                        color: const Color(0xFFF8BBD9),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record['title'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record['type'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            record['date'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}