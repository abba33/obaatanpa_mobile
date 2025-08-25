import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/auth/components/pregnancy_info_popup.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/baby_this_week.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/daily_tasks_component.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/nutrition_this_week_section.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/postpartum_tools_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/pregnancy_this_week.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/quick_actions_row.dart';
import 'package:provider/provider.dart';
import 'components/custom_app_bar.dart';
import 'components/your_care_toolbox_card.dart';
import '../../../widgets/navigation/navigation_menu.dart';
import '../../../providers/pregnancy_data_provider.dart';

// Main Dashboard Page
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isMenuOpen = false;
  bool _isChatbotVisible = false;

  @override
  void initState() {
    super.initState();
    // Check if pregnancy data is available, if not, show setup dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pregnancyProvider = context.read<PregnancyDataProvider>();
      if (!pregnancyProvider.isDataSet) {
        _showPregnancySetupDialog();
      }
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
            context
                .read<PregnancyDataProvider>()
                .setPregnancyData(pregnancyData);
          },
          onClose: () {
            Navigator.of(context).pop();
            // Set default data if user closes without completing
            context.read<PregnancyDataProvider>().setPregnancyData({
              'calculationType': 'current_week',
              'currentWeek': 20,
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
    return Consumer<PregnancyDataProvider>(
      builder: (context, pregnancyProvider, child) {
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
                      currentWeek: pregnancyProvider.currentWeek,
                      trimester: pregnancyProvider.trimester,
                      daysUntilDue: pregnancyProvider.daysUntilDue,
                      pregnancyPhase: pregnancyProvider.pregnancyPhase,
                      onJournalTap: _showJournalBottomSheet,
                    ),
                    const SizedBox(height: 20),

                    // Personalized Quick Actions
                    PersonalizedQuickActionsRow(
                      currentWeek: pregnancyProvider.currentWeek,
                      trimester: pregnancyProvider.trimester,
                    ),
                    const SizedBox(height: 24),

                    // Daily Tasks Card - NEW COMPONENT
                    DailyTasksCard(
                      currentWeek: pregnancyProvider.currentWeek,
                      trimester: pregnancyProvider.trimester,
                    ),
                    const SizedBox(height: 24),

                    // Tools Card (now takes full width)
                    PersonalizedToolsCard(
                      trimester: pregnancyProvider.trimester,
                      currentWeek: pregnancyProvider.currentWeek,
                    ),
                    const SizedBox(height: 20),

                    // Personalized Baby Development Card
                    PersonalizedBabyThisWeekCard(
                      weekInfo: pregnancyProvider.currentWeekInfo,
                      currentWeek: pregnancyProvider.currentWeek,
                    ),
                    const SizedBox(height: 24),

                    // Personalized nutrition section
                    PersonalizedNutritionSection(
                      nutritionTips: pregnancyProvider.currentNutritionTips,
                      currentWeek: pregnancyProvider.currentWeek,
                    ),
                    
                    // Add bottom padding to account for floating buttons
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget _buildFloatingButtons() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chatbot floating button
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.book_outlined,
                  color: Color(0xFFF8BBD9),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add Journal Entry',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Journal form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Mood selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMoodButton('😊', 'Great'),
                      _buildMoodButton('🙂', 'Good'),
                      _buildMoodButton('😐', 'Okay'),
                      _buildMoodButton('😟', 'Tired'),
                      _buildMoodButton('😰', 'Anxious'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Write about your day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Text input
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          hintText: 'Share your thoughts, symptoms, or any special moments from today...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Journal entry saved!'),
                            backgroundColor: Color(0xFFF8BBD9),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8BBD9),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Entry',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        // Handle mood selection
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
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
            // Chatbot header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
            
            // Chat messages area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Welcome message
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
                    
                    // Quick action buttons
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
            
            // Chat input
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
                      gradient: LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      ),
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
            // App Bar in Menu
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

            // Menu Items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationMenuItem(
                      title: 'Dashboard',
                      isActive: true,
                      textColor: const Color(0xFFF8BBD9),
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