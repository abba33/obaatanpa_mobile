import 'package:flutter/material.dart';

class RecentActivitiesCard extends StatelessWidget {
  const RecentActivitiesCard({Key? key}) : super(key: key);

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
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Color(0xFF7DA8E6),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Activity Timeline
          _buildActivityItem(
            'Completed appointment with Sarah Mensah',
            '2 hours ago',
            Icons.check_circle,
            Color(0xFF4CAF50),
          ),
          _buildDivider(),
          _buildActivityItem(
            'Shared new nutrition guide',
            '5 hours ago',
            Icons.library_books,
            Color(0xFFF59297),
          ),
          _buildDivider(),
          _buildActivityItem(
            'Responded to Mary Asante\'s message',
            '1 day ago',
            Icons.chat_bubble,
            Color(0xFF7DA8E6),
          ),
          _buildDivider(),
          _buildActivityItem(
            'Updated patient notes for Grace Osei',
            '2 days ago',
            Icons.edit,
            Color(0xFFF59297).withOpacity(0.8),
          ),
          _buildDivider(),
          _buildActivityItem(
            'Scheduled follow-up appointment',
            '3 days ago',
            Icons.schedule,
            Color(0xFF7DA8E6).withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
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
                  activity,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
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
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Container(
        width: 2,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}