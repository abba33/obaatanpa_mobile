import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        // Grid of Quick Actions
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildQuickActionItem(
              icon: Icons.schedule,
              title: 'View Schedule',
              subtitle: 'Today\'s appointments',
              gradient: [Color(0xFFF59297).withOpacity(0.8), Color(0xFFF59297)],
              onTap: () {
                // Navigate to schedule
              },
            ),
            _buildQuickActionItem(
              icon: Icons.people,
              title: 'Patient List',
              subtitle: '47 active patients',
              gradient: [Color(0xFF7DA8E6).withOpacity(0.8), Color(0xFF7DA8E6)],
              onTap: () {
                // Navigate to patient list
              },
            ),
            _buildQuickActionItem(
              icon: Icons.chat,
              title: 'Messages',
              subtitle: '3 unread',
              gradient: [Color(0xFFF59297).withOpacity(0.6), Color(0xFF7DA8E6).withOpacity(0.8)],
              onTap: () {
                // Navigate to messages
              },
            ),
            _buildQuickActionItem(
              icon: Icons.library_books,
              title: 'Add Resource',
              subtitle: 'Share knowledge',
              gradient: [Color(0xFF7DA8E6).withOpacity(0.6), Color(0xFFF59297).withOpacity(0.8)],
              onTap: () {
                // Navigate to add resource
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}