import 'package:flutter/material.dart';

class NotificationCenterCard extends StatelessWidget {
  const NotificationCenterCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Notification Center',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '3 New',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Recent notifications
          ..._buildNotificationsList(),
          
          const SizedBox(height: 16),
          
          // Send notification button
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to send notification
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF59297).withOpacity(0.1),
                          const Color(0xFF7DA8E6).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFF59297).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Send Notification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF59297),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to all notifications
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationsList() {
    final notifications = [
      {
        'title': 'New Appointment Request',
        'message': 'Jennifer Adams requested an appointment for tomorrow at 10:30 AM',
        'time': '2 min ago',
        'type': 'appointment',
        'isNew': true,
      },
      {
        'title': 'Practitioner Invitation Sent',
        'message': 'Invitation sent to Dr. Michael Chen to join the hospital',
        'time': '1 hour ago',
        'type': 'practitioner',
        'isNew': true,
      },
      {
        'title': 'Resource Upload Complete',
        'message': 'Your nutrition guide has been successfully uploaded',
        'time': '3 hours ago',
        'type': 'resource',
        'isNew': false,
      },
    ];

    return notifications.map((notification) {
      Color typeColor;
      IconData typeIcon;
      
      switch (notification['type'] as String) {
        case 'appointment':
          typeColor = const Color(0xFF7DA8E6);
          typeIcon = Icons.calendar_today;
          break;
        case 'practitioner':
          typeColor = const Color(0xFFF59297);
          typeIcon = Icons.person_add;
          break;
        case 'resource':
          typeColor = Colors.green;
          typeIcon = Icons.upload_file;
          break;
        default:
          typeColor = Colors.grey;
          typeIcon = Icons.info;
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (notification['isNew'] as bool)
                ? typeColor.withOpacity(0.05)
                : Colors.grey.withOpacity(0.02),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (notification['isNew'] as bool)
                  ? typeColor.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  typeIcon,
                  color: typeColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (notification['isNew'] as bool)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['time'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: typeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}