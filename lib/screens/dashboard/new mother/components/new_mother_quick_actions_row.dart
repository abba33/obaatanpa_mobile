import 'package:flutter/material.dart';

class NewMotherQuickActionsRow extends StatelessWidget {
  const NewMotherQuickActionsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickAction(
          icon: Icons.access_time,
          label: 'Feeding Log',
          color: const Color(0xFFF8BBD9),
          onTap: () {
            // Navigate to feeding log
          },
        ),
        _buildQuickAction(
          icon: Icons.baby_changing_station,
          label: 'Diaper Log',
          color: const Color(0xFF98D8C8),
          onTap: () {
            // Navigate to diaper log
          },
        ),
        _buildQuickAction(
          icon: Icons.bedtime,
          label: 'Sleep Log',
          color: const Color(0xFFFFC947),
          onTap: () {
            // Navigate to sleep log
          },
        ),
        _buildQuickAction(
          icon: Icons.medical_services,
          label: 'Health Check',
          color: const Color(0xFF7DA8E6),
          onTap: () {
            // Navigate to health check
          },
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}