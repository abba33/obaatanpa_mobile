import 'package:flutter/foundation.dart';

class PregnancyDataProvider with ChangeNotifier {
  Map<String, dynamic>? _pregnancyData;
  bool _isDataSet = false;

  // Getters
  Map<String, dynamic>? get pregnancyData => _pregnancyData;
  bool get isDataSet => _isDataSet;
  
  int get currentWeek => _pregnancyData?['currentWeek'] ?? 1;
  DateTime? get dueDate => _pregnancyData?['dueDate'];
  DateTime? get lastPeriodDate => _pregnancyData?['lastPeriodDate'];
  String get calculationType => _pregnancyData?['calculationType'] ?? 'current_week';
  
  // Computed properties
  String get trimester {
    final week = currentWeek;
    if (week <= 12) return 'First';
    if (week <= 26) return 'Second';
    return 'Third';
  }
  
  int get daysUntilDue {
    if (dueDate == null) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }
  
  String get weekDisplayText => 'Week $currentWeek';
  
  String get pregnancyPhase {
    final week = currentWeek;
    if (week <= 4) return 'Early Pregnancy';
    if (week <= 12) return 'First Trimester';
    if (week <= 26) return 'Second Trimester';
    if (week <= 36) return 'Third Trimester';
    return 'Term';
  }

  // Methods
  void setPregnancyData(Map<String, dynamic> data) {
    _pregnancyData = data;
    _isDataSet = true;
    notifyListeners();
  }
  
  void updateCurrentWeek(int week) {
    if (_pregnancyData != null) {
      _pregnancyData!['currentWeek'] = week;
      notifyListeners();
    }
  }
  
  void clearData() {
    _pregnancyData = null;
    _isDataSet = false;
    notifyListeners();
  }
  
  // Get week-specific information
  Map<String, dynamic> getWeekInfo(int week) {
    return _weeklyInformation[week] ?? _getDefaultWeekInfo(week);
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
    };
  }
  
  // Weekly information database (you can expand this)
  static const Map<int, Map<String, dynamic>> _weeklyInformation = {
    10: {
      'babySize': 'Strawberry (1.2 inches)',
      'babyDevelopment': 'Your baby\'s fingers and toes are forming, and tiny nails are beginning to grow.',
      'motherChanges': 'You may start experiencing morning sickness relief soon.',
      'tips': [
        'Continue taking prenatal vitamins',
        'Stay hydrated with plenty of water',
        'Light exercise like walking is beneficial'
      ],
      'appointments': 'First prenatal appointment if not done already',
      'nutrition': [
        'Folic acid rich foods',
        'Lean proteins',
        'Dairy products for calcium'
      ],
    },
    20: {
      'babySize': 'Banana (6.5 inches)',
      'babyDevelopment': 'Your baby can hear sounds and may respond to your voice. Hair and eyebrows are growing.',
      'motherChanges': 'You might feel the first movements (quickening). Your belly is showing more.',
      'tips': [
        'Talk and sing to your baby',
        'Consider prenatal yoga',
        'Start sleeping on your side'
      ],
      'appointments': 'Anatomy scan ultrasound around this time',
      'nutrition': [
        'Iron-rich foods',
        'Omega-3 fatty acids',
        'Colorful fruits and vegetables'
      ],
    },
    30: {
      'babySize': 'Cabbage (15.7 inches)',
      'babyDevelopment': 'Your baby\'s brain is developing rapidly. They can open and close their eyes.',
      'motherChanges': 'You may experience shortness of breath and heartburn as baby grows.',
      'tips': [
        'Practice breathing exercises',
        'Eat smaller, frequent meals',
        'Consider childbirth classes'
      ],
      'appointments': 'Regular prenatal visits every 2-3 weeks',
      'nutrition': [
        'Complex carbohydrates',
        'Protein for baby\'s growth',
        'Calcium for bone development'
      ],
    },
    // Add more weeks as needed
  };
  
  // Get nutrition recommendations for current week
  List<String> get currentNutritionTips {
    final weekInfo = currentWeekInfo;
    return List<String>.from(weekInfo['nutrition'] ?? [
      'Balanced diet with fruits and vegetables',
      'Adequate protein intake',
      'Stay hydrated'
    ]);
  }
  
  // Get development tips for current week  
  List<String> get currentDevelopmentTips {
    final weekInfo = currentWeekInfo;
    return List<String>.from(weekInfo['tips'] ?? [
      'Rest when you can',
      'Stay active with light exercise',
      'Attend prenatal appointments'
    ]);
  }
}