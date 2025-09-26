import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Appointment {
  final String id;
  final String type;
  final String date;
  final String time;
  final String hospital;
  final String practitioner;
  final String status;
  final String mode;
  final String? reason;
  final String? notes;
  final int? rating;
  final String? feedback;

  Appointment({
    required this.id,
    required this.type,
    required this.date,
    required this.time,
    required this.hospital,
    required this.practitioner,
    required this.status,
    required this.mode,
    this.reason,
    this.notes,
    this.rating,
    this.feedback,
  });
}

class AppointmentsScreen extends StatefulWidget {
  final int pregnancyWeek;
  final String trimester;
  final String motherName;

  const AppointmentsScreen({
    super.key,
    this.pregnancyWeek = 12,
    this.trimester = 'First',
    this.motherName = 'Mama',
  });

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool isMenuOpen = false;
  String selectedCategory = 'All Services';
  String activeTab = 'discover'; // discover, upcoming, calendar, history
  List<Appointment> appointments = [];
  String? errorMessage;
  String? authToken;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Appointment? selectedAppointment;
  bool showRescheduleDialog = false;

  final String apiUrl = 'https://obaatanpa-backend.onrender.com';

  // Hospital data with categories
  final List<Map<String, dynamic>> hospitals = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=2053&q=80',
      'hospitalName': 'Ridge Hospital',
      'location': 'Castle Road, Ridge • 1.8 km',
      'rating': 4.7,
      'reviews': 189,
      'phoneNumber': '+233 30 987 6543',
      'category': 'Prenatal Care',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1516841273335-e39b37888115?auto=format&fit=crop&w=2071&q=80',
      'hospitalName': 'Korle-Bu Hospital',
      'location': 'Guggisberg Ave • 1.5 km',
      'rating': 4.8,
      'reviews': 245,
      'phoneNumber': '+233 30 202 0820',
      'category': 'Newborn Care',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1551190822-a9333d879b1f?auto=format&fit=crop&w=2070&q=80',
      'hospitalName': 'AME zion',
      'location': 'Dzorwulu • 1.8 km',
      'rating': 4.6,
      'reviews': 156,
      'phoneNumber': '+233 30 278 5555',
      'category': 'Vaccination',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    final token = await _storage.read(key: 'auth_token');
    setState(() {
      authToken = token;
      debugPrint('Auth Token: $authToken');
    });
    if (activeTab == 'upcoming' || activeTab == 'history') {
      await _fetchAppointments();
    }
  }

  Future<void> _fetchAppointments() async {
    if (authToken == null) {
      setState(() {
        errorMessage = 'Please log in to fetch appointments.';
      });
      debugPrint('Error: No auth token available');
      return;
    }

    try {
      final endpoint = '$apiUrl/appointment/get';
      debugPrint('Request Endpoint: $endpoint');
      debugPrint('Request Headers: {"Authorization": "Bearer $authToken"}');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> appointmentData = data['appointments'];
        setState(() {
          appointments = appointmentData
              .where((apt) => apt['status'] == 'pending' || apt['status'] == 'completed' || apt['status'] == 'assigned')
              .map((apt) {
                debugPrint('Processing appointment: $apt');
                return Appointment(
                  id: apt['appointment_id'].toString(),
                  type: (apt['reason'] is String && apt['reason'].isNotEmpty)
                      ? apt['reason'][0].toUpperCase() + apt['reason'].substring(1)
                      : 'Antenatal Visit',
                  date: apt['date'],
                  time: apt['time'].substring(0, 5),
                  hospital: apt['hospital_name'],
                  practitioner: apt['doctor_name'] ?? 'To be assigned',
                  status: apt['status'].toString(),
                  mode: 'in-person',
                  reason: apt['reason'] is String ? apt['reason'] : null,
                );
              })
              .toList();
          errorMessage = null;
          debugPrint('Appointments fetched: ${appointments.length}');
        });
      } else {
        setState(() {
          errorMessage = response.statusCode == 404
              ? 'Appointment service not found. Please check if the server is running.'
              : 'Failed to fetch appointments. Please try again later.';
        });
        debugPrint('Error Response: ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch appointments: $e';
      });
      debugPrint('Exception: $e');
    }
  }

  Future<void> _cancelAppointment(String id) async {
    if (authToken == null) {
      setState(() {
        errorMessage = 'Please log in to cancel an appointment.';
      });
      debugPrint('Error: No auth token available');
      return;
    }

    try {
      final endpoint = '$apiUrl/appointment/delete/$id';
      debugPrint('Cancel Appointment Endpoint: $endpoint');
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      debugPrint('Cancel Response Status Code: ${response.statusCode}');
      debugPrint('Cancel Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          appointments = appointments.where((apt) => apt.id != id).toList();
          errorMessage = null;
        });
        debugPrint('Appointment $id cancelled successfully');
      } else {
        setState(() {
          errorMessage = response.statusCode == 401
              ? 'Your session has expired. Please log in again.'
              : response.statusCode == 404
                  ? 'Appointment not found. It may have already been deleted.'
                  : 'Failed to cancel appointment: ${jsonDecode(response.body)['message'] ?? 'Please try again later.'}';
        });
        debugPrint('Cancel Error Response: ${response.body}');
        if (response.statusCode == 401) {
          await _storage.delete(key: 'auth_token');
          setState(() {
            authToken = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to cancel appointment: $e';
      });
      debugPrint('Cancel Exception: $e');
    }
  }

  Future<void> _rescheduleAppointment(Appointment appointment, Map<String, dynamic> formData) async {
    if (authToken == null) {
      setState(() {
        errorMessage = 'Please log in to reschedule an appointment.';
      });
      debugPrint('Error: No auth token available');
      return;
    }

    try {
      final endpoint = '$apiUrl/appointment/update/${appointment.id}';
      debugPrint('Reschedule Appointment Endpoint: $endpoint');
      debugPrint('Reschedule Request Body: ${jsonEncode(formData)}');
      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      debugPrint('Reschedule Response Status Code: ${response.statusCode}');
      debugPrint('Reschedule Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          appointments = appointments.map((apt) {
            if (apt.id == appointment.id) {
              return Appointment(
                id: apt.id,
                type: formData['reason'][0].toUpperCase() + formData['reason'].substring(1),
                date: formData['date'],
                time: formData['time'].substring(0, 5),
                hospital: formData['hospital_name'],
                practitioner: apt.practitioner,
                status: responseData['status'] ?? apt.status,
                mode: apt.mode,
                reason: formData['reason'],
                notes: apt.notes,
                rating: apt.rating,
                feedback: apt.feedback,
              );
            }
            return apt;
          }).toList();
          errorMessage = null;
          showRescheduleDialog = false;
          selectedAppointment = null;
        });
        debugPrint('Appointment ${appointment.id} rescheduled successfully');
      } else {
        setState(() {
          errorMessage = response.statusCode == 401
              ? 'Your session has expired. Please log in again.'
              : response.statusCode == 404
                  ? 'Appointment not found. Please try again.'
                  : 'Failed to reschedule appointment: ${jsonDecode(response.body)['message'] ?? 'Please try again later.'}';
        });
        debugPrint('Reschedule Error Response: ${response.body}');
        if (response.statusCode == 401) {
          await _storage.delete(key: 'auth_token');
          setState(() {
            authToken = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to reschedule appointment: $e';
      });
      debugPrint('Reschedule Exception: $e');
    }
  }

  Future<void> _makePhoneCall(String hospitalName) async {
    String phoneNumber = _getHospitalPhoneNumber(hospitalName);
    final phoneUrl = Uri.parse('tel:$phoneNumber');

    try {
      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not make phone call')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make phone call')),
      );
    }
  }

  String _getHospitalPhoneNumber(String hospitalName) {
    final hospital = hospitals.firstWhere(
      (h) => h['hospitalName'].toLowerCase() == hospitalName.toLowerCase(),
      orElse: () => {'phoneNumber': '+233 30 123 4567'},
    );
    return hospital['phoneNumber'];
  }

  List<Map<String, dynamic>> _getSmartSuggestions() {
    if (widget.pregnancyWeek <= 12) {
      return [
        {
          'title': 'First trimester scan recommended',
          'action': 'Book Ultrasound',
          'icon': '🩻',
          'urgent': true,
          'description': 'Confirm pregnancy and check development',
        },
        {
          'title': 'Initial antenatal visit due',
          'action': 'Book Antenatal',
          'icon': '🩺',
          'urgent': true,
          'description': 'Start your pregnancy care journey',
        },
      ];
    } else if (widget.pregnancyWeek <= 20) {
      return [
        {
          'title': 'Anatomy scan due (18-22 weeks)',
          'action': 'Book Ultrasound',
          'icon': '👶',
          'urgent': true,
          'description': 'Detailed scan to check baby\'s development',
        },
        {
          'title': 'Monthly antenatal checkup',
          'action': 'Book Antenatal',
          'icon': '📋',
          'urgent': false,
          'description': 'Regular monitoring of your pregnancy',
        },
      ];
    } else if (widget.pregnancyWeek <= 28) {
      return [
        {
          'title': 'Glucose screening test',
          'action': 'Book Blood Test',
          'icon': '🩸',
          'urgent': true,
          'description': 'Screen for gestational diabetes',
        },
        {
          'title': 'Growth scan recommended',
          'action': 'Book Ultrasound',
          'icon': '📏',
          'urgent': false,
          'description': 'Check baby\'s growth and position',
        },
      ];
    } else {
      return [
        {
          'title': 'Weekly antenatal visits',
          'action': 'Book Antenatal',
          'icon': '📅',
          'urgent': true,
          'description': 'Close monitoring as you approach delivery',
        },
        {
          'title': 'Birth preparation class',
          'action': 'Book Class',
          'icon': '🎓',
          'urgent': false,
          'description': 'Prepare for labor and delivery',
        },
      ];
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'assigned':
        return const Color(0xFF059669);
      case 'pending':
        return const Color(0xFFD97706);
      case 'cancelled':
        return const Color(0xFFDC2626);
      case 'completed':
        return const Color(0xFF2563EB);
      case 'missed':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Icon _getStatusIcon(String status) {
    switch (status) {
      case 'assigned':
        return const Icon(Icons.check_circle_outline, size: 16);
      case 'pending':
        return const Icon(Icons.access_time, size: 16);
      case 'cancelled':
        return const Icon(Icons.close, size: 16);
      case 'completed':
        return const Icon(Icons.check_circle, size: 16);
      case 'missed':
        return const Icon(Icons.error_outline, size: 16);
      default:
        return const Icon(Icons.error_outline, size: 16);
    }
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _closeMenu() {
    if (isMenuOpen) {
      setState(() {
        isMenuOpen = false;
      });
    }
  }

  void _navigateToPage(String routeName) {
    _closeMenu();
    if (routeName != '/appointments') {
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    final upcomingAppointments = appointments
        .where((apt) => apt.status == 'assigned' || apt.status == 'pending')
        .toList()
      ..sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    
    final pastAppointments = appointments
        .where((apt) => apt.status == 'completed' || apt.status == 'cancelled' || apt.status == 'missed')
        .toList()
      ..sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    
    final nextAppointment = upcomingAppointments.isNotEmpty ? upcomingAppointments[0] : null;
    final smartSuggestions = _getSmartSuggestions();

    // Filter hospitals by category
    List<Map<String, dynamic>> filteredHospitals = selectedCategory == 'All Services'
        ? hospitals
        : hospitals.where((h) => h['category'] == selectedCategory).toList();

    debugPrint('Building UI with ${upcomingAppointments.length} upcoming and ${pastAppointments.length} past appointments');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _closeMenu,
            child: Column(
              children: [
                CustomAppBar(
                  isMenuOpen: isMenuOpen,
                  onMenuTap: _toggleMenu,
                  title: 'My Pregnancy Appointments',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE4E6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF8BBD9)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Color(0xFFF59297), size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      errorMessage!,
                                      style: const TextStyle(color: Color(0xFFF59297)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 20),
                        
                        // Quick Stats Card
                        if (nextAppointment != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Next Visit',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              DateTime.parse(nextAppointment.date).toString().split(' ')[0],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hospital',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              nextAppointment.hospital,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pregnancy Status',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${widget.trimester} Trimester (Week ${widget.pregnancyWeek})',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 28),

                        // Main Navigation Tabs
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Tab Headers
                              Row(
                                children: [
                                  Expanded(child: _buildTabButton('discover', 'Discover', Icons.search)),
                                  Expanded(child: _buildTabButton('upcoming', 'Upcoming', Icons.schedule, badge: upcomingAppointments.length)),
                                  Expanded(child: _buildTabButton('calendar', 'Calendar', Icons.calendar_today)),
                                  Expanded(child: _buildTabButton('history', 'History', Icons.history, badge: pastAppointments.length)),
                                ],
                              ),
                              
                              // Tab Content
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Stack(
                                  children: [
                                    if (activeTab == 'discover')
                                      _buildDiscoverContent(filteredHospitals, smartSuggestions)
                                    else if (activeTab == 'upcoming')
                                      _buildUpcomingAppointments(upcomingAppointments)
                                    else if (activeTab == 'calendar')
                                      _buildCalendarView(upcomingAppointments)
                                    else if (activeTab == 'history')
                                      _buildHistoryAppointments(pastAppointments),
                                    
                                    if (showRescheduleDialog && selectedAppointment != null)
                                      RescheduleDialog(
                                        appointment: selectedAppointment!,
                                        onSubmit: (formData) {
                                          _rescheduleAppointment(selectedAppointment!, formData);
                                        },
                                        onClose: () {
                                          setState(() {
                                            showRescheduleDialog = false;
                                            selectedAppointment = null;
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMenuOpen) _buildNavigationMenu(),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabKey, String title, IconData icon, {int? badge}) {
    final isActive = activeTab == tabKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = tabKey;
        });
        if (tabKey == 'upcoming' || tabKey == 'history') {
          _fetchAppointments();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFFF59297) : Colors.grey[200]!,
              width: isActive ? 2 : 1,
            ),
          ),
          color: isActive ? const Color(0xFFF59297).withOpacity(0.05) : Colors.transparent,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  color: isActive ? const Color(0xFFF59297) : Colors.grey[600],
                  size: 20,
                ),
                if (badge != null && badge > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFFF59297) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverContent(List<Map<String, dynamic>> filteredHospitals, List<Map<String, dynamic>> smartSuggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search hospitals, doctors, or services",
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[400],
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Smart Suggestions
        const Text(
          'Recommended for You',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        ...smartSuggestions.map((suggestion) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: suggestion['urgent']
                    ? const Color(0xFFF59297)
                    : Colors.grey[300]!,
                width: suggestion['urgent'] ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: suggestion['urgent']
                  ? const Color(0xFFF59297).withOpacity(0.05)
                  : Colors.grey[50],
            ),
            child: Row(
              children: [
                Text(
                  suggestion['icon'],
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        suggestion['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('hospital-booking');
                        },
                        child: Text(
                          suggestion['action'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFF59297),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (suggestion['urgent'])
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59297),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        )),

        const SizedBox(height: 24),

        // Categories
        const Text(
          'Medical Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip('All Services'),
              const SizedBox(width: 12),
              _buildCategoryChip('Prenatal Care'),
              const SizedBox(width: 12),
              _buildCategoryChip('Newborn Care'),
              const SizedBox(width: 12),
              _buildCategoryChip('Vaccination'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Featured Hospitals
        const Text(
          'Featured Hospitals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filteredHospitals.map((hospital) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildHospitalCard(
                  context,
                  hospital['imageUrl'],
                  hospital['hospitalName'],
                  hospital['location'],
                  hospital['rating'],
                  hospital['reviews'],
                  hospitalData: {
                    'hospitalName': hospital['hospitalName'],
                    'hospitalAddress': hospital['location'],
                    'hospitalImage': hospital['imageUrl'],
                    'phoneNumber': hospital['phoneNumber'],
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        // Quick Book Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              context.pushNamed('hospital-booking');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59297),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              shadowColor: const Color(0xFFF59297).withOpacity(0.3),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Book New Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationMenu() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 120,
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8BBD9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Obaatanpa',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Your Pregnancy Dashboard',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _toggleMenu,
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavigationMenuItem(
                        title: 'Dashboard',
                        textColor: Colors.black87,
                        onTap: () => _navigateToPage('/dashboard/pregnant-mother'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Resources',
                        textColor: Colors.black87,
                        onTap: () => _navigateToPage('/resources'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Appointments',
                        isActive: true,
                        textColor: const Color(0xFFF8BBD9),
                        onTap: () => _navigateToPage('/appointments'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Nutrition',
                        textColor: Colors.black87,
                        onTap: () => _navigateToPage('/nutrition'),
                      ),
                      const SizedBox(height: 32),
                      NavigationMenuItem(
                        title: 'Health',
                        textColor: Colors.black87,
                        onTap: () => _navigateToPage('/health'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    final bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7DA8E6) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF7DA8E6) : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7DA8E6).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4A5568),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(
    BuildContext context,
    String imageUrl,
    String hospitalName,
    String location,
    double rating,
    int reviews, {
    required Map<String, String> hospitalData,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'hospital-booking',
          extra: hospitalData,
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.local_hospital,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFA726),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        ' ($reviews reviews)',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    debugPrint('Rendering appointment card: ${appointment.id}, ${appointment.type}, ${appointment.status}');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    appointment.type.contains('Ultrasound')
                        ? '🩻'
                        : appointment.type.contains('Blood')
                            ? '🩸'
                            : appointment.type.contains('Antenatal')
                                ? '🩺'
                                : '📋',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      appointment.practitioner,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _getStatusIcon(appointment.status),
                    const SizedBox(width: 4),
                    Text(
                      appointment.status[0].toUpperCase() + appointment.status.substring(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(appointment.status),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF718096)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  appointment.hospital,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF718096)),
              const SizedBox(width: 4),
              Text(
                DateTime.parse(appointment.date).toString().split(' ')[0],
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Color(0xFF718096)),
              const SizedBox(width: 4),
              Text(
                appointment.time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                appointment.mode == 'virtual' ? Icons.videocam : Icons.phone,
                size: 16,
                color: appointment.mode == 'virtual' ? Colors.blue : Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                '${appointment.mode[0].toUpperCase() + appointment.mode.substring(1)} appointment',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAppointment = appointment;
                    showRescheduleDialog = true;
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit, size: 16, color: Color(0xFFF59297)),
                    SizedBox(width: 4),
                    Text(
                      'Reschedule',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFF59297),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _cancelAppointment(appointment.id),
                child: const Row(
                  children: [
                    Icon(Icons.close, size: 16, color: Color(0xFFDC2626)),
                    SizedBox(width: 4),
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (appointment.reason != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Purpose: ${appointment.reason}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments(List<Appointment> upcomingAppointments) {
    debugPrint('Building upcoming appointments: ${upcomingAppointments.length}');
    if (upcomingAppointments.isEmpty) {
      return Column(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 64,
            color: Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 16),
          const Text(
            'No upcoming appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule your next antenatal visit',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.pushNamed('hospital-booking');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59297),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Book Appointment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: upcomingAppointments.map((appointment) {
        debugPrint('Rendering appointment: ${appointment.id}, ${appointment.type}, ${appointment.status}');
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(appointment),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarView(List<Appointment> upcomingAppointments) {
    debugPrint('Building calendar view with ${upcomingAppointments.length} appointments');
    return Column(
      children: [
        const Icon(
          Icons.calendar_today,
          size: 64,
          color: Color(0xFFCBD5E1),
        ),
        const SizedBox(height: 16),
        const Text(
          'Calendar View',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Interactive calendar coming soon!',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: upcomingAppointments.take(3).map((appointment) {
            return Container(
              width: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF59297).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59297).withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    DateTime.parse(appointment.date).day.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF59297),
                    ),
                  ),
                  Text(
                    DateTime.parse(appointment.date).toString().split(' ')[0].substring(5),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appointment.type,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${appointment.hospital} • ${appointment.time}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHistoryAppointments(List<Appointment> pastAppointments) {
    debugPrint('Building history appointments: ${pastAppointments.length}');
    if (pastAppointments.isEmpty) {
      return Column(
        children: [
          const Icon(
            Icons.description,
            size: 64,
            color: Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 16),
          const Text(
            'No appointment history',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your past appointments will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }

    return Column(
      children: pastAppointments.map((appointment) {
        debugPrint('Rendering past appointment: ${appointment.id}, ${appointment.type}, ${appointment.status}');
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(appointment),
        );
      }).toList(),
    );
  }
}

class RescheduleDialog extends StatefulWidget {
  final Appointment appointment;
  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onClose;

  const RescheduleDialog({
    super.key,
    required this.appointment,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  State<RescheduleDialog> createState() => _RescheduleDialogState();
}

class _RescheduleDialogState extends State<RescheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _hospitalController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _hospitalController.text = widget.appointment.hospital;
    _reasonController.text = widget.appointment.reason ?? '';
    _selectedDate = DateTime.parse(widget.appointment.date);
    _selectedTime = TimeOfDay(
      hour: int.parse(widget.appointment.time.split(':')[0]),
      minute: int.parse(widget.appointment.time.split(':')[1]),
    );
  }

  @override
  void dispose() {
    _hospitalController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent overlay
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Dialog content
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reschedule Appointment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: const Icon(Icons.close, size: 24, color: Color(0xFF718096)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hospitalController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Name',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Color(0xFF718096)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a hospital name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Reason for Appointment',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Color(0xFF718096)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                                  : 'Select Date',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Select Time',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
                          final formData = {
                            'hospital_name': _hospitalController.text,
                            'reason': _reasonController.text,
                            'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            'time': _selectedTime!.format(context),
                          };
                          widget.onSubmit(formData);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59297),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Reschedule',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}