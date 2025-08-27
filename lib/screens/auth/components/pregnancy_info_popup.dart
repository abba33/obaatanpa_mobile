import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _PregnancyInfoPopupState extends State<PregnancyInfoPopup> with TickerProviderStateMixin {
  String selectedTab = 'due_date';
  DateTime? selectedDate;
  int? selectedWeek;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController lastPeriodController = TextEditingController();

  // Enhanced color scheme
  static const Color primaryColor = Color(0xFFF59297);
  static const Color secondaryColor = Color(0xFF7DA8E6);
  static const Color lightPrimary = Color(0xFFFFF8F9);
  static const Color lightSecondary = Color(0xFFF5F9FF);
  static const Color accentGradientStart = Color(0xFFF59297);
  static const Color accentGradientEnd = Color(0xFF7DA8E6);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    dueDateController.dispose();
    lastPeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildEnhancedHeader(),
                  _buildEnhancedTabBar(),
                  Expanded(child: _buildTabContent()),
                  _buildEnhancedActionButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [accentGradientStart, accentGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              '🤰',
              style: TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregnancy Journey',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Let\'s personalize your beautiful journey',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTabBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: lightPrimary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _buildEnhancedTab('due_date', 'Due Date', Icons.event, primaryColor),
            _buildEnhancedTab('last_period', 'Last Period', Icons.calendar_month, secondaryColor),
            _buildEnhancedTab('current_week', 'Current Week', Icons.timeline, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTab(String tabId, String title, IconData icon, Color tabColor) {
    final isSelected = selectedTab == tabId;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedTab = tabId;
          selectedDate = null;
          selectedWeek = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? LinearGradient(
              colors: [tabColor, tabColor.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ) : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected ? [
              BoxShadow(
                color: tabColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ] : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.white : tabColor.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : tabColor.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, lightPrimary.withOpacity(0.3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedTab == 'due_date') _buildDueDateContent(),
            if (selectedTab == 'last_period') _buildLastPeriodContent(),
            if (selectedTab == 'current_week') _buildCurrentWeekContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateContent() {
    return _buildEnhancedDateInputSection(
      title: 'Expected Due Date',
      subtitle: 'When is your baby expected to arrive?',
      description: 'Select the date your healthcare provider gave you as your expected delivery date.',
      icon: Icons.baby_changing_station,
      color: primaryColor,
      onTap: () => _selectDate(context, 'due_date'),
    );
  }

  Widget _buildLastPeriodContent() {
    return _buildEnhancedDateInputSection(
      title: 'Last Menstrual Period',
      subtitle: 'First day of your last period',
      description: 'This helps us calculate your pregnancy timeline and due date accurately.',
      icon: Icons.calendar_today,
      color: secondaryColor,
      onTap: () => _selectDate(context, 'last_period'),
    );
  }

  Widget _buildEnhancedDateInputSection({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: selectedDate != null ? LinearGradient(
                colors: [color.withOpacity(0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
              color: selectedDate != null ? null : lightPrimary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selectedDate != null ? color.withOpacity(0.4) : Colors.grey[300]!,
                width: 2,
              ),
              boxShadow: selectedDate != null ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ] : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: selectedDate != null ? LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ) : null,
                    color: selectedDate != null ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: selectedDate != null ? Colors.white : Colors.grey[500],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDate != null 
                            ? _formatDate(selectedDate!)
                            : 'Tap to select date',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selectedDate != null ? Colors.black87 : Colors.grey[500],
                        ),
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _getDateDescription(),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: selectedDate != null ? color : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCurrentWeekContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, secondaryColor],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.timeline, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Week',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'How many weeks pregnant are you?',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Select your current week of pregnancy for personalized information.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [lightPrimary, lightSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 42,
            itemBuilder: (context, index) {
              final week = index + 1;
              final isSelected = selectedWeek == week;
              return GestureDetector(
                onTap: () => setState(() => selectedWeek = week),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: isSelected ? LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ) : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.3) : primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected ? Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ) : null,
                        ),
                        child: Center(
                          child: Text(
                            '$week',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Week $week',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEnhancedActionButtons() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, lightPrimary.withOpacity(0.5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onClose,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: BorderSide(color: Colors.grey[400]!, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: _canContinue() ? const LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ) : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _canContinue() ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ] : null,
              ),
              child: ElevatedButton(
                onPressed: _canContinue() ? _handleContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canContinue() ? Colors.transparent : Colors.grey[300],
                  foregroundColor: _canContinue() ? Colors.white : Colors.grey[500],
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: _canContinue() ? Colors.white : Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDateDescription() {
    if (selectedDate == null) return '';
    final now = DateTime.now();
    final difference = selectedDate!.difference(now).inDays;
    
    if (selectedTab == 'due_date') {
      if (difference > 0) {
        return '$difference days remaining';
      } else {
        return '${difference.abs()} days overdue';
      }
    } else {
      final daysSince = now.difference(selectedDate!).inDays;
      return '$daysSince days ago';
    }
  }

  bool _canContinue() {
    switch (selectedTab) {
      case 'due_date':
      case 'last_period':
        return selectedDate != null;
      case 'current_week':
        return selectedWeek != null;
      default:
        return false;
    }
  }

  void _handleContinue() {
    Map<String, dynamic> pregnancyData = {
      'calculationType': selectedTab,
    };

    switch (selectedTab) {
      case 'due_date':
        pregnancyData['dueDate'] = selectedDate;
        pregnancyData['currentWeek'] = _calculateWeekFromDueDate(selectedDate!);
        break;
      case 'last_period':
        pregnancyData['lastPeriodDate'] = selectedDate;
        pregnancyData['currentWeek'] = _calculateWeekFromLastPeriod(selectedDate!);
        pregnancyData['dueDate'] = _calculateDueDateFromLastPeriod(selectedDate!);
        break;
      case 'current_week':
        pregnancyData['currentWeek'] = selectedWeek;
        pregnancyData['dueDate'] = _calculateDueDateFromCurrentWeek(selectedWeek!);
        break;
    }

    widget.onComplete(pregnancyData);
  }

  int _calculateWeekFromDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final daysSinceLMP = 280 - dueDate.difference(now).inDays;
    return (daysSinceLMP / 7).floor();
  }

  int _calculateWeekFromLastPeriod(DateTime lastPeriod) {
    final now = DateTime.now();
    final daysSinceLMP = now.difference(lastPeriod).inDays;
    return (daysSinceLMP / 7).floor();
  }

  DateTime _calculateDueDateFromLastPeriod(DateTime lastPeriod) {
    return lastPeriod.add(const Duration(days: 280));
  }

  DateTime _calculateDueDateFromCurrentWeek(int currentWeek) {
    final now = DateTime.now();
    final remainingWeeks = 40 - currentWeek;
    return now.add(Duration(days: remainingWeeks * 7));
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
      lastDate: DateTime.now().add(const Duration(days: 300)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              secondary: secondaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}