import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:obaatanpa_mobile/providers/auth_provider.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';

class HospitalBookingPage extends StatefulWidget {
  // Optional parameters for when navigating from hospital details
  final String? hospitalName;
  final String? hospitalAddress;
  final String? hospitalImage;
  final String? phoneNumber;

  const HospitalBookingPage({
    super.key,
    this.hospitalName,
    this.hospitalAddress,
    this.hospitalImage,
    this.phoneNumber,
  });

  @override
  State<HospitalBookingPage> createState() => _HospitalBookingPageState();
}

class _HospitalBookingPageState extends State<HospitalBookingPage> {
  String? selectedDate;
  String? selectedTime;
  String hospitalSearch = '';
  String? selectedHospital;
  String selectedService = 'Prenatal Care';
  List<Map<String, dynamic>> hospitals = [];
  bool showHospitals = false;
  String? errorMessage;
  String? authToken;
  bool isFetchingHospitals = false;
  bool isBookingAppointment = false;
  
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final List<String> availableSlots = [
    '08:00', '09:00', '10:00', '10:30', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00', '17:00',
  ];

  final List<String> services = [
    'Prenatal Care',
    'Ultrasound',
    'Blood Tests',
    'Consultation',
    'Vaccination',
    'Postpartum Care',
  ];

  final String apiUrl = 'https://obaatanpa-backend.onrender.com';

  @override
  void initState() {
    super.initState();
    _loadAuthToken();
    _initializeWithProvidedHospital();
  }

  void _initializeWithProvidedHospital() {
    if (widget.hospitalName != null && widget.hospitalName!.isNotEmpty) {
      setState(() {
        selectedHospital = widget.hospitalName;
        _hospitalController.text = widget.hospitalName!;
      });
    }
  }

  Future<void> _loadAuthToken() async {
    final token = await _storage.read(key: 'auth_token');
    setState(() {
      authToken = token;
      debugPrint('Auth Token: $authToken');
    });
  }

