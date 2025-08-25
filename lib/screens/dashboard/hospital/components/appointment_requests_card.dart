import 'package:flutter/material.dart';

class AppointmentRequestsCard extends StatelessWidget {
  const AppointmentRequestsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7DA8E6).withOpacity(0.1),
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
                    colors: [Color(0xFF7DA8E6), Color(0xFFF59297)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Appointments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '7 Pending',
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
          
          // Quick stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Today', '12', const Color(0xFF7DA8E6)),
              ),
              Expanded(
                child: _buildStatItem('Pending', '7', const Color(0xFFF59297)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Recent appointment requests
          const Text(
            'Recent Requests',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          // Appointment requests list
          ..._buildAppointmentsList(),
          
          const SizedBox(height: 16),
          
          // View all button
          GestureDetector(
            onTap: () {
              // Navigate to full appointments list
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7DA8E6).withOpacity(0.1),
                    const Color(0xFFF59297).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF7DA8E6).withOpacity(0.3),
                ),
              ),
              child: const Text(
                'Manage All Appointments',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7DA8E6),
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

  List<Widget> _buildAppointmentsList() {
    final appointments = [
      {
        'patient': 'Jennifer Adams',
        'time': '10:30 AM',
        'type': 'Antenatal Check',
        'status': 'pending',
        'urgent': false,
      },
      {
        'patient': 'Maria Santos',
        'time': '2:00 PM',
        'type': 'Ultrasound',
        'status': 'confirmed',
        'urgent': false,
      },
      {
        'patient': 'Grace Asante',
        'time': '4:15 PM',
        'type': 'Emergency',
        'status': 'pending',
        'urgent': true,
      },
    ];

    return appointments.map((appointment) {
      final isPending = appointment['status'] as String == 'pending';
      final isUrgent = appointment['urgent'] as bool;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUrgent 
                ? Colors.red.withOpacity(0.05)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isUrgent 
                  ? Colors.red.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isUrgent 
                      ? Colors.red 
                      : (isPending ? Colors.orange : Colors.green),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // FIXED: Wrap the expanded content to prevent overflow
              Expanded(
                flex: 3, // Give more space to the content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['patient'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis, // FIXED: Add ellipsis
                      maxLines: 1, // FIXED: Limit to 1 line
                    ),
                    const SizedBox(height: 2),
                    // FIXED: Use Flexible for the time and type row
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            appointment['time'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '• ${appointment['type'] as String}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isUrgent ? Colors.red : Colors.black54,
                              fontWeight: isUrgent ? FontWeight.w600 : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis, // FIXED: Add ellipsis
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // FIXED: Wrap action buttons in Flexible to prevent overflow
              if (isPending) 
                Flexible(
                  flex: 1, // Limit space for action buttons
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // FIXED: Use minimum space
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            // Approve appointment
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            // Decline appointment
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 14,
                            ),
                          ),
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