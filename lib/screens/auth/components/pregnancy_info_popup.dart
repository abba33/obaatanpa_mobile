import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class PregnancyInfoPopup extends StatefulWidget {
  final Function(Map<String, dynamic>) onComplete;
  final VoidCallback onClose;

  const PregnancyInfoPopup({
    super.key,
    required this.onComplete,
    required this.onClose,
  });

  @override
  State<PregnancyInfoPopup> createState() => _PregnancyInfoPopupState();
}

class _PregnancyInfoPopupState extends State<PregnancyInfoPopup> {
  String? _selectedMethod;
  final _formData = {
    'dueDate': '',
    'lastMenstrualPeriod': '',
    'currentWeek': '',
    'cycleLength': '28', // Default cycle length for LMP
  };
  bool _showResponse = false;
  String _responseMessage = '';
  Map<String, dynamic>? _pregnancyData;
  bool _isLoading = false;

  final _storage = const FlutterSecureStorage();

  int _calculatePregnancyWeekLocally(String method, Map<String, dynamic> data) {
    final today = DateTime.now();

    switch (method) {
      case 'due-date':
        final dueDate = DateTime.tryParse(data['dueDate']!);
        if (dueDate == null) return 1;
        final daysDiff = dueDate.difference(today).inDays;
        final weeksRemaining = (daysDiff / 7).floor();
        return (40 - weeksRemaining).clamp(1, 40);

      case 'lmp':
        final lmpDate = DateTime.tryParse(data['lastMenstrualPeriod']!);
        if (lmpDate == null) return 1;
        final daysSinceLMP = today.difference(lmpDate).inDays;
        return (daysSinceLMP / 7).floor().clamp(1, 40);

      case 'current-week':
        final week = int.tryParse(data['currentWeek']!) ?? 1;
        return week.clamp(1, 40);

      default:
        return 1;
    }
  }

  String _getTrimesterFromWeek(int week) {
    if (week <= 13) return 'first';
    if (week <= 27) return 'second';
    return 'third';
  }

