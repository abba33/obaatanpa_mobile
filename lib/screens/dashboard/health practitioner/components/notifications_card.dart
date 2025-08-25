import 'package:flutter/material.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF7DA8E6).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications,
                color: Color(0xFF7DA8E6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFF59297),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Notification Items
          _buildNotificationItem(
            'New appointment request',
            'Sarah Mensah - Tomorrow 2:00 PM',
            Color(0xFFF59297),
            Icons.schedule,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            'Patient message',
            'Mary Asante sent a message',
            Color(0xFF7DA8E6),
            Icons.chat_bubble,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            'Hospital reminder',
            'Monthly meeting - Friday 9:00 AM',
            Color(0xFFF59297).withOpacity(0.7),
            Icons.business,
          ),
          
          const SizedBox(height: 16),
          
          // View All Button
          GestureDetector(
            onTap: () {
              // Navigate to notifications
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF7DA8E6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF7DA8E6).withOpacity(0.3)),
              ),
              child: Text(
                'View All',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7DA8E6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}