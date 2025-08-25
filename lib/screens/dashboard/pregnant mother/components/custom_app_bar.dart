import 'package:flutter/material.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:obaatanpa_mobile/screens/dashboard/help_support_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/preferences_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/profile_settings_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/notification_page.dart'; // Add this import
import 'package:provider/provider.dart';

// Custom App Bar Component with Dark Mode Support and Profile Dropdown
class CustomAppBar extends StatelessWidget {
  final bool isMenuOpen;
  final VoidCallback onMenuTap;

  const CustomAppBar({
    Key? key,
    required this.isMenuOpen,
    required this.onMenuTap, required String title,
  }) : super(key: key);

  void _showProfileMenu(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 120, 0, 0), // Position near the profile
      color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                color: isDark ? Colors.white : Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Profile Settings',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'preferences',
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: isDark ? Colors.white : Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Preferences',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'help',
          child: Row(
            children: [
              Icon(
                Icons.help_outline,
                color: isDark ? Colors.white : Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Help & Support',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Divider
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(
                Icons.logout,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      // Handle menu selection
      if (value != null) {
        _handleMenuSelection(context, value);
      }
    });
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        // Navigate to profile settings
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileSettingsPage(),
          ),
        );
        break;
      case 'preferences':
        // Navigate to preferences
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PreferencesPage(),
          ),
        );
        break;
      case 'help':
        // Navigate to help
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HelpSupportPage(),
          ),
        );
        break;
      case 'logout':
        // Show logout confirmation
        _showLogoutDialog(context);
        break;
    }
  }

  // Handle notification tap - Navigate to notification page
  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
            'Logout',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
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
                Navigator.of(context).pop(); // Close dialog
                // Handle logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    duration: Duration(milliseconds: 1000),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // TODO: Implement actual logout logic
                // e.g., clear user data, navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          // Top row - Logo and title centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/navbar/maternity-logo.png', // Replace with your logo path
                    fit: BoxFit.cover,
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to the original design if image fails to load
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8BBD9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 18,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Obaatanpa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Your Pregnancy Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Bottom row - Controls and user info
          Row(
            children: [
              // Left side - Menu and dark mode toggle
              Row(
                children: [
                  // Menu icon
                  GestureDetector(
                    onTap: onMenuTap,
                    child: Icon(
                      isMenuOpen ? Icons.close : Icons.menu,
                      color: textColor,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Dark mode toggle button
                  GestureDetector(
                    onTap: () {
                      themeProvider.toggleTheme();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isDark ? 'Switched to Light Mode' : 'Switched to Dark Mode',
                          ),
                          duration: const Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark 
                          ? const Color(0xFFF8BBD9).withOpacity(0.2)
                          : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                        color: isDark ? const Color(0xFFF8BBD9) : textColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Spacer to center the greeting
              const Spacer(),
              
              // Center - Greeting
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hello, ',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'Abba',
                      style: TextStyle(
                        color: const Color(0xFFF8BBD9),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Spacer to push right content to the end
              const Spacer(),
              
              // Right side - Notification and profile
              Row(
                children: [
                  // Notification icon - Updated with tap functionality
                  GestureDetector(
                    onTap: () => _navigateToNotifications(context),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: textColor,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Profile section with dropdown
                  GestureDetector(
                    onTap: () => _showProfileMenu(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/navbar/profile-1.png', // Replace with your profile image path
                              fit: BoxFit.cover,
                              width: 32,
                              height: 32,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to default person icon if image fails to load
                                return Icon(
                                  Icons.person,
                                  color: isDark ? Colors.white : Colors.grey[600],
                                  size: 18,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: textColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}