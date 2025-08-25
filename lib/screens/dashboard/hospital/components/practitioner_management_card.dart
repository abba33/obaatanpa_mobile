import 'package:flutter/material.dart';

class PractitionerManagementCard extends StatelessWidget {
  const PractitionerManagementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59297).withOpacity(0.1),
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
                  Icons.medical_services,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Practitioners',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to add practitioner
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59297).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFFF59297),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total', '18', const Color(0xFFF59297)),
              ),
              Expanded(
                child: _buildStatItem('Pending', '3', const Color(0xFF7DA8E6)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Recent practitioners list
          const Text(
            'Recent Additions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          // Practitioners list
          ..._buildPractitionersList(),
          
          const SizedBox(height: 16),
          
          // View all button
          GestureDetector(
            onTap: () {
              // Navigate to full practitioners list
            },
            child: Container(
              width: double.infinity,
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
                'View All Practitioners',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF59297),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPractitionersList() {
    final practitioners = [
      {'name': 'Dr. Sarah Johnson', 'specialty': 'Obstetrician', 'status': 'active'},
      {'name': 'Dr. Michael Chen', 'specialty': 'Pediatrician', 'status': 'pending'},
      {'name': 'Mary Williams', 'specialty': 'Midwife', 'status': 'active'},
    ];

    return practitioners.map((practitioner) {
      final isActive = practitioner['status'] == 'active';
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    practitioner['name']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    practitioner['specialty']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Active' : 'Pending',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.green : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}