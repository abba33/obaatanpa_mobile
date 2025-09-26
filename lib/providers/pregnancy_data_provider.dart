import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PregnancyDataProvider with ChangeNotifier {
  Map<String, dynamic>? _pregnancyData;
  bool _isDataSet = false;

  // Getters
  Map<String, dynamic>? get pregnancyData => _pregnancyData;
  bool get isDataSet => _isDataSet;

  int get currentWeek => _pregnancyData?['pregnancyWeek'] ?? 1;
  DateTime? get dueDate => _pregnancyData?['dueDate'] != null ? DateTime.parse(_pregnancyData!['dueDate']) : null;
  DateTime? get lastMenstrualPeriod => _pregnancyData?['lastMenstrualPeriod'] != null ? DateTime.parse(_pregnancyData!['lastMenstrualPeriod']) : null;
  String get calculationMethod => _pregnancyData?['calculationMethod'] ?? 'current-week';
  String get trimester => _pregnancyData?['trimester'] ?? getTrimesterFromWeek(currentWeek);
  String? get commonSymptoms => _pregnancyData?['commonSymptoms'];
  int? get currentDay => _pregnancyData?['currentDay'];
  String? get fetalDevelopment => _pregnancyData?['fetalDevelopment'];
  String? get milestones => _pregnancyData?['milestones'];

  // Computed properties
  int get daysUntilDue {
    if (dueDate == null) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  String get weekDisplayText => 'Week $currentWeek';

  String get pregnancyPhase {
    final week = currentWeek;
    if (week <= 4) return 'Early Pregnancy';
    if (week <= 13) return 'First Trimester';
    if (week <= 27) return 'Second Trimester';
    if (week <= 36) return 'Third Trimester';
    return 'Term';
  }

  // Calculate trimester based on week (aligned with React)
  String getTrimesterFromWeek(int week) {
    if (week <= 13) return 'first';
    if (week <= 27) return 'second';
    return 'third';
  }

  // Calculate pregnancy week locally
  int calculatePregnancyWeekLocally(String method, Map<String, dynamic> data) {
    final today = DateTime.now();

    switch (method) {
      case 'due-date':
        final dueDate = DateTime.parse(data['dueDate']);
        final daysDiff = (dueDate.difference(today).inDays).floor();
        final weeksRemaining = (daysDiff / 7).floor();
        return (40 - weeksRemaining).clamp(1, 40);

      case 'lmp':
        final lmpDate = DateTime.parse(data['lastMenstrualPeriod']);
        final daysSinceLMP = (today.difference(lmpDate).inDays).floor();
        return (daysSinceLMP / 7).floor().clamp(1, 40);

      case 'current-week':
        final week = int.tryParse(data['currentWeek'].toString()) ?? 1;
        return week.clamp(1, 40);

      default:
        return 1;
    }
  }

  // Calculate pregnancy week with API integration
  Future<void> calculatePregnancyWeek({
    required String method,
    required Map<String, dynamic> data,
  }) async {
    if (!_validateInput(method, data)) {
      throw Exception(_getValidationError(method, data));
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (method != 'current-week' && token == null) {
      throw Exception('Authentication token is missing. Please log in first.');
    }

    try {
      int pregnancyWeek = 1;
      String trimester = 'first';
      Map<String, dynamic> result = {};

      if (method == 'due-date') {
        final response = await http.post(
          Uri.parse('https://obaatanpa-backend.onrender.com/info/pw/conception_date/calculate'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'conception_date': data['dueDate']}),
        );

        if (response.statusCode != 200) {
          if (response.statusCode == 401) {
            throw Exception('Unauthorized: Invalid or expired token. Please log in again.');
          }
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to calculate pregnancy week.');
        }

        result = jsonDecode(response.body);
        pregnancyWeek = result['current_week'];
        trimester = getTrimesterFromWeek(pregnancyWeek);
      } else if (method == 'lmp') {
        final response = await http.post(
          Uri.parse('https://obaatanpa-backend.onrender.com/info/pw/menstrual_date/calculate'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'last_period_date': data['lastMenstrualPeriod'],
            'cycle_length': int.parse(data['cycleLength']),
          }),
        );

        if (response.statusCode != 200) {
          if (response.statusCode == 401) {
            throw Exception('Unauthorized: Invalid or expired token. Please log in again.');
          }
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to calculate pregnancy week.');
        }

        result = jsonDecode(response.body);
        pregnancyWeek = result['current_week'];
        trimester = getTrimesterFromWeek(pregnancyWeek);
      } else {
        pregnancyWeek = calculatePregnancyWeekLocally('current-week', data);
        trimester = getTrimesterFromWeek(pregnancyWeek);
        result = {
          'common_symptoms': 'Week $pregnancyWeek of pregnancy.',
          'current_day': 1,
          'current_week': pregnancyWeek,
          'fetal_development': 'Development details for week $pregnancyWeek.',
          'milestones': 'Milestones for week $pregnancyWeek.',
        };
      }

      final pregnancyData = {
        'pregnancyWeek': pregnancyWeek,
        'trimester': trimester,
        'calculationMethod': method,
        'commonSymptoms': result['common_symptoms'],
        'currentDay': result['current_day'],
        'fetalDevelopment': result['fetal_development'],
        'milestones': result['milestones'],
        if (method == 'due-date') 'dueDate': data['dueDate'],
        if (method == 'lmp') 'lastMenstrualPeriod': data['lastMenstrualPeriod'],
      };

      // Store in SharedPreferences
      await prefs.setString('pregnancyData', jsonEncode(pregnancyData));

      // Update provider state
      setPregnancyData(pregnancyData);
    } catch (e) {
      throw Exception('Error calculating pregnancy week: $e');
    }
  }

  // Validate input data
  bool _validateInput(String method, Map<String, dynamic> data) {
    final today = DateTime.now();
    final maxDate = today.add(const Duration(days: 280));

    if (method == 'due-date') {
      if (data['dueDate'] == null || data['dueDate'].isEmpty) return false;
      try {
        final dueDate = DateTime.parse(data['dueDate']);
        return !dueDate.isBefore(today) && !dueDate.isAfter(maxDate);
      } catch (e) {
        return false;
      }
    }

    if (method == 'lmp') {
      if (data['lastMenstrualPeriod'] == null || data['lastMenstrualPeriod'].isEmpty) return false;
      if (data['cycleLength'] == null || int.tryParse(data['cycleLength'].toString()) == null) return false;
      final cycleLength = int.parse(data['cycleLength']);
      try {
        final lmpDate = DateTime.parse(data['lastMenstrualPeriod']);
        return !lmpDate.isAfter(today) && cycleLength >= 21 && cycleLength <= 35;
      } catch (e) {
        return false;
      }
    }

    if (method == 'current-week') {
      if (data['currentWeek'] == null || int.tryParse(data['currentWeek'].toString()) == null) return false;
      final week = int.parse(data['currentWeek'].toString());
      return week >= 1 && week <= 40;
    }

    return false;
  }

  // Get validation error message
  String _getValidationError(String method, Map<String, dynamic> data) {
    if (method == 'due-date' && (data['dueDate'] == null || data['dueDate'].isEmpty)) {
      return 'Please enter your expected due date.';
    }
    if (method == 'due-date') {
      return 'Please enter a valid due date between today and 40 weeks from now.';
    }
    if (method == 'lmp' && (data['lastMenstrualPeriod'] == null || data['lastMenstrualPeriod'].isEmpty)) {
      return 'Please enter the first day of your last menstrual period.';
    }
    if (method == 'lmp' && (data['cycleLength'] == null || int.tryParse(data['cycleLength'].toString()) == null)) {
      return 'Please enter a valid cycle length between 21 and 35 days.';
    }
    if (method == 'lmp') {
      return 'Please enter a valid last menstrual period date before today.';
    }
    if (method == 'current-week' && (data['currentWeek'] == null || int.tryParse(data['currentWeek'].toString()) == null)) {
      return 'Please select your current pregnancy week.';
    }
    return 'Invalid input data.';
  }

  // Set pregnancy data
  void setPregnancyData(Map<String, dynamic> data) {
    _pregnancyData = data;
    _isDataSet = true;
    notifyListeners();
  }

  // Update current week
  void updateCurrentWeek(int week) {
    if (_pregnancyData != null) {
      _pregnancyData!['pregnancyWeek'] = week;
      _pregnancyData!['trimester'] = getTrimesterFromWeek(week);
      // Update SharedPreferences
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('pregnancyData', jsonEncode(_pregnancyData));
      });
      notifyListeners();
    }
  }

  // Clear data
  void clearData() {
    _pregnancyData = null;
    _isDataSet = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('pregnancyData');
    });
    notifyListeners();
  }

  // Get week-specific information
  Map<String, dynamic> getWeekInfo(int week) {
    final staticInfo = _weeklyInformation[week] ?? _getDefaultWeekInfo(week);
    // Merge with dynamic data if available
    return {
      ...staticInfo,
      if (_pregnancyData?['commonSymptoms'] != null) 'commonSymptoms': _pregnancyData!['commonSymptoms'],
      if (_pregnancyData?['fetalDevelopment'] != null) 'fetalDevelopment': _pregnancyData!['fetalDevelopment'],
      if (_pregnancyData?['milestones'] != null) 'milestones': _pregnancyData!['milestones'],
    };
  }

  Map<String, dynamic> get currentWeekInfo {
    return getWeekInfo(currentWeek);
  }

  Map<String, dynamic> _getDefaultWeekInfo(int week) {
    return {
      'babySize': 'Growing',
      'babyDevelopment': 'Your baby is developing beautifully this week.',
      'motherChanges': 'Your body continues to adapt to support your growing baby.',
      'tips': ['Stay hydrated', 'Get plenty of rest', 'Eat nutritious foods'],
      'appointments': 'Regular check-up recommended',
      'nutrition': ['Balanced diet with fruits and vegetables', 'Adequate protein intake', 'Stay hydrated'],
    };
  }

  // Weekly information database
  static const Map<int, Map<String, dynamic>> _weeklyInformation = {
    10: {
      'babySize': 'Strawberry (1.2 inches)',
      'babyDevelopment': 'Your baby\'s fingers and toes are forming, and tiny nails are beginning to grow.',
      'motherChanges': 'You may start experiencing morning sickness relief soon.',
      'tips': [
        'Continue taking prenatal vitamins',
        'Stay hydrated with plenty of water',
        'Light exercise like walking is beneficial',
      ],
      'appointments': 'First prenatal appointment if not done already',
      'nutrition': [
        'Folic acid rich foods',
        'Lean proteins',
        'Dairy products for calcium',
      ],
    },
    20: {
      'babySize': 'Banana (6.5 inches)',
      'babyDevelopment': 'Your baby can hear sounds and may respond to your voice. Hair and eyebrows are growing.',
      'motherChanges': 'You might feel the first movements (quickening). Your belly is showing more.',
      'tips': [
        'Talk and sing to your baby',
        'Consider prenatal yoga',
        'Start sleeping on your side',
      ],
      'appointments': 'Anatomy scan ultrasound around this time',
      'nutrition': [
        'Iron-rich foods',
        'Omega-3 fatty acids',
        'Colorful fruits and vegetables',
      ],
    },
    30: {
      'babySize': 'Cabbage (15.7 inches)',
      'babyDevelopment': 'Your baby\'s brain is developing rapidly. They can open and close their eyes.',
      'motherChanges': 'You may experience shortness of breath and heartburn as baby grows.',
      'tips': [
        'Practice breathing exercises',
        'Eat smaller, frequent meals',
        'Consider childbirth classes',
      ],
      'appointments': 'Regular prenatal visits every 2-3 weeks',
      'nutrition': [
        'Complex carbohydrates',
        'Protein for baby\'s growth',
        'Calcium for bone development',
      ],
    },
  };

  // Get nutrition recommendations for current week
  List<String> get currentNutritionTips {
    final weekInfo = currentWeekInfo;
    return List<String>.from(weekInfo['nutrition'] ?? [
      'Balanced diet with fruits and vegetables',
      'Adequate protein intake',
      'Stay hydrated',
    ]);
  }

  // Get development tips for current week
  List<String> get currentDevelopmentTips {
    final weekInfo = currentWeekInfo;
    return List<String>.from(weekInfo['tips'] ?? [
      'Rest when you can',
      'Stay active with light exercise',
      'Attend prenatal appointments',
    ]);
  }
}