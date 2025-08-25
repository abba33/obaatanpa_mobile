import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HospitalPractitionersPage extends StatefulWidget {
  const HospitalPractitionersPage({Key? key}) : super(key: key);

  @override
  State<HospitalPractitionersPage> createState() => _HospitalPractitionersPageState();
}

class _HospitalPractitionersPageState extends State<HospitalPractitionersPage> {
  bool _isMenuOpen = false;
  String _selectedFilter = 'All';

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          Column(
            children: [
              // Custom App Bar - FIXED: Reduced height and optimized layout
              Container(
                height: 100, // FIXED: Reduced from 120 to 100
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // FIXED: Reduced vertical padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // FIXED: Center content vertically
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
                            GestureDetector(
                              onTap: _toggleMenu,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4), // FIXED: Reduced spacing
                        // FIXED: Wrap title in Flexible to prevent overflow
                        Flexible(
                          child: Row(
                            children: [
                              Expanded( // FIXED: Wrap text in Expanded
                                child: Text(
                                  'Practitioners Management',
                                  style: const TextStyle(
                                    fontSize: 20, // FIXED: Reduced font size from 24 to 20
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis, // FIXED: Add overflow protection
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Page Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Stats and Add Button Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard('Total', '18', const Color(0xFFF59297)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard('Active', '15', const Color(0xFF7DA8E6)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard('Pending', '3', Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Filter and Add Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedFilter,
                                  isExpanded: true, // FIXED: Add isExpanded to prevent overflow
                                  items: ['All', 'Active', 'Pending', 'Obstetricians', 'Midwives', 'Pediatricians']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        overflow: TextOverflow.ellipsis, // FIXED: Add overflow protection
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedFilter = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              // Show add practitioner dialog
                              _showAddPractitionerDialog();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.add, color: Colors.white, size: 20),
                                  SizedBox(width: 4),
                                  Text(
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Practitioners List
                      ..._buildPractitionersList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis, // FIXED: Add overflow protection
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPractitionersList() {
    final practitioners = [
      {
        'name': 'Dr. Sarah Johnson',
        'specialty': 'Obstetrician & Gynecologist',
        'email': 'sarah.johnson@hospital.com',
        'phone': '+233 24 123 4567',
        'status': 'active',
        'joinDate': 'Jan 2023',
        'patients': '45',
      },
      {
        'name': 'Dr. Michael Chen',
        'specialty': 'Pediatrician',
        'email': 'michael.chen@hospital.com',
        'phone': '+233 20 987 6543',
        'status': 'pending',
        'joinDate': 'Pending',
        'patients': '0',
      },
      {
        'name': 'Mary Williams',
        'specialty': 'Certified Midwife',
        'email': 'mary.williams@hospital.com',
        'phone': '+233 26 555 7890',
        'status': 'active',
        'joinDate': 'Mar 2023',
        'patients': '32',
      },
      {
        'name': 'Dr. Kwame Asante',
        'specialty': 'Obstetrician',
        'email': 'kwame.asante@hospital.com',
        'phone': '+233 24 444 3333',
        'status': 'active',
        'joinDate': 'Feb 2023',
        'patients': '38',
      },
    ];

    return practitioners.map((practitioner) {
      final isActive = practitioner['status'] == 'active';
      final statusColor = isActive ? Colors.green : Colors.orange;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF59297).withOpacity(0.2),
                        const Color(0xFF7DA8E6).withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    practitioner['specialty']!.contains('Dr.') ? Icons.person : Icons.pregnant_woman,
                    color: const Color(0xFFF59297),
                    size: 24,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis, // FIXED: Add overflow protection
                        maxLines: 1,
                      ),
                      Text(
                        practitioner['specialty']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis, // FIXED: Add overflow protection
                        maxLines: 1,
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
                    isActive ? 'Active' : 'Pending',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(Icons.email, practitioner['email']!),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(Icons.phone, practitioner['phone']!),
                ),
                Expanded(
                  child: _buildInfoItem(Icons.people, '${practitioner['patients']} patients'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // FIXED: Wrap action buttons row in flexible layout
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Joined: ${practitioner['joinDate']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                // FIXED: Wrap action buttons in Flexible
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive) ...[
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // View practitioner details
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // FIXED: Reduced padding
                              decoration: BoxDecoration(
                                color: const Color(0xFF7DA8E6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'View',
                                style: TextStyle(
                                  color: Color(0xFF7DA8E6),
                                  fontSize: 11, // FIXED: Reduced font size
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6), // FIXED: Reduced spacing
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // Edit practitioner
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // FIXED: Reduced padding
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59297).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Color(0xFFF59297),
                                  fontSize: 11, // FIXED: Reduced font size
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // Approve practitioner
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), // FIXED: Reduced padding
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Approve',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10, // FIXED: Reduced font size
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4), // FIXED: Reduced spacing
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // Reject practitioner
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), // FIXED: Reduced padding
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10, // FIXED: Reduced font size
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.black54,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showAddPractitionerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Practitioner'),
          content: const Text('Add practitioner functionality would be implemented here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Implement add practitioner logic
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}