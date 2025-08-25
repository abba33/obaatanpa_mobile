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

class _PregnancyInfoPopupState extends State<PregnancyInfoPopup> {
  String selectedTab = 'due_date';
  DateTime? selectedDate;
  int? selectedWeek;

  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController lastPeriodController = TextEditingController();

  // Updated color scheme
  static const Color primaryColor = Color(0xFFF59297);
  static const Color secondaryColor = Color(0xFF7DA8E6);
  static const Color lightPrimary = Color(0xFFFFF2F3);
  static const Color lightSecondary = Color(0xFFF0F6FF);

  @override
  void dispose() {
    dueDateController.dispose();
    lastPeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.92,
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(child: _buildTabContent()),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '🤰',
              style: TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregnancy Journey',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Let\'s personalize your experience with the right information',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '✖️',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildTab('due_date', 'Due Date', '📅'),
            _buildTab('last_period', 'Last Period', '🗓️'),
            _buildTab('current_week', 'Current Week', '📊'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String tabId, String title, String emoji) {
    final isSelected = selectedTab == tabId;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedTab = tabId;
          selectedDate = null;
          selectedWeek = null;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: TextStyle(
                  fontSize: 18,
                  color: isSelected ? Colors.white : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedTab == 'due_date') _buildDueDateContent(),
          if (selectedTab == 'last_period') _buildLastPeriodContent(),
          if (selectedTab == 'current_week') _buildCurrentWeekContent(),
        ],
      ),
    );
  }

  Widget _buildDueDateContent() {
    return _buildDateInputSection(
      title: 'Expected Due Date',
      subtitle: 'When is your baby expected to arrive?',
      description: 'Select the date your healthcare provider gave you as your expected delivery date.',
      onTap: () => _selectDate(context, 'due_date'),
    );
  }

  Widget _buildLastPeriodContent() {
    return _buildDateInputSection(
      title: 'Last Menstrual Period',
      subtitle: 'First day of your last period',
      description: 'This helps us calculate your pregnancy timeline and due date accurately.',
      onTap: () => _selectDate(context, 'last_period'),
    );
  }

  Widget _buildDateInputSection({
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: selectedDate != null ? lightPrimary : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedDate != null ? primaryColor.withOpacity(0.3) : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedDate != null ? primaryColor.withOpacity(0.1) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: selectedDate != null ? primaryColor : Colors.grey[500],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDate != null 
                            ? _formatDate(selectedDate!)
                            : 'Select Date',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedDate != null ? Colors.black87 : Colors.grey[500],
                        ),
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _getDateDescription(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  '▶️',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null ? primaryColor : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeekContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Current Pregnancy Week',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How many weeks pregnant are you?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Select your current week of pregnancy. This will help us provide you with relevant information.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: lightPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 42,
            itemBuilder: (context, index) {
              final week = index + 1;
              final isSelected = selectedWeek == week;
              return GestureDetector(
                onTap: () => setState(() => selectedWeek = week),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.2) : primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$week',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Week $week',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      if (isSelected) ...[
                        const Spacer(),
                        const Text(
                          '✅',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onClose,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _canContinue() ? _handleContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canContinue() ? null : Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: _canContinue() ? 4 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                backgroundColor: _canContinue() 
                    ? MaterialStateProperty.all(null)
                    : MaterialStateProperty.all(Colors.grey[300]),
                foregroundColor: _canContinue()
                    ? MaterialStateProperty.all(Colors.white)
                    : MaterialStateProperty.all(Colors.grey[500]),
              ),
              child: Container(
                decoration: _canContinue() ? const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ) : null,
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '➡️',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
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