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

  // Refined color scheme
  static const Color primaryColor = Color(0xFFF59297);
  static const Color secondaryColor = Color(0xFF7DA8E6);
  static const Color lightPrimary = Color(0xFFFEFBFC);
  static const Color lightSecondary = Color(0xFFF8FBFE);
  static const Color neutralGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFFF9FAFB);

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
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 0,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildRefinedHeader(),
                  _buildMinimalTabBar(),
                  Expanded(child: _buildTabContent()),
                  _buildRefinedActionButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRefinedHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.05),
            secondaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.pregnant_woman,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregnancy Timeline',
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Help us personalize your experience',
                  style: GoogleFonts.inter(
                    color: neutralGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(
              Icons.close,
              color: neutralGray,
              size: 20,
            ),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: lightGray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalTabBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: lightGray,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildMinimalTab('due_date', 'Due Date', Icons.event_available),
            _buildMinimalTab('last_period', 'Last Period', Icons.calendar_today),
            _buildMinimalTab('current_week', 'Current Week', Icons.timeline),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalTab(String tabId, String title, IconData icon) {
    final isSelected = selectedTab == tabId;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedTab = tabId;
          selectedDate = null;
          selectedWeek = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? primaryColor : neutralGray.withOpacity(0.6),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.black87 : neutralGray.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
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
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
    return _buildRefinedDateInputSection(
      title: 'Expected Due Date',
      subtitle: 'When is your baby expected to arrive?',
      description: 'Enter the estimated delivery date provided by your healthcare provider.',
      icon: Icons.event_available,
      color: primaryColor,
      onTap: () => _selectDate(context, 'due_date'),
    );
  }

  Widget _buildLastPeriodContent() {
    return _buildRefinedDateInputSection(
      title: 'Last Menstrual Period',
      subtitle: 'First day of your last period',
      description: 'This helps calculate your pregnancy timeline and estimated due date.',
      icon: Icons.calendar_today,
      color: secondaryColor,
      onTap: () => _selectDate(context, 'last_period'),
    );
  }

  Widget _buildRefinedDateInputSection({
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
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: neutralGray,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: neutralGray.withOpacity(0.8),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selectedDate != null ? color.withOpacity(0.04) : lightGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedDate != null ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedDate != null ? color : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: selectedDate != null ? Colors.white : neutralGray.withOpacity(0.5),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDate != null 
                            ? _formatDate(selectedDate!)
                            : 'Select date',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: selectedDate != null ? Colors.black87 : neutralGray.withOpacity(0.6),
                        ),
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _getDateDescription(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: selectedDate != null ? color : neutralGray.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCurrentWeekContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Current Week',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'How many weeks pregnant are you?',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: neutralGray,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Select your current week of pregnancy for personalized information.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: neutralGray.withOpacity(0.8),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: lightGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 42,
            itemBuilder: (context, index) {
              final week = index + 1;
              final isSelected = selectedWeek == week;
              return GestureDetector(
                onTap: () => setState(() => selectedWeek = week),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? null : Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.2) : primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '$week',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Week $week',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRefinedActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onClose,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: neutralGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _canContinue() ? _handleContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canContinue() ? primaryColor : Colors.grey.withOpacity(0.2),
                foregroundColor: _canContinue() ? Colors.white : neutralGray.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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