  Future<void> _handleSubmit() async {
    if (_selectedMethod == null) {
      setState(() {
        _responseMessage = 'Please select a calculation method.';
        _showResponse = true;
      });
      return;
    }

    // Validate input fields
    if (_selectedMethod == 'due-date') {
      if (_formData['dueDate']!.isEmpty) {
        setState(() {
          _responseMessage = 'Please enter your expected due date.';
          _showResponse = true;
        });
        return;
      }
      final dueDate = DateTime.tryParse(_formData['dueDate']!);
      final today = DateTime.now();
      final maxDate = today.add(const Duration(days: 280));
      if (dueDate == null || dueDate.isBefore(today) || dueDate.isAfter(maxDate)) {
        setState(() {
          _responseMessage = 'Please enter a valid due date between today and 40 weeks from now.';
          _showResponse = true;
        });
        return;
      }
    }
    if (_selectedMethod == 'lmp') {
      if (_formData['lastMenstrualPeriod']!.isEmpty) {
        setState(() {
          _responseMessage = 'Please enter the first day of your last menstrual period.';
          _showResponse = true;
        });
        return;
      }
      final cycleLength = int.tryParse(_formData['cycleLength']!) ?? 0;
      if (cycleLength < 21 || cycleLength > 35) {
        setState(() {
          _responseMessage = 'Please enter a valid cycle length between 21 and 35 days.';
          _showResponse = true;
        });
        return;
      }
      final lmpDate = DateTime.tryParse(_formData['lastMenstrualPeriod']!);
      final today = DateTime.now();
      if (lmpDate == null || lmpDate.isAfter(today)) {
        setState(() {
          _responseMessage = 'Please enter a valid last menstrual period date before today.';
          _showResponse = true;
        });
        return;
      }
    }
    if (_selectedMethod == 'current-week' && _formData['currentWeek']!.isEmpty) {
      setState(() {
        _responseMessage = 'Please select your current pregnancy week.';
        _showResponse = true;
      });
      return;
    }

    final token = await _storage.read(key: 'authToken');
    if (token == null && _selectedMethod != 'current-week') {
      setState(() {
        _responseMessage = 'Authentication token is missing. Please log in first.';
        _showResponse = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      int pregnancyWeek = 1;
      String trimester = 'first';
      Map<String, dynamic> result = {};

      if (_selectedMethod == 'due-date') {
        final response = await http.post(
          Uri.parse('https://obaatanpa-backend.onrender.com/info/pw/conception_date/calculate'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'conception_date': _formData['dueDate']!}),
        );
        if (response.statusCode == 200 || response.statusCode == 201) { // Updated to check 200 or 201
          result = jsonDecode(response.body);
          pregnancyWeek = result['current_week'] ?? _calculatePregnancyWeekLocally('due-date', _formData);
          trimester = _getTrimesterFromWeek(pregnancyWeek);
        } else {
          final errorData = jsonDecode(response.body);
          if (response.statusCode == 401) {
            throw Exception('Unauthorized: Invalid or expired token. Please log in again.');
          }
          throw Exception(errorData['message'] ?? 'Failed to calculate pregnancy week.');
        }
      } else if (_selectedMethod == 'lmp') {
        final response = await http.post(
          Uri.parse('https://obaatanpa-backend.onrender.com/info/pw/menstrual_date/calculate'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'last_period_date': _formData['lastMenstrualPeriod']!,
            'cycle_length': int.parse(_formData['cycleLength']!),
          }),
        );
        if (response.statusCode == 200 || response.statusCode == 201) { // Updated to check 200 or 201
          result = jsonDecode(response.body);
          pregnancyWeek = result['current_week'] ?? _calculatePregnancyWeekLocally('lmp', _formData);
          trimester = _getTrimesterFromWeek(pregnancyWeek);
        } else {
          final errorData = jsonDecode(response.body);
          if (response.statusCode == 401) {
            throw Exception('Unauthorized: Invalid or expired token. Please log in again.');
          }
          throw Exception(errorData['message'] ?? 'Failed to calculate pregnancy week.');
        }
      } else {
        pregnancyWeek = _calculatePregnancyWeekLocally('current-week', _formData);
        trimester = _getTrimesterFromWeek(pregnancyWeek);
        result = {
          'common_symptoms': 'Week $pregnancyWeek of pregnancy.',
          'current_day': 1,
          'current_week': pregnancyWeek,
          'fetal_development': 'Development details for week $pregnancyWeek.',
          'milestones': 'Milestones for week $pregnancyWeek.',
        };
      }

      final dueDate = _selectedMethod == 'due-date'
          ? DateTime.parse(_formData['dueDate']!)
          : _selectedMethod == 'lmp'
              ? DateTime.parse(_formData['lastMenstrualPeriod']!).add(const Duration(days: 280))
              : DateTime.now().add(Duration(days: (40 - pregnancyWeek) * 7));

      final data = {
        'calculationType': _selectedMethod,
        'currentWeek': pregnancyWeek,
        'dueDate': dueDate,
        'trimester': trimester,
        'commonSymptoms': result['common_symptoms'],
        'currentDay': result['current_day'],
        'fetalDevelopment': result['fetal_development'],
        'milestones': result['milestones'],
        if (_selectedMethod == 'lmp') 'lastMenstrualPeriod': _formData['lastMenstrualPeriod']!,
      };

      setState(() {
        _pregnancyData = data;
        _responseMessage = '''
Week ${result['current_week']}, Day ${result['current_day']} ($trimester trimester)
Symptoms: ${result['common_symptoms']}
Fetal Development: ${result['fetal_development']}
Milestones: ${result['milestones']}
''';
        _showResponse = true;
      });
    } catch (e) {
      setState(() {
        _responseMessage = 'Error calculating pregnancy week: $e';
        _showResponse = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleResponseClose() {
    setState(() {
      _showResponse = false;
    });
    if (_pregnancyData != null) {
      widget.onComplete(_pregnancyData!);
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main content
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                '🤰',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Help us know you better',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Choose how you\'d like to calculate your pregnancy week',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Method selection or input form
                        if (_selectedMethod == null)
                          Column(
                            children: [
                              _buildMethodButton(
                                id: 'due-date',
                                icon: Icons.calendar_today,
                                title: 'Due Date',
                                description: 'I know my expected delivery date',
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7DA8E6), Color(0xFF7DA8E6)],
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildMethodButton(
                                id: 'lmp',
                                icon: Icons.access_time,
                                title: 'Last Menstrual Period',
                                description: 'I know the first day of my last period',
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF8A7AB), Color(0xFFF8A7AB)],
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildMethodButton(
                                id: 'current-week',
                                icon: Icons.pregnant_woman,
                                title: 'Current Pregnancy Week',
                                description: 'I know how many weeks pregnant I am',
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFCE93D8), Color(0xFFCE93D8)],
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedMethod == 'due-date'
                                    ? 'Due Date'
                                    : _selectedMethod == 'lmp'
                                        ? 'Last Menstrual Period'
                                        : 'Current Pregnancy Week',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                _selectedMethod == 'due-date'
                                    ? 'I know my expected delivery date'
                                    : _selectedMethod == 'lmp'
                                        ? 'I know the first day of my last period'
                                        : 'I know how many weeks pregnant I am',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Input fields based on method
                              if (_selectedMethod == 'due-date')
                                _buildDateField(
                                  label: 'Expected Due Date *',
                                  onTap: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 280)),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _formData['dueDate'] = DateFormat('yyyy-MM-dd').format(pickedDate);
                                      });
                                    }
                                  },
                                  value: _formData['dueDate']!,
                                ),

                              if (_selectedMethod == 'lmp') ...[
                                _buildDateField(
                                  label: 'First Day of Last Menstrual Period *',
                                  onTap: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _formData['lastMenstrualPeriod'] =
                                            DateFormat('yyyy-MM-dd').format(pickedDate);
                                      });
                                    }
                                  },
                                  value: _formData['lastMenstrualPeriod']!,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  label: 'Menstrual Cycle Length (days) *',
                                  initialValue: _formData['cycleLength']!,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _formData['cycleLength'] = value;
                                  },
                                  validator: (value) {
                                    final cycleLength = int.tryParse(value ?? '') ?? 0;
                                    if (cycleLength < 21 || cycleLength > 35) {
                                      return 'Enter a value between 21 and 35';
                                    }
                                    return null;
                                  },
                                ),
                              ],

                              if (_selectedMethod == 'current-week')
                                _buildWeekSelector(),

                              const SizedBox(height: 24),

                              // Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                _selectedMethod = null;
                                              });
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[200],
                                        foregroundColor: Colors.grey[800],
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Back',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading ||
                                              (_selectedMethod == 'due-date' && _formData['dueDate']!.isEmpty) ||
                                              (_selectedMethod == 'lmp' &&
                                                  (_formData['lastMenstrualPeriod']!.isEmpty ||
                                                      _formData['cycleLength']!.isEmpty)) ||
                                              (_selectedMethod == 'current-week' && _formData['currentWeek']!.isEmpty)
                                          ? null
                                          : _handleSubmit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.center,
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                'Calculate My Week',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // Close button
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: widget.onClose,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Response popup
        if (_showResponse)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decorative image
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Your Pregnancy Journey',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Response content
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _responseMessage,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    // Okay button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ElevatedButton(
                        onPressed: _handleResponseClose,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFF59297),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Okay',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF59297),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Color(0xFFF59297),
                              size: 20,
                            ),
                          ],
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

  Widget _buildMethodButton({
    required String id,
    required IconData icon,
    required String title,
    required String description,
    required LinearGradient gradient,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required VoidCallback onTap,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? 'Select date' : value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: value.isEmpty ? Colors.grey[500] : Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    TextInputType? keyboardType,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF59297), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWeekSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Pregnancy Week *',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _formData['currentWeek']!.isEmpty ? null : _formData['currentWeek'],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF59297), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          hint: Text(
            'Select week',
            style: GoogleFonts.poppins(color: Colors.grey[500]),
          ),
          items: List.generate(40, (index) => index + 1).map((week) {
            final trimester = week <= 13
                ? '(1st Trimester)'
                : week <= 27
                    ? '(2nd Trimester)'
                    : '(3rd Trimester)';
            return DropdownMenuItem<String>(
              value: week.toString(),
              child: Text(
                'Week $week $trimester',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _formData['currentWeek'] = value ?? '';
            });
          },
          validator: (value) => value == null ? 'Please select a week' : null,
        ),
      ],
    );
  }
}