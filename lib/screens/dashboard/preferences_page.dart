import 'package:flutter/material.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _appointmentReminders = true;
  bool _medicationReminders = true;
  bool _weeklyUpdates = true;
  bool _educationalContent = true;
  bool _biometricLogin = false;
  bool _autoBackup = true;
  
  String _selectedLanguage = 'English';
  String _selectedDateFormat = 'DD/MM/YYYY';
  String _selectedTimeFormat = '12 Hour';
  
  final List<String> _languages = ['English', 'Twi', 'Ga', 'Ewe', 'Fante'];
  final List<String> _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
  final List<String> _timeFormats = ['12 Hour', '24 Hour'];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Preferences',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Appearance Section
          _buildSectionCard(
            title: 'App Appearance',
            icon: Icons.palette_outlined,
            children: [
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Use dark theme for better night viewing',
                value: isDark,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                icon: Icons.dark_mode_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Language & Region Section
          _buildSectionCard(
            title: 'Language & Region',
            icon: Icons.language,
            children: [
              _buildDropdownTile(
                title: 'Language',
                subtitle: 'Choose your preferred language',
                value: _selectedLanguage,
                items: _languages,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language changed to $_selectedLanguage'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: Icons.translate,
              ),
              _buildDropdownTile(
                title: 'Date Format',
                subtitle: 'How dates are displayed',
                value: _selectedDateFormat,
                items: _dateFormats,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDateFormat = newValue!;
                  });
                },
                icon: Icons.date_range,
              ),
              _buildDropdownTile(
                title: 'Time Format',
                subtitle: 'How time is displayed',
                value: _selectedTimeFormat,
                items: _timeFormats,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeFormat = newValue!;
                  });
                },
                icon: Icons.access_time,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Notifications Section
          _buildSectionCard(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            children: [
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
                icon: Icons.notifications_active,
              ),
              _buildSwitchTile(
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
                icon: Icons.email_outlined,
              ),
              _buildSwitchTile(
                title: 'Appointment Reminders',
                subtitle: 'Get reminded about upcoming appointments',
                value: _appointmentReminders,
                onChanged: (value) {
                  setState(() {
                    _appointmentReminders = value;
                  });
                },
                icon: Icons.event_note,
              ),
              _buildSwitchTile(
                title: 'Medication Reminders',
                subtitle: 'Get reminded to take medications',
                value: _medicationReminders,
                onChanged: (value) {
                  setState(() {
                    _medicationReminders = value;
                  });
                },
                icon: Icons.medication,
              ),
              _buildSwitchTile(
                title: 'Weekly Pregnancy Updates',
                subtitle: 'Receive weekly pregnancy information',
                value: _weeklyUpdates,
                onChanged: (value) {
                  setState(() {
                    _weeklyUpdates = value;
                  });
                },
                icon: Icons.update,
              ),
              _buildSwitchTile(
                title: 'Educational Content',
                subtitle: 'Receive tips and educational materials',
                value: _educationalContent,
                onChanged: (value) {
                  setState(() {
                    _educationalContent = value;
                  });
                },
                icon: Icons.school_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Security & Privacy Section
          _buildSectionCard(
            title: 'Security & Privacy',
            icon: Icons.security,
            children: [
              _buildSwitchTile(
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or face unlock',
                value: _biometricLogin,
                onChanged: (value) {
                  setState(() {
                    _biometricLogin = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value 
                        ? 'Biometric login enabled' 
                        : 'Biometric login disabled'
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: Icons.fingerprint,
              ),
              _buildTile(
                title: 'Change Password',
                subtitle: 'Update your account password',
                icon: Icons.lock_outline,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password change feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                showArrow: true,
              ),
              _buildTile(
                title: 'Privacy Policy',
                subtitle: 'View our privacy policy',
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening privacy policy...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                showArrow: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Data & Storage Section
          _buildSectionCard(
            title: 'Data & Storage',
            icon: Icons.storage,
            children: [
              _buildSwitchTile(
                title: 'Auto Backup',
                subtitle: 'Automatically backup your data',
                value: _autoBackup,
                onChanged: (value) {
                  setState(() {
                    _autoBackup = value;
                  });
                },
                icon: Icons.backup,
              ),
              _buildTile(
                title: 'Clear Cache',
                subtitle: 'Free up space by clearing app cache',
                icon: Icons.clear_all,
                onTap: () {
                  _showClearCacheDialog();
                },
                showArrow: false,
              ),
              _buildTile(
                title: 'Export Data',
                subtitle: 'Download your pregnancy data',
                icon: Icons.download,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data export feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                showArrow: true,
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFF8BBD9),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: subtitleColor,
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFF8BBD9),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;

    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: subtitleColor,
          fontSize: 12,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        style: TextStyle(color: textColor),
        dropdownColor: cardColor,
        underline: Container(),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool showArrow,
  }) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: subtitleColor,
          fontSize: 12,
        ),
      ),
      trailing: showArrow
          ? Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 16,
            )
          : null,
      onTap: onTap,
    );
  }

  void _showClearCacheDialog() {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Clear Cache',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'This will clear temporary files and may free up storage space. Your personal data will not be affected.',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully!'),
                    duration: Duration(milliseconds: 1000),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8BBD9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}