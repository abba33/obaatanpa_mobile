import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HospitalAppointmentsPage extends StatefulWidget {
  const HospitalAppointmentsPage({Key? key}) : super(key: key);

  @override
  State<HospitalAppointmentsPage> createState() => _HospitalAppointmentsPageState();
}

class _HospitalAppointmentsPageState extends State<HospitalAppointmentsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Custom App Bar - FIXED: Better height management
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF59297),
                  Color(0xFF7DA8E6),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/hospital/dashboard'),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '7 Pending',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Appointments',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFF59297),
              labelColor: const Color(0xFFF59297),
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Today'),
                Tab(text: 'Upcoming'),
                Tab(text: 'History'),
              ],
            ),
          ),

          // Tab Views - FIXED: Proper expansion
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingAppointments(),
                _buildTodayAppointments(),
                _buildUpcomingAppointments(),
                _buildAppointmentHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingAppointments() {
    final pendingAppointments = [
      {
        'patient': 'Jennifer Adams',
        'type': 'Antenatal Checkup',
        'requestedTime': '10:30 AM',
        'requestedDate': 'Today',
        'practitioner': 'Dr. Sarah Johnson',
        'priority': 'normal',
      },
      {
        'patient': 'Grace Asante',
        'type': 'Emergency Consultation',
        'requestedTime': '2:00 PM',
        'requestedDate': 'Today',
        'practitioner': 'Dr. Kwame Asante',
        'priority': 'urgent',
      },
      {
        'patient': 'Maria Santos',
        'type': 'Ultrasound',
        'requestedTime': '9:00 AM',
        'requestedDate': 'Tomorrow',
        'practitioner': 'Dr. Sarah Johnson',
        'priority': 'normal',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: pendingAppointments.map((appointment) {
        final isUrgent = appointment['priority'] == 'urgent';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUrgent ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
              width: isUrgent ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment['patient'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment['type'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: isUrgent ? Colors.red : Colors.black54,
                            fontWeight: isUrgent ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUrgent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'URGENT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text(
                    '${appointment['requestedDate']} at ${appointment['requestedTime']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text(
                    appointment['practitioner'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showApproveDialog(appointment['patient'] as String);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Approve',
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showRescheduleDialog(appointment['patient'] as String);
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
                          border: Border.all(color: const Color(0xFFF59297)),
                        ),
                        child: const Text(
                          'Reschedule',
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
                  GestureDetector(
                    onTap: () {
                      _showDeclineDialog(appointment['patient'] as String);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodayAppointments() {
    final todayAppointments = [
      {
        'patient': 'Akosua Mensah',
        'type': 'Routine Checkup',
        'time': '9:00 AM',
        'practitioner': 'Dr. Sarah Johnson',
        'status': 'confirmed',
      },
      {
        'patient': 'Emma Thompson',
        'type': 'Vaccination',
        'time': '11:30 AM',
        'practitioner': 'Mary Williams',
        'status': 'confirmed',
      },
      {
        'patient': 'Sarah Wilson',
        'type': 'Postpartum Care',
        'time': '3:00 PM',
        'practitioner': 'Dr. Kwame Asante',
        'status': 'in-progress',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Today's summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF59297).withOpacity(0.1),
                const Color(0xFF7DA8E6).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
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
                  Icons.today,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Today\'s Schedule',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Text(
                '12 appointments',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Appointments list
        ...todayAppointments.map((appointment) {
          Color statusColor;
          String statusText;
          
          switch (appointment['status']) {
            case 'confirmed':
              statusColor = Colors.green;
              statusText = 'Confirmed';
              break;
            case 'in-progress':
              statusColor = const Color(0xFF7DA8E6);
              statusText = 'In Progress';
              break;
            default:
              statusColor = Colors.orange;
              statusText = 'Pending';
          }
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['time'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF59297),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['patient'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${appointment['type']} • ${appointment['practitioner']}',
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildUpcomingAppointments() {
    final upcomingAppointments = [
      {
        'patient': 'Fatima Al-Rashid',
        'type': 'Prenatal Consultation',
        'date': 'Tomorrow',
        'time': '10:00 AM',
        'practitioner': 'Dr. Sarah Johnson',
      },
      {
        'patient': 'Ama Konadu',
        'type': 'Ultrasound Scan',
        'date': 'Monday',
        'time': '2:30 PM',
        'practitioner': 'Dr. Kwame Asante',
      },
      {
        'patient': 'Linda Osei',
        'type': 'Follow-up',
        'date': 'Tuesday',
        'time': '11:00 AM',
        'practitioner': 'Mary Williams',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Upcoming summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7DA8E6).withOpacity(0.1),
                const Color(0xFFF59297).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
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
                  Icons.schedule,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Text(
                'Next 7 days',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        ...upcomingAppointments.map((appointment) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7DA8E6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appointment['date']} at ${appointment['time']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7DA8E6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['patient'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${appointment['type']} • ${appointment['practitioner']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showAppointmentDetails(appointment);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7DA8E6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF7DA8E6),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAppointmentHistory() {
    final historyAppointments = [
      {
        'patient': 'Rebecca Owusu',
        'type': 'Delivery',
        'date': 'Yesterday',
        'time': '6:30 AM',
        'practitioner': 'Dr. Sarah Johnson',
        'outcome': 'Successful',
      },
      {
        'patient': 'Adwoa Badu',
        'type': 'Postpartum Check',
        'date': '2 days ago',
        'time': '3:00 PM',
        'practitioner': 'Mary Williams',
        'outcome': 'Completed',
      },
      {
        'patient': 'Joyce Ampong',
        'type': 'Antenatal Care',
        'date': '3 days ago',
        'time': '10:15 AM',
        'practitioner': 'Dr. Kwame Asante',
        'outcome': 'Completed',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // History summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.withOpacity(0.1),
                Colors.grey.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Appointment History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Text(
                'Last 30 days',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        ...historyAppointments.map((appointment) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appointment['date']} at ${appointment['time']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['patient'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${appointment['type']} • ${appointment['practitioner']}',
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment['outcome'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showApproveDialog(String patientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Approve Appointment'),
          content: Text('Approve appointment for $patientName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Appointment approved for $patientName')),
                );
              },
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _showRescheduleDialog(String patientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reschedule Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reschedule appointment for $patientName'),
              const SizedBox(height: 16),
              // You can add date/time picker here
              const Text('Select new date and time:'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Appointment rescheduled for $patientName')),
                );
              },
              child: const Text('Reschedule'),
            ),
          ],
        );
      },
    );
  }

  void _showDeclineDialog(String patientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Decline Appointment'),
          content: Text('Are you sure you want to decline the appointment for $patientName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Appointment declined for $patientName'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text(
                'Decline',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Patient: ${appointment['patient']}'),
              SizedBox(height: 8),
              Text('Type: ${appointment['type']}'),
              SizedBox(height: 8),
              Text('Date: ${appointment['date']}'),
              SizedBox(height: 8),
              Text('Time: ${appointment['time']}'),
              SizedBox(height: 8),
              Text('Practitioner: ${appointment['practitioner']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}