  Future<void> _fetchHospitals() async {
    setState(() {
      isFetchingHospitals = true;
      errorMessage = null;
    });

    if (authToken == null) {
      setState(() {
        errorMessage = 'Please log in to view hospitals.';
        isFetchingHospitals = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/admin/hospitals/get'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      debugPrint('Fetch Hospitals - Status Code: ${response.statusCode}');
      debugPrint('Fetch Hospitals - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          hospitals = data.map((h) => {
            'id': h['id'],
            'name': h['name'],
          }).toList();
          showHospitals = true;
          errorMessage = null;
          isFetchingHospitals = false;
        });
      } else {
        setState(() {
          errorMessage = response.statusCode == 404
              ? 'Hospital service not found. Please check if the server is running.'
              : 'Failed to fetch hospitals. Status: ${response.statusCode}';
          isFetchingHospitals = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch hospitals: $e';
        isFetchingHospitals = false;
      });
      debugPrint('Fetch Hospitals - Error: $e');
    }
  }

  Future<void> _bookAppointment() async {
    if (selectedHospital == null || selectedDate == null || selectedTime == null || 
        (widget.hospitalName == null && _reasonController.text.isEmpty)) {
      setState(() {
        errorMessage = 'Please fill in all required fields.';
      });
      return;
    }

    if (authToken == null) {
      setState(() {
        errorMessage = 'Please log in to book an appointment.';
      });
      return;
    }

    setState(() {
      isBookingAppointment = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/appointment/book'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'hospital_name': selectedHospital,
          'date': selectedDate,
          'time': selectedTime,
          'reason': widget.hospitalName != null ? selectedService : _reasonController.text,
        }),
      );

      debugPrint('Book Appointment - Status Code: ${response.statusCode}');
      debugPrint('Book Appointment - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          await _showConfirmationDialog(data);
          setState(() {
            errorMessage = null;
            selectedHospital = widget.hospitalName ?? null;
            selectedDate = null;
            selectedTime = null;
            _dateController.clear();
            if (widget.hospitalName == null) {
              _hospitalController.clear();
              _reasonController.clear();
              showHospitals = false;
            }
            isBookingAppointment = false;
          });
        } catch (e) {
          setState(() {
            errorMessage = 'Failed to process booking response: $e';
            isBookingAppointment = false;
          });
          debugPrint('Book Appointment - JSON/Dialogue Error: $e');
        }
      } else {
        setState(() {
          errorMessage = response.statusCode == 404
              ? 'Appointment booking service not found.'
              : 'Failed to book appointment: ${jsonDecode(response.body)['message'] ?? 'Status ${response.statusCode}'}';
          isBookingAppointment = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to book appointment: $e';
        isBookingAppointment = false;
      });
      debugPrint('Book Appointment - Error: $e');
    }
  }

  Future<void> _showConfirmationDialog(Map<String, dynamic> data) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7DA8E6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF7DA8E6),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your appointment has been successfully booked:',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
            const SizedBox(height: 16),
            _buildConfirmationRow('Hospital:', selectedHospital!),
            if (widget.hospitalName != null)
              _buildConfirmationRow('Service:', selectedService)
            else
              _buildConfirmationRow('Reason:', _reasonController.text),
            _buildConfirmationRow('Date:', selectedDate!),
            _buildConfirmationRow('Time:', selectedTime!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (widget.hospitalName != null) {
                context.pop();
              } else {
                context.go('/appointments');
              }
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFF7DA8E6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final filteredHospitals = hospitals.where((hospital) =>
        hospital['name'].toString().toLowerCase().contains(hospitalSearch.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          Column(
            children: [
              _buildCustomAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Show hospital header if navigated from hospital details
                      if (widget.hospitalName != null) ...[
                        _buildHospitalHeader(),
                        const SizedBox(height: 24),
                        _buildHospitalDetails(),
                        const SizedBox(height: 28),
                      ],
                      
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
                      
                      // Only show hospital selection if not navigated from hospital details
                      if (widget.hospitalName == null) ...[
                        _buildHospitalSelection(filteredHospitals),
                        const SizedBox(height: 28),
                      ],
                      
                      // Show service selection if navigated from hospital details
                      if (widget.hospitalName != null) ...[
                        _buildServiceSelection(),
                        const SizedBox(height: 28),
                      ],
                      
                      _buildDateSelection(),
                      const SizedBox(height: 28),
                      _buildTimeSelection(),
                      const SizedBox(height: 28),
                      
                      // Only show reason input if not navigated from hospital details
                      if (widget.hospitalName == null) ...[
                        _buildReasonInput(),
                        const SizedBox(height: 40),
                      ],
                      
                      _buildBookingButton(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isFetchingHospitals || isBookingAppointment)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7DA8E6)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.5),
                  child: Image.asset(
                    'assets/images/navbar/maternity-logo.png',
                    fit: BoxFit.cover,
                    width: 45,
                    height: 45,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8BBD9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'OBAA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'TANPA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59297),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7DA8E6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF7DA8E6),
                    size: 18,
                  ),
                ),
              ),
              const Spacer(),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final userName = (authProvider.userName?.isNotEmpty == true)
                      ? authProvider.userName!
                      : 'User';
                  return RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Hello, ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: userName,
                          style: const TextStyle(
                            color: Color(0xFFF59297),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/images/navbar/profile-1.png',
                    fit: BoxFit.cover,
                    width: 36,
                    height: 36,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 20,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalHeader() {
    if (widget.hospitalName == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
            if (widget.hospitalImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  child: Image.network(
                    widget.hospitalImage!,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hospitalName!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  if (widget.hospitalAddress != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.hospitalAddress!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFA726),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        ' (245+ reviews)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7DA8E6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7DA8E6),
                          ),
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

  Widget _buildHospitalDetails() {
    if (widget.hospitalName == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hospital Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Leading government hospital with comprehensive maternity services and experienced medical professionals.',
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildContactButton(
                    icon: Icons.phone_outlined,
                    label: 'Call Hospital',
                    color: const Color(0xFFF59297),
                    onTap: () {
                      // Handle phone call
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildContactButton(
                    icon: Icons.chat_outlined,
                    label: 'Live Chat',
                    color: const Color(0xFF7DA8E6),
                    onTap: () {
                      // Handle chat
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, size: 20, color: Color(0xFF2D3748)),
                const SizedBox(width: 8),
                const Text(
                  'Select Service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF7DA8E6)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: services.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedService = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalSelection(List<Map<String, dynamic>> filteredHospitals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_hospital, size: 20, color: Color(0xFF2D3748)),
                const SizedBox(width: 8),
                const Text(
                  'Hospital',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hospitalController,
                    onChanged: (value) {
                      setState(() {
                        hospitalSearch = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for a hospital...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF7DA8E6)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isFetchingHospitals ? null : _fetchHospitals,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59297),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: isFetchingHospitals
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'View Hospitals',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
            if (showHospitals)
              Container(
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                constraints: const BoxConstraints(maxHeight: 160),
                child: filteredHospitals.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'No hospitals found.',
                          style: TextStyle(color: Color(0xFF718096)),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredHospitals.length,
                        itemBuilder: (context, index) {
                          final hospital = filteredHospitals[index];
                          return ListTile(
                            title: Text(
                              hospital['name'],
                              style: const TextStyle(color: Color(0xFF2D3748)),
                            ),
                            onTap: () {
                              setState(() {
                                selectedHospital = hospital['name'];
                                _hospitalController.text = hospital['name'];
                                showHospitals = false;
                              });
                            },
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Color(0xFF2D3748)),
                const SizedBox(width: 8),
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: const Color(0xFF7DA8E6),
                            ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Select appointment date',
                hintStyle: TextStyle(color: Colors.grey[400]),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF7DA8E6)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Color(0xFF2D3748)),
                const SizedBox(width: 8),
                const Text(
                  'Available Time Slots',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                final isSelected = selectedTime == availableSlots[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = availableSlots[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF7DA8E6).withOpacity(0.1)
                          : Colors.grey[50],
                      border: Border.all(
                        color: isSelected ? const Color(0xFF7DA8E6) : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        availableSlots[index],
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF7DA8E6)
                              : const Color(0xFF4A5568),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_information, size: 20, color: Color(0xFF2D3748)),
                const SizedBox(width: 8),
                const Text(
                  'Reason',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                hintText: 'e.g., Prenatal checkup',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF7DA8E6)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isBookingAppointment ? null : _bookAppointment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7DA8E6),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            shadowColor: const Color(0xFF7DA8E6).withOpacity(0.3),
          ),
          child: isBookingAppointment
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.hospitalName != null ? 'Book Appointment' : 'Confirm Appointment',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _hospitalController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}