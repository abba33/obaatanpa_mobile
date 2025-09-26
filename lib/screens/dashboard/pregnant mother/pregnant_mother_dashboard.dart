import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/auth/components/pregnancy_info_popup.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/baby_this_week.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/daily_tasks_component.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/nutrition_this_week_section.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/postpartum_tools_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/pregnancy_this_week.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/quick_actions_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'components/custom_app_bar.dart';
import '../../../widgets/navigation/navigation_menu.dart';

// Main Dashboard Page
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isMenuOpen = false;
  bool _isChatbotVisible = false;
  String _selectedMood = '';
  int _pregnancyWeek = 20; // Default week
  String _trimester = '2nd Trimester'; // Default trimester
  bool _isDataSet = false;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    // Load pregnancy data from SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPregnancyData();
    });
  }

  Future<void> _loadPregnancyData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pregnancyWeek = prefs.getInt('pregnancyWeek') ?? 20;
      _trimester = prefs.getString('trimester') ?? _calculateTrimester(_pregnancyWeek);
      _isDataSet = prefs.getBool('isPregnancyDataSet') ?? false;
      final dueDateString = prefs.getString('dueDate');
      _dueDate = dueDateString != null ? DateTime.tryParse(dueDateString) : null;
    });
    if (!_isDataSet) {
      _showPregnancySetupDialog();
    }
  }

  String _calculateTrimester(int week) {
    if (week <= 13) return '1st Trimester';
    if (week <= 27) return '2nd Trimester';
    return '3rd Trimester';
  }

  Future<void> _savePregnancyData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final week = (data['pregnancyWeek'] ?? data['currentWeek'] ?? 20) as int;
    await prefs.setInt('pregnancyWeek', week);
    await prefs.setString('trimester', _calculateTrimester(week));
    await prefs.setBool('isPregnancyDataSet', true);
    if (data['dueDate'] != null) {
      await prefs.setString('dueDate', data['dueDate'].toString());
    }
    setState(() {
      _pregnancyWeek = week;
      _trimester = _calculateTrimester(week);
      _isDataSet = true;
      _dueDate = data['dueDate'] != null ? DateTime.parse(data['dueDate'].toString()) : null;
    });
  }

  void _showPregnancySetupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Setup Pregnancy Information'),
          content: const Text(
              'Please set up your pregnancy information to get personalized content.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showPregnancyInfoPopup();
              },
              child: const Text('Setup Now'),
            ),
          ],
        );
      },
    );
  }

  void _showPregnancyInfoPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PregnancyInfoPopup(
          onComplete: (pregnancyData) {
            Navigator.of(context).pop();
            _savePregnancyData(pregnancyData);
          },
          onClose: () {
            Navigator.of(context).pop();
            // Set default data if user closes without completing
            _savePregnancyData({
              'calculationType': 'current-week',
              'pregnancyWeek': 20,
              'dueDate': DateTime.now().add(const Duration(days: 140)),
            });
          },
        );
      },
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _toggleChatbot() {
    setState(() {
      _isChatbotVisible = !_isChatbotVisible;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu();
    if (routeName != '/dashboard/pregnant_mother_dashboard') {
      context.go(routeName);
    }
  }

  void _showJournalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildJournalBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Force the status bar to be transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildDashboardContent(),
          if (_isMenuOpen) _buildNavigationMenu(),
          if (_isChatbotVisible) _buildChatbot(),
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        // Custom App Bar
        CustomAppBar(
          isMenuOpen: _isMenuOpen,
          onMenuTap: _toggleMenu,
          title: '',
        ),

        // Dashboard Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personalized Pregnancy Week Card with Journal
                PersonalizedPregnancyWeekCard(
                  currentWeek: _pregnancyWeek,
                  trimester: _trimester,
                  daysUntilDue: _dueDate != null ? _dueDate!.difference(DateTime.now()).inDays : 0,
                  pregnancyPhase: _getPregnancyPhase(_pregnancyWeek),
                  onJournalTap: _showJournalBottomSheet,
                ),
                const SizedBox(height: 20),

                // Personalized Quick Actions
                PersonalizedQuickActionsRow(
                  currentWeek: _pregnancyWeek,
                  trimester: _trimester,
                ),
                const SizedBox(height: 24),

                // Daily Tasks Card
                DailyTasksCard(
                  currentWeek: _pregnancyWeek,
                  trimester: _trimester,
                ),
                const SizedBox(height: 24),

                // Tools Card
                PersonalizedToolsCard(
                  trimester: _trimester,
                  currentWeek: _pregnancyWeek,
                ),
                const SizedBox(height: 20),

                // Personalized Baby Development Card
                PersonalizedBabyThisWeekCard(
                  weekInfo: _getWeekInfo(_pregnancyWeek),
                  currentWeek: _pregnancyWeek,
                ),
                const SizedBox(height: 24),

                // Personalized nutrition section
                PersonalizedNutritionSection(
                  nutritionTips: _getNutritionTips(_pregnancyWeek),
                  currentWeek: _pregnancyWeek,
                ),

                // Add bottom padding to account for floating buttons
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getPregnancyPhase(int week) {
    if (week <= 4) return 'Early Pregnancy';
    if (week <= 13) return 'First Trimester';
    if (week <= 27) return 'Second Trimester';
    if (week <= 36) return 'Third Trimester';
    return 'Term';
  }

  Map<String, dynamic> _getWeekInfo(int week) {
    return _weeklyInformation[week] ?? _getDefaultWeekInfo(week);
  }

  Map<String, dynamic> _getDefaultWeekInfo(int week) {
    return {
      'babySize': 'Growing',
      'babyDevelopment': 'Your baby is developing beautifully this week.',
      'motherChanges': 'Your body continues to adapt to support your growing baby.',
      'tips': ['Stay hydrated', 'Get plenty of rest', 'Eat nutritious foods'],
      'appointments': 'Regular check-up recommended',
      'nutrition': [
        'Balanced diet with fruits and vegetables',
        'Adequate protein intake',
        'Stay hydrated',
      ],
    };
  }

  List<String> _getNutritionTips(int week) {
    final weekInfo = _getWeekInfo(week);
    return List<String>.from(weekInfo['nutrition'] ?? [
      'Balanced diet with fruits and vegetables',
      'Adequate protein intake',
      'Stay hydrated',
    ]);
  }

  // Weekly information database (from original PregnancyDataProvider)
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

  Widget _buildFloatingButtons() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: _toggleChatbot,
                child: Icon(
                  _isChatbotVisible ? Icons.close : Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalBottomSheet() {
    // Unchanged from original
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59297),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59297).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit_note,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Journal',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Capture your pregnancy journey',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59297).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF59297).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59297),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Today - ${_formatCurrentDate()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEnhancedMoodButton('😊', 'Amazing', const Color(0xFF4CAF50)),
                        _buildEnhancedMoodButton('🙂', 'Good', const Color(0xFF8BC34A)),
                        _buildEnhancedMoodButton('😐', 'Okay', const Color(0xFFFFEB3B)),
                        _buildEnhancedMoodButton('😟', 'Tired', const Color(0xFFFF9800)),
                        _buildEnhancedMoodButton('😰', 'Anxious', const Color(0xFFF44336)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Share your thoughts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF59297).withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const TextField(
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: 'Write about your day, symptoms, thoughts, or special moments...\n\nWhat made you smile today?\nHow is baby doing?\nAny new symptoms or changes?',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF7DA8E6).withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7DA8E6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Add Photos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Optional',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7DA8E6),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7DA8E6).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Camera',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF7DA8E6),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.photo_library,
                                          color: Color(0xFF7DA8E6),
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Gallery',
                                          style: TextStyle(
                                            color: Color(0xFF7DA8E6),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
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
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59297),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59297).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Journal entry saved successfully!'),
                              ],
                            ),
                            backgroundColor: const Color(0xFFF59297),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Save Entry',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedMoodButton(String emoji, String label, Color color) {
    final isSelected = _selectedMood == label;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedMood = label;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : color.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? color : color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Widget _buildChatbot() {
    return Positioned(
      right: 16,
      bottom: 80,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.smart_toy,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pregnancy Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Ask me anything!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleChatbot,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Hi! I\'m your pregnancy assistant. I can help answer questions about pregnancy, nutrition, symptoms, and more. What would you like to know?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildQuickChatButton('Pregnancy symptoms'),
                        _buildQuickChatButton('Nutrition tips'),
                        _buildQuickChatButton('Exercise guide'),
                        _buildQuickChatButton('Doctor questions'),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Type your question...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
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

  Widget _buildQuickChatButton(String text) {
    return GestureDetector(
      onTap: () {
        // Handle quick chat button tap
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationMenu() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
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
              height: MediaQuery.of(context).padding.top,
              color: Colors.white,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59297),
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
                      isActive: true,
                      textColor: const Color(0xFFF59297),
                      onTap: () => _navigateToPage('/dashboard'),
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
                      textColor: Colors.black87,
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
    );
  }